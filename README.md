# cronminder

> **Stateful Scheduled Task & Backup Reminders for Oh My Zsh / Shells**

`cronminder` is a lightweight, stateful Oh My Zsh custom plugin and CLI tool that displays formatted reminders for periodic tasks (such as weekly backups) upon terminal session startup.

## Features

- **Stateful Tracking**: Tracks task completion per ISO week (`~/.last_backup_week`).
- **Overdue Reminders**: Triggers starting Monday at 9:00 AM through the rest of the week until marked done.
- **Oh My Zsh Integration**: Plug-and-play Oh My Zsh custom plugin support.
- **CLI Management**: Subcommands to check, mark complete, reset state, or test output.

## CLI Usage

```bash
cronminder check   # Perform scheduled check (silently checks state & displays banner if pending)
cronminder status  # Display current backup status and recorded ISO week
cronminder done    # Mark current week's backup as complete
cronminder reset   # Reset state (removes ~/.last_backup_week)
cronminder test    # Force display reminder banner for testing
```

## Installation

### Oh My Zsh

Symlink the project into your Oh My Zsh custom plugins directory:

```bash
ln -s ~/dev/cronminder ~/.oh-my-zsh/custom/plugins/cronminder
```

Then enable `cronminder` in your `~/.zshrc`:

```zsh
plugins=(... cronminder)
```

## License

[MIT](LICENSE)
