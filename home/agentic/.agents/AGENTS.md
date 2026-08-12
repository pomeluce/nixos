# AGENTS.md

## General instructions

- Read the relevant project documentation and existing code before making changes.
- Keep changes focused on the current task and avoid unrelated refactoring.
- Follow the repository's existing structure, naming conventions, and coding style.
- Make reasonable assumptions only when they do not materially change the requested behavior.

## Editing instructions

- Preserve existing user changes, including unrelated changes in a dirty worktree.
- Do not revert or overwrite changes that were not made as part of the current task.
- Do not edit generated files manually when an established generator is available.
- Add comments only when they explain behavior that is not clear from the code itself.

## Validation instructions

- Run the relevant tests, formatting tools, and static checks after making changes.
- Use the repository's existing validation commands whenever available.
- Do not remove, skip, or weaken tests merely to make validation pass.
- If validation cannot be completed, explain why and report the remaining risk.

## Security instructions

- Never hardcode, expose, print, or commit credentials, tokens, or other secrets.
- Use environment variables or the repository's existing secret-management mechanism.
- Confirm exact targets before performing destructive or difficult-to-recover operations.
- Do not publish, deploy, or send repository data to external services without explicit authorization.

## Git commit instructions

- Create Git commits only when explicitly requested.
- Follow the Conventional Commits specification for every commit.
- Format the subject as `<type>[optional scope]: <description>`.
- Include a non-empty body that explains what changed and why.
- Do not create commits that contain only a subject line.
- Review the staged diff before committing and exclude unrelated changes.
- Do not amend existing commits unless explicitly requested.
- Do not use destructive Git operations or force-push without explicit authorization.

## Completion instructions

- Summarize what changed and why.
- Report the validation commands that were run and their results.
- Clearly disclose any validation that was not run, failures that remain, or follow-up work required.
