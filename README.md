# cronminder

> **Declarative Stateful Cron Evaluator & Textual Reminder Engine for Oh My Zsh / Shells**

`cronminder` is a lightweight, security-first Oh My Zsh custom plugin and CLI tool that evaluates scheduled tasks and displays formatted textual reminders upon terminal session startup or CLI status checks.

---

## 🌟 Key Features

- **Security & Sanity Guarantee**: Zero arbitrary code execution or system mutations. Evaluates cron schedules and renders safe textual templates directly to terminal `stdout`.
- **`crond`-Style Task Directories**: Drop plain-text templates into `~/.config/cronminder/tasks.d/{hourly,daily,weekly,monthly}/` without needing to write cron syntax.
- **Declarative `tasks.conf`**: Power-user cron syntax support in `~/.config/cronminder/tasks.conf` supporting wildcards, steps (`*/15`), ranges (`1-5`), and aliases (`@hourly`, `@daily`, `@weekly`, `@monthly`).
- **System Cron Discovery**: `cronminder system` scans user crontab (`crontab -l`), `cronminder` tasks, and system crontabs (`/etc/cron*`) for an instant overview of your entire cron environment.
- **Focus Filters**: Filter login or status checks by `--today` or `--upcoming` to view only relevant tasks.
- **Stateful Completion Tracking**: Tracks task completion per period (`YYYYMMDDHH`, `YYYYMMDD`, `YYYY-WW`, `YYYYMM`) in `~/.config/cronminder/state`.
- **Instant Prompt Compatible**: Sub-10ms execution aligned with Powerlevel10k and Oh My Zsh.

---

## 🛠️ CLI Usage

```bash
cronminder check [--today|--upcoming] # Check active tasks & render banners/dashboard on login
cronminder status [--today|--upcoming]# Display task status dashboard and period completion keys
cronminder system                    # Scan user crontabs and /etc/cron* system schedules
cronminder done [task_id]            # Mark a specific task (or all active tasks) as complete
cronminder reset [task_id]           # Reset completion state for a task or all tasks
cronminder test [task_id]            # Force display reminder banner/dashboard for visual testing
```

---

## 📁 Configuration Modes

### Mode A: `crond`-Style Directories (`~/.config/cronminder/tasks.d/`)

Drop text files into interval subdirectories:

```
~/.config/cronminder/tasks.d/
├── hourly/
│   └── water-reminder.txt
├── daily/
│   └── standup-notes.txt
├── weekly/
│   ├── backup.txt
│   └── timesheet.txt
└── monthly/
    └── system-audit.txt
```

### Mode B: `tasks.conf` (`~/.config/cronminder/tasks.conf`)

Add custom cron rules:

```cron
# Format: <CRON_EXPRESSION> | <TASK_ID> | <DISPLAY_TITLE> | <TEXTUAL_PAYLOAD>
0 9 * * 1    | backup    | Weekly Backup Reminder   | 🔔 WEEKLY BACKUP: Run backup-vm.sh!
0 17 * * 5   | timesheet | Friday Timesheet         | ⏱️ TIMESHEET: Submit your weekly hours.
0 10 1 * *   | monthly   | Monthly Audit            | 📋 MONTHLY AUDIT: Review system logs.
```

---

## 📦 Installation

### Option 1: Quick Install via Curl

```bash
curl -sSL https://raw.githubusercontent.com/aaronbronow/cronminder/main/install.sh | bash
```

### Option 2: Oh My Zsh Custom Plugin

Clone into your Oh My Zsh custom plugins folder:

```bash
git clone https://github.com/aaronbronow/cronminder.git ~/.oh-my-zsh/custom/plugins/cronminder
```

Then enable `cronminder` in your `~/.zshrc`:

```zsh
plugins=(... cronminder)
```

---

## 📄 License

[MIT](LICENSE)
