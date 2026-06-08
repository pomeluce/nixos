{
  lib,
  config,
  pkgs,
  ...
}:
let
  mo = config.mo;
  sshDir = "${config.home.homeDirectory}/.ssh";
  devspace = mo.devspace;
in
{
  home.activation = {
    # 步骤1: 部署 SSH 密钥到 ~/.ssh/
    ensureSSH = lib.hm.dag.entryAfter [ "sops-nix" ] ''
      set -euo pipefail
      mkdir -p "${sshDir}"
      chmod 700 "${sshDir}"

      # id_github — GitHub 仓库拉取
      GH_KEY="${config.sops.secrets.ID_GITHUB.path}"
      GH_PUB="${config.sops.secrets.ID_GITHUB_PUB.path}"
      if [ -f "$GH_KEY" ]; then
        install -m 600 "$GH_KEY" "${sshDir}/id_github"
        echo "ensureSSH: deployed id_github"
      else
        echo "ensureSSH: SKIP id_github — secret file not found at $GH_KEY" >&2
      fi
      if [ -f "$GH_PUB" ]; then
        install -m 644 "$GH_PUB" "${sshDir}/id_github.pub"
      fi

      # id_sops — sops 加解密
      SOPS_KEY="${config.sops.secrets.ID_SOPS.path}"
      SOPS_PUB="${config.sops.secrets.ID_SOPS_PUB.path}"
      if [ -f "$SOPS_KEY" ]; then
        install -m 600 "$SOPS_KEY" "${sshDir}/id_sops"
        echo "ensureSSH: deployed id_sops"
      else
        echo "ensureSSH: SKIP id_sops — secret file not found at $SOPS_KEY" >&2
      fi
      if [ -f "$SOPS_PUB" ]; then
        install -m 644 "$SOPS_PUB" "${sshDir}/id_sops.pub"
      fi

      # id_ssh — SSH 远程连接
      SSH_KEY="${config.sops.secrets.ID_SSH.path}"
      SSH_PUB="${config.sops.secrets.ID_SSH_PUB.path}"
      if [ -f "$SSH_KEY" ]; then
        install -m 600 "$SSH_KEY" "${sshDir}/id_ssh"
        echo "ensureSSH: deployed id_ssh"
      else
        echo "ensureSSH: SKIP id_ssh — secret file not found at $SSH_KEY" >&2
      fi
      if [ -f "$SSH_PUB" ]; then
        install -m 644 "$SSH_PUB" "${sshDir}/id_ssh.pub"
      fi

      # 更新 known_hosts 添加 GitHub(静默处理网络异常)
      if [ -f "${sshDir}/id_github" ]; then
        if ! ssh-keygen -F ssh.github.com -f "${sshDir}/known_hosts" >/dev/null 2>&1; then
          ssh-keyscan -p 443 ssh.github.com >> "${sshDir}/known_hosts" 2>/dev/null || true
        fi
      fi
    '';

    # 步骤2: 创建 devspace 二级目录
    ensureDevspace = lib.hm.dag.entryAfter [ "ensureSSH" ] ''
      set -euo pipefail
      mkdir -p \
        "${devspace}" \
        "${devspace}/var" \
        "${devspace}/var/gradle" \
        "${devspace}/var/golib" \
        "${devspace}/var/maven" \
        "${devspace}/var/node" \
        "${devspace}/var/rust" \
        "${devspace}/var/agent" \
        "${devspace}/repos" \
        "${devspace}/code"
      echo "ensureDevspace: directories created under ${devspace}"
    '';

    # 步骤3: 拉取外部仓库
    ensureRepos = lib.hm.dag.entryAfter [ "ensureDevspace" ] ''
      set -euo pipefail
      export PATH="${
        lib.makeBinPath [
          pkgs.git
          pkgs.openssh
        ]
      }:$PATH"
      export GIT_SSH_COMMAND="ssh -i ${sshDir}/id_github -o StrictHostKeyChecking=accept-new -o HostName=ssh.github.com -p 443"

      if [ ! -f "${sshDir}/id_github" ]; then
        echo "ensureRepos: SKIP — id_github key missing, cannot clone" >&2
        exit 1
      fi

      clone_repo() {
        local repo="$1"
        local dir="$2"
        if [ -d "$dir" ]; then
          echo "ensureRepos: $repo already exists at $dir, skip"
        else
          echo "ensureRepos: cloning git@github.com:pomeluce/$repo.git ..."
          git clone "git@github.com:pomeluce/$repo.git" "$dir"
          echo "ensureRepos: cloned $repo successfully"
        fi
      }

      clone_repo "nixos" "${devspace}/repos/nixos"
      clone_repo "nvim" "${devspace}/repos/nvim"
    '';
  };
}
