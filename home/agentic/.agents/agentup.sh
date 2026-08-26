#!/usr/bin/env bash

set -euo pipefail

agents_source_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
instructions_source="$agents_source_root/AGENTS.md"
authored_skills_root="$agents_source_root/skills"
home_directory="${HOME:?HOME must be set}"
agents_destination="$home_directory/.agents"
instructions_destination="$agents_destination/AGENTS.md"
skills_destination="$agents_destination/skills"
state_directory="$home_directory/.local/state/agentic"
known_aliases=(
  "$home_directory/.claude/CLAUDE.md"
  "$home_directory/.claude/skills"
  "$home_directory/.codex/AGENTS.md"
  "$home_directory/.pi/agent/AGENTS.md"
)
mode=manual
mode_was_set=false
enable_claude=false
enable_codex=false
enable_pi=false
collections=()
explicit_skills=()

usage() {
  cat <<'EOF'
Usage: agentup.sh [mode] [options]

Without a mode, synchronize authored Agent resources and retain the tool set
recorded by the latest Home Manager reconciliation.

Modes:
  --reconcile       Reconcile all resources during Home Manager activation.
  --disable         Remove resources recorded as installer-owned.

Reconciliation options:
  --claude          Create Claude resource aliases.
  --codex           Create Codex resource aliases.
  --pi              Create Pi resource aliases.
  --collection DIR  Install every non-deprecated Skill below DIR.
  --skill NAME=DIR  Install the Skill in DIR as NAME.

Testing option:
  --state-dir DIR   Override the state directory.

Other options:
  -h, --help        Show this help.
EOF
}

set_mode() {
  local requested_mode="$1"
  if $mode_was_set; then
    echo "error: only one synchronization mode may be selected" >&2
    exit 2
  fi
  mode="$requested_mode"
  mode_was_set=true
}

while (($# > 0)); do
  case "$1" in
  --reconcile)
    set_mode reconcile
    shift
    ;;
  --disable)
    set_mode disable
    shift
    ;;
  --claude)
    enable_claude=true
    shift
    ;;
  --codex)
    enable_codex=true
    shift
    ;;
  --pi)
    enable_pi=true
    shift
    ;;
  --collection)
    collections+=("${2:?--collection requires a directory}")
    shift 2
    ;;
  --skill)
    explicit_skills+=("${2:?--skill requires NAME=DIR}")
    shift 2
    ;;
  --state-dir)
    state_directory="${2:?--state-dir requires a directory}"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "error: unknown argument: $1" >&2
    usage >&2
    exit 2
    ;;
  esac
done

if [[ "$home_directory" != /* || "$state_directory" != /* ]]; then
  echo "error: HOME and the state directory must be absolute paths" >&2
  exit 1
fi

if [[ "$mode" != reconcile ]] && { $enable_claude || $enable_codex || $enable_pi || ((${#collections[@]} > 0)) || ((${#explicit_skills[@]} > 0)); }; then
  echo "error: tool and third-party Skill options require --reconcile" >&2
  exit 2
fi

skills_state_directory="$state_directory/skills"
mkdir -p "$skills_state_directory"
exec 9>"$state_directory/lock"
if ! flock -n 9; then
  echo "error: another Agent resource synchronization is already running" >&2
  exit 1
fi

plan="$(mktemp "$state_directory/plan.XXXXXX")"
desired_authored="$(mktemp "$skills_state_directory/authored.XXXXXX")"
desired_third_party="$(mktemp "$skills_state_directory/third-party.XXXXXX")"
desired_tools="$(mktemp "$state_directory/tools.XXXXXX")"
desired_aliases="$(mktemp "$state_directory/aliases.XXXXXX")"
alias_plan="$(mktemp "$state_directory/alias-plan.XXXXXX")"
authored_manifest="$skills_state_directory/authored"
third_party_manifest="$skills_state_directory/third-party"
tools_manifest="$state_directory/tools"
instructions_manifest="$state_directory/instructions"
aliases_manifest="$state_directory/aliases"
pending_skills="$skills_state_directory/pending"
pending_instructions="$state_directory/pending-instructions"
pending_aliases="$state_directory/pending-aliases"
active_stage=""

cleanup() {
  rm -f \
    "$plan" \
    "$desired_authored" \
    "$desired_third_party" \
    "$desired_tools" \
    "$desired_aliases" \
    "$alias_plan"
  if [[ -n "$active_stage" ]]; then
    rm -rf -- "$active_stage"
  fi
}
trap cleanup EXIT

touch \
  "$authored_manifest" \
  "$third_party_manifest" \
  "$tools_manifest" \
  "$instructions_manifest" \
  "$aliases_manifest"

contains_line() {
  local value="$1"
  local file="$2"
  grep -Fxq -- "$value" "$file"
}

validate_name() {
  local name="$1"
  if [[ ! "$name" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
    echo "error: invalid installed Skill name: $name" >&2
    exit 1
  fi
}

add_skill() {
  local kind="$1"
  local name="$2"
  local source="$3"
  local manifest="$desired_authored"

  validate_name "$name"
  if [[ ! -r "$source/SKILL.md" ]]; then
    echo "error: missing or unreadable SKILL.md: $source/SKILL.md" >&2
    exit 1
  fi
  if cut -f 2 "$plan" | grep -Fxq -- "$name"; then
    echo "error: duplicate installed Skill name: $name" >&2
    exit 1
  fi

  if [[ "$kind" == third-party ]]; then
    manifest="$desired_third_party"
  fi
  printf '%s\n' "$name" >>"$manifest"
  printf '%s\t%s\t%s\n' "$kind" "$name" "$source" >>"$plan"
}

add_alias() {
  local path="$1"
  local target="$2"

  if contains_line "$path" "$desired_aliases"; then
    echo "error: duplicate Agent resource alias: $path" >&2
    exit 1
  fi
  printf '%s\n' "$path" >>"$desired_aliases"
  printf '%s\t%s\n' "$path" "$target" >>"$alias_plan"
}

validate_tool() {
  case "$1" in
  claude | codex | pi) ;;
  *)
    echo "error: invalid tool in state manifest: $1" >&2
    exit 1
    ;;
  esac
}

is_known_alias_path() {
  case "$1" in
  "$home_directory/.claude/CLAUDE.md" | \
    "$home_directory/.claude/skills" | \
    "$home_directory/.codex/AGENTS.md" | \
    "$home_directory/.pi/agent/AGENTS.md") return 0 ;;
  *) return 1 ;;
  esac
}

validate_skill_manifest() {
  local manifest="$1"
  [[ -f "$manifest" ]] || return 0
  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    validate_name "$name"
  done <"$manifest"
}

validate_alias_manifest() {
  local manifest="$1"
  [[ -f "$manifest" ]] || return 0
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if ! is_known_alias_path "$path"; then
      echo "error: invalid path in Agent resource alias manifest: $path" >&2
      exit 1
    fi
  done <"$manifest"
}

validate_instruction_manifest() {
  local manifest="$1"
  [[ -f "$manifest" ]] || return 0
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if [[ "$path" != "$instructions_destination" ]]; then
      echo "error: invalid path in Agent instructions manifest: $path" >&2
      exit 1
    fi
  done <"$manifest"
}

validate_skill_manifest "$authored_manifest"
validate_skill_manifest "$third_party_manifest"
validate_skill_manifest "$pending_skills"
validate_alias_manifest "$aliases_manifest"
validate_alias_manifest "$pending_aliases"
validate_instruction_manifest "$instructions_manifest"
validate_instruction_manifest "$pending_instructions"

if [[ "$mode" != disable ]]; then
  if [[ ! -r "$instructions_source" ]]; then
    echo "error: missing or unreadable Agent instructions: $instructions_source" >&2
    exit 1
  fi
  if [[ ! -d "$authored_skills_root" ]]; then
    echo "error: missing authored Skills directory: $authored_skills_root" >&2
    exit 1
  fi

  while IFS= read -r -d '' skill_file; do
    skill_dir="$(dirname "$skill_file")"
    add_skill authored "$(basename "$skill_dir")" "$skill_dir"
  done < <(find "$authored_skills_root" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print0 | sort -z)
fi

case "$mode" in
manual)
  while IFS= read -r tool; do
    [[ -z "$tool" ]] && continue
    validate_tool "$tool"
    printf '%s\n' "$tool" >>"$desired_tools"
  done <"$tools_manifest"
  ;;
reconcile)
  $enable_claude && printf 'claude\n' >>"$desired_tools"
  $enable_codex && printf 'codex\n' >>"$desired_tools"
  $enable_pi && printf 'pi\n' >>"$desired_tools"

  for collection in "${collections[@]}"; do
    if [[ ! -d "$collection" ]]; then
      echo "error: missing third-party Skill collection: $collection" >&2
      exit 1
    fi
    while IFS= read -r -d '' skill_file; do
      skill_dir="$(dirname "$skill_file")"
      add_skill third-party "$(basename "$skill_dir")" "$skill_dir"
    done < <(
      find "$collection" \
        -name SKILL.md \
        -not -path '*/node_modules/*' \
        -not -path '*/deprecated/*' \
        -print0 | sort -z
    )
  done

  for specification in "${explicit_skills[@]}"; do
    if [[ "$specification" != *=* ]]; then
      echo "error: --skill expects NAME=DIR: $specification" >&2
      exit 2
    fi
    add_skill third-party "${specification%%=*}" "${specification#*=}"
  done
  ;;
disable) ;;
esac

sort -u -o "$desired_authored" "$desired_authored"
sort -u -o "$desired_third_party" "$desired_third_party"
sort -u -o "$desired_tools" "$desired_tools"

if [[ "$mode" == manual ]]; then
  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    if contains_line "$name" "$third_party_manifest"; then
      echo "error: authored Skill conflicts with installed third-party Skill: $name" >&2
      exit 1
    fi
  done <"$desired_authored"
fi

while IFS= read -r tool; do
  case "$tool" in
  claude)
    add_alias "$home_directory/.claude/CLAUDE.md" "$instructions_destination"
    add_alias "$home_directory/.claude/skills" "$skills_destination"
    ;;
  codex)
    add_alias "$home_directory/.codex/AGENTS.md" "$instructions_destination"
    ;;
  pi)
    add_alias "$home_directory/.pi/agent/AGENTS.md" "$instructions_destination"
    ;;
  esac
done <"$desired_tools"
sort -u -o "$desired_aliases" "$desired_aliases"

validate_parent_path() {
  local path="$1"
  local parent
  parent="$(dirname "$path")"

  while [[ "$parent" == "$home_directory"/* ]]; do
    if [[ (-e "$parent" || -L "$parent") && ! -d "$parent" ]]; then
      echo "error: Agent resource parent is not a directory: $parent" >&2
      exit 1
    fi
    parent="$(dirname "$parent")"
  done
}

is_managed_instruction() {
  contains_line "$instructions_destination" "$instructions_manifest" ||
    { [[ -f "$pending_instructions" ]] && contains_line "$instructions_destination" "$pending_instructions"; }
}

is_legacy_instruction_link() {
  local path="$1"
  local resolved
  [[ -L "$path" ]] || return 1
  resolved="$(readlink -f "$path" || true)"
  [[ "$resolved" == "$instructions_source" || "$resolved" == "$instructions_destination" ]]
}

is_managed_alias() {
  local path="$1"
  contains_line "$path" "$aliases_manifest" ||
    { [[ -f "$pending_aliases" ]] && contains_line "$path" "$pending_aliases"; }
}

is_legacy_alias() {
  local path="$1"
  local resolved
  [[ -L "$path" ]] || return 1
  resolved="$(readlink -f "$path" || true)"
  case "$path" in
  "$home_directory/.claude/skills")
    [[ "$resolved" == "$authored_skills_root" || "$resolved" == "$skills_destination" ]]
    ;;
  *)
    [[ "$resolved" == "$instructions_source" || "$resolved" == "$instructions_destination" ]]
    ;;
  esac
}

legacy_skills_destination=false
if [[ -L "$skills_destination" ]]; then
  resolved_skills_destination="$(readlink -f "$skills_destination" || true)"
  if [[ "$resolved_skills_destination" == "$authored_skills_root" ]]; then
    legacy_skills_destination=true
  else
    echo "error: refusing to replace unmanaged Skills directory link: $skills_destination" >&2
    exit 1
  fi
elif [[ (-e "$skills_destination" || -L "$skills_destination") && ! -d "$skills_destination" ]]; then
  echo "error: Skills destination is not a directory: $skills_destination" >&2
  exit 1
fi

if [[ "$mode" != disable ]]; then
  validate_parent_path "$instructions_destination"
  if [[ -e "$instructions_destination" || -L "$instructions_destination" ]]; then
    if ! is_managed_instruction && ! is_legacy_instruction_link "$instructions_destination"; then
      echo "error: refusing to overwrite unmanaged Agent instructions: $instructions_destination" >&2
      exit 1
    fi
  fi
fi

while IFS=$'\t' read -r path _target; do
  validate_parent_path "$path"
  if [[ -e "$path" || -L "$path" ]]; then
    if ! is_managed_alias "$path" && ! is_legacy_alias "$path"; then
      echo "error: refusing to overwrite unmanaged Agent resource alias: $path" >&2
      exit 1
    fi
  fi
done <"$alias_plan"

is_managed_skill() {
  local name="$1"
  contains_line "$name" "$authored_manifest" ||
    contains_line "$name" "$third_party_manifest" ||
    { [[ -f "$pending_skills" ]] && contains_line "$name" "$pending_skills"; }
}

legacy_skills_root="$home_directory/.local/share/agentic/sources/mattpocock-skills/skills"
is_legacy_skill_link() {
  local target="$1"
  [[ -L "$target" ]] || return 1
  case "$(readlink "$target")" in
  "$legacy_skills_root"/*) return 0 ;;
  *) return 1 ;;
  esac
}

if ! $legacy_skills_destination; then
  while IFS=$'\t' read -r _kind name _source; do
    target="$skills_destination/$name"
    if [[ -e "$target" || -L "$target" ]]; then
      if ! is_managed_skill "$name" && ! is_legacy_skill_link "$target"; then
        echo "error: refusing to overwrite unmanaged Skill: $target" >&2
        exit 1
      fi
    fi
  done <"$plan"
fi

{
  cat "$desired_authored"
  if [[ "$mode" == manual ]]; then
    cat "$third_party_manifest"
  else
    cat "$desired_third_party"
  fi
} | sort -u >"$pending_skills.tmp"
mv -Tf "$pending_skills.tmp" "$pending_skills"
if [[ "$mode" != disable ]]; then
  printf '%s\n' "$instructions_destination" >"$pending_instructions.tmp"
else
  : >"$pending_instructions.tmp"
fi
mv -Tf "$pending_instructions.tmp" "$pending_instructions"
cp "$desired_aliases" "$pending_aliases.tmp"
mv -Tf "$pending_aliases.tmp" "$pending_aliases"

# A manual run can remove links created by the previous runtime Git installer.
# The switch-time source is an immutable Nix store snapshot.
if [[ -w "$authored_skills_root" ]]; then
  while IFS= read -r -d '' legacy_link; do
    case "$(readlink "$legacy_link")" in
    "$legacy_skills_root"/*) rm "$legacy_link" ;;
    esac
  done < <(find "$authored_skills_root" -mindepth 1 -maxdepth 1 -type l -print0)
fi

if $legacy_skills_destination; then
  unlink "$skills_destination"
fi

remove_managed_path() {
  local path="$1"
  if [[ -d "$path" && ! -L "$path" ]]; then
    rm -rf -- "${path:?}"
  else
    rm -f -- "$path"
  fi
}

if [[ "$mode" != disable ]]; then
  mkdir -p "$agents_destination" "$skills_destination"
  install -m 0644 "$instructions_source" "$agents_destination/.AGENTS.md.tmp.$$"
  if [[ -d "$instructions_destination" && ! -L "$instructions_destination" ]]; then
    remove_managed_path "$instructions_destination"
  fi
  mv -Tf "$agents_destination/.AGENTS.md.tmp.$$" "$instructions_destination"
fi

sync_skill() {
  local name="$1"
  local source="$2"
  local target="$skills_destination/$name"

  if is_legacy_skill_link "$target"; then
    unlink "$target"
  fi

  if [[ ! -e "$target" ]]; then
    active_stage="$skills_destination/.$name.tmp.$$"
    rm -rf -- "$active_stage"
    mkdir "$active_stage"
    rsync -aL --no-owner --no-group --chmod=u+rwX "$source/" "$active_stage/"
    if [[ ! -r "$active_stage/SKILL.md" ]]; then
      echo "error: staged Skill is invalid: $name" >&2
      exit 1
    fi
    mv "$active_stage" "$target"
    active_stage=""
    return
  fi

  if [[ ! -d "$target" || -L "$target" ]]; then
    echo "error: managed Skill target is not a directory: $target" >&2
    exit 1
  fi

  rsync -aL --delete --exclude=/SKILL.md --no-owner --no-group --chmod=u+rwX "$source/" "$target/"
  install -m 0644 "$source/SKILL.md" "$target/.SKILL.md.tmp.$$"
  mv -Tf "$target/.SKILL.md.tmp.$$" "$target/SKILL.md"
}

if [[ "$mode" != disable ]]; then
  while IFS=$'\t' read -r _kind name source; do
    sync_skill "$name" "$source"
  done <"$plan"
fi

remove_stale_skills() {
  local old_manifest="$1"
  local desired_manifest="$2"

  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    if ! contains_line "$name" "$desired_manifest"; then
      remove_managed_path "${skills_destination:?}/$name"
    fi
  done <"$old_manifest"
}

remove_stale_skills "$authored_manifest" "$desired_authored"
if [[ "$mode" != manual ]]; then
  remove_stale_skills "$third_party_manifest" "$desired_third_party"
fi

while IFS=$'\t' read -r path target; do
  mkdir -p "$(dirname "$path")"
  if [[ -d "$path" && ! -L "$path" ]]; then
    remove_managed_path "$path"
  fi
  temporary_link="$(dirname "$path")/.$(basename "$path").tmp.$$"
  rm -f -- "$temporary_link"
  ln -s "$target" "$temporary_link"
  mv -Tf "$temporary_link" "$path"
done <"$alias_plan"

while IFS= read -r path; do
  [[ -z "$path" ]] && continue
  if ! contains_line "$path" "$desired_aliases"; then
    remove_managed_path "$path"
  fi
done <"$aliases_manifest"

for path in "${known_aliases[@]}"; do
  if ! contains_line "$path" "$desired_aliases" && is_legacy_alias "$path"; then
    remove_managed_path "$path"
  fi
done

if [[ "$mode" == disable ]]; then
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    remove_managed_path "$path"
  done <"$instructions_manifest"
  if is_legacy_instruction_link "$instructions_destination"; then
    remove_managed_path "$instructions_destination"
  fi
fi

install -m 0644 "$desired_authored" "$authored_manifest.tmp"
mv -Tf "$authored_manifest.tmp" "$authored_manifest"
if [[ "$mode" != manual ]]; then
  install -m 0644 "$desired_third_party" "$third_party_manifest.tmp"
  mv -Tf "$third_party_manifest.tmp" "$third_party_manifest"
fi
if [[ "$mode" != disable ]]; then
  printf '%s\n' "$instructions_destination" >"$instructions_manifest.tmp"
  mv -Tf "$instructions_manifest.tmp" "$instructions_manifest"
else
  : >"$instructions_manifest"
fi
install -m 0644 "$desired_aliases" "$aliases_manifest.tmp"
mv -Tf "$aliases_manifest.tmp" "$aliases_manifest"
if [[ "$mode" != manual ]]; then
  install -m 0644 "$desired_tools" "$tools_manifest.tmp"
  mv -Tf "$tools_manifest.tmp" "$tools_manifest"
fi
rm -f "$pending_skills" "$pending_instructions" "$pending_aliases"
