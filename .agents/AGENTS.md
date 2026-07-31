# Workspace Learnings & Rules for cronminder

These rules and guidelines govern maintenance and feature development in the `cronminder` repository.

## 1. Oh My Zsh & Powerlevel10k Instant Prompt Compatibility
- Powerlevel10k Instant Prompt monitors any console output produced during shell initialization. If output is emitted after `p10k instant prompt` is sourced, p10k displays a pre-run warning: `[instant prompt] output produced during zsh initialization`.
- Always source `cronminder` **before** the `p10k instant prompt` block in `~/.zshrc` (or `dot_zshrc.tmpl`) so that banner output is rendered cleanly prior to instant prompt initialization.
- Use `_CRONMINDER_RAN` session guard to ensure the reminder check runs exactly once per interactive shell process.

## 2. Stateful Tracking Logic
- Stateful reminders track completion using ISO week numbers (`date +%V`) stored in `~/.last_backup_week`.
- Active window: Triggers from **Monday at 9:00 AM** (`day == 1 && hour >= 9`) through the rest of the week (`day > 1`) until `~/.last_backup_week` matches `$(date +%V)`.
- Running `backup-vm.sh` or `cronminder done` writes the current ISO week to `~/.last_backup_week`, silencing the reminder banner for the remainder of the week.

## 3. Chezmoi Orchestration
- Dotfiles are orchestrated via `chezmoi` on `surface95` (WSL / Ubuntu 24.04 LTS).
- The repository is symlinked into Oh My Zsh custom plugins:
  `~/.oh-my-zsh/custom/plugins/cronminder` -> `~/dev/cronminder`
- Any changes to `~/.zshrc` must be reflected in chezmoi template `dot_zshrc.tmpl` and applied using `chezmoi apply`.

## 4. Shell Compatibility & Performance
- Keep `cronminder` lightweight and lag-free (<10ms execution time).
- Use `date +%-H` in Zsh scripts to avoid `10#` base prefix globbing warnings during integer evaluation.
- Provide both `cronminder.plugin.zsh` (Zsh) and `cronminder.plugin.sh` (Generic Bash / POSIX).
