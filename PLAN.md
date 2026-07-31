# PLAN: Declarative Cron Syntax Evaluator & Textual Reminder Engine for Oh My Zsh

## 1. Executive Summary & Vision

`cronminder` is evolving from a single-purpose weekly backup banner into a full-featured, security-first **Oh My Zsh custom community plugin**. It acts as a lightweight, declarative cron schedule evaluator designed to trigger visual reminders and formatted output upon terminal startup or status checks.

### Core Security & Architecture Principle
> **Security & Sanity Guarantee**: `cronminder` is strictly a **textual evaluation engine**. It **does not** execute arbitrary system commands, background daemons, or modifying shell scripts. When a cron schedule rule evaluates to active/due, `cronminder` processes safe text templates and writes formatted notifications directly to the terminal stdout.

---

## 2. Technical Goals & Performance Constraints

1. **Cron & Directory Evaluation**: Dual support for standard 5-field cron expressions in `tasks.conf` AND `crond`-style folder structures (`tasks.d/{hourly,daily,weekly,monthly}/`).
2. **System Cron Inspection**: Overview command (`cronminder system`) to scan user crontabs (`crontab -l`) and `/etc/cron*` system definitions for a complete environment overview.
3. **Filtering & Focus Views**: Option to filter output for **upcoming** or **today's** tasks on terminal login or status invocation (`--today`, `--upcoming`, `CRONMINDER_FILTER_MODE`).
4. **Sub-10ms Execution**: Evaluates all task schedules in under 10ms during shell startup to prevent terminal launch latency.
5. **Instant Prompt Compatibility**: Full alignment with Powerlevel10k and Oh My Zsh instant prompt mechanisms (executes banner rendering cleanly before prompt lock).
6. **Stateful Tracking**: Tracks completion state per task/period using a local, lightweight state store (`~/.config/cronminder/state`).
7. **Zero Side-Effects**: Pure textual rendering—no subshell `eval`, system mutations, or background cron spawns.

---

## 3. Configuration & Registry Specifications

`cronminder` supports **two complementary configuration modes**:

### Mode A: `crond`-Style Task Directories (`~/.config/cronminder/tasks.d/`)
For maximum simplicity (ideal for users unfamiliar with cron syntax), users can drop plain-text banner template files into interval-based directories:

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

- **File Name**: Becomes the `<TASK_ID>` (e.g. `backup`).
- **Directory**: Determines implicit schedule:
  - `hourly/`: Implicit cron `0 * * * *`
  - `daily/`: Implicit cron `0 0 * * *`
  - `weekly/`: Implicit cron `0 9 * * 1` (Active Mon 9 AM through rest of week until completed)
  - `monthly/`: Implicit cron `0 0 1 * *`
- **File Content**: Textual banner message template rendered to stdout when active & pending.

---

### Mode B: Declarative `tasks.conf` File (`~/.config/cronminder/tasks.conf`)
For advanced users needing custom cron expressions:

```cron
# Format: <CRON_EXPRESSION> | <TASK_ID> | <DISPLAY_TITLE> | <TEXTUAL_PAYLOAD / TEMPLATE>
0 9 * * 1    | backup    | Weekly Backup Reminder   | 🔔 WEEKLY BACKUP: Run backup-vm.sh!
0 17 * * 5   | timesheet | Friday Timesheet         | ⏱️ TIMESHEET: Submit your weekly hours.
0 10 1 * *   | monthly   | Monthly Audit            | 📋 MONTHLY AUDIT: Review system logs.
```

---

## 4. Finalized Design Decisions (from Design Interview)

- **Template Evaluation**: Pure text/markdown templates with string placeholder substitution (e.g., `{task_id}`, `{due_date}`) for 0-risk, ultra-fast (<10ms) execution. No arbitrary script execution.
- **State Persistence**: Period-key state tracking storing frequency keys (`YYYYMMDDHH` for hourly, `YYYYMMDD` for daily, `YYYY-WW` for weekly, `YYYY-MM` for monthly) in `~/.config/cronminder/state`.
- **System Cron Scanning**: Graceful non-blocking scan reading user `crontab -l`, `cronminder` tasks, and readable `/etc/cron*` files without requiring root or throwing errors on restricted files.
- **Multi-Task Login Output**: Render a unified, styled summary dashboard box listing all active/overdue tasks matching the active filter to keep prompt output clean and uncluttered.

---

## 5. Architectural Components

```
+-----------------------------------------------------------------------+
|                         Interactive Shell                             |
|              (zsh startup / login / cronminder check)                 |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|                    cronminder plugin entrypoint                       |
|           - Session guard (_CRONMINDER_RAN)                           |
|           - Fast POSIX cron & directory evaluator                     |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|                 Tasks, System Scan & State Engine                     |
|   - Scans ~/.config/cronminder/tasks.d/{hourly,daily,weekly,monthly}  |
|   - Reads ~/.config/cronminder/tasks.conf                             |
|   - Scans system crontabs (`crontab -l`, `/etc/cron*`) [on system cmd]|
|   - Compares schedule against current system date/time                |
|   - Applies focus filters (--today / --upcoming / --recent)           |
|   - Checks task completion status in ~/.config/cronminder/state       |
+-----------------------------------------------------------------------+
                                   | (If task active & pending)
                                   v
+-----------------------------------------------------------------------+
|                    Textual Banner Renderer                            |
|   - Formats ANSI colors, boxes, glyphs, and variables                 |
|   - Safe text output to stdout (no code execution / no side-effects)  |
+-----------------------------------------------------------------------+
```

---

## 6. Implementation Roadmap

### Phase 1: Core Cron Evaluator Engine
- Implement `parse_cron_field` & `match_cron_schedule` functions in POSIX-compliant Bash/Zsh logic.
- Add time calculation functions for upcoming run predictions and recent run matching.

### Phase 2: Directory & Config Scanner & State Engine
- Implement `tasks.d` directory scanner for `hourly/`, `daily/`, `weekly/`, and `monthly/` subfolders.
- Merge tasks loaded from `tasks.d/` and `tasks.conf`.
- Implement key-value state store tracking ISO week/day/epoch per `task_id` in `~/.config/cronminder/state`.

### Phase 3: System Cron Inspection Scanner
- Implement `cronminder system` scanner parsing user `crontab -l` and `/etc/cron*` files cleanly.

### Phase 4: Focus Filters & Textual Renderer
- Implement `--today`, `--upcoming`, and `--recent` filter flags and `CRONMINDER_FILTER_MODE` environment toggle.
- Design pure-text rendering pipeline supporting ANSI formatting, glyph borders, and template variables (`{task_id}`, `{due_date}`).

### Phase 5: CLI Refactoring & Shell Integration
- Update CLI commands (`check`, `status`, `system`, `done <id>`, `reset <id>`, `test <id>`).
- Maintain full Oh My Zsh, Powerlevel10k Instant Prompt, and Chezmoi compatibility.

### Phase 6: Verification & Unit Tests
- Expand test suite in `tests/test_cronminder.sh` to test system scanning, filter flags, directory scanning, and cron parser matching.

---

## 7. Verification Plan

```bash
# 1. Run unit test suite
./tests/test_cronminder.sh

# 2. Test CLI commands
./cronminder status --today
./cronminder status --upcoming
./cronminder system
./cronminder test
./cronminder check

# 3. Verify execution time (<10ms)
time zsh -c "source ./cronminder.plugin.zsh"
```
