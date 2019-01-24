# tmux-monitor

``tmux-monitor`` is a [tmux](https://github.com/tmux/tmux) plugin that enables one-touch system status monitoring for Linux/macOS/Windows systems.

## Features

Two convenient commands are provided:

**Sidebar** - built on [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar), the system information sidebar is available through the command ``C-o`` by default

**Spawnable Window** - adds a ``system-monitor`` window to any session which uses Glances, [htop](https://hisham.hm/htop/), or ``top``.

## How It Works

``tmux-system-monitor`` uses [Glances](https://nicolargo.github.io/glances/) to spawn a window or sidebar which helps monitor your computer.

## Installation

### Manual Installation

Clone the repo:

```
$ git clone https://github.com/addisonlynch/tmux-sidebar-plus ~/clone/path
```

Add this line to the bottom of ``.tmux.conf``:

```
$ run-shell ~/clone/path/sidebar-plus.tmux
```

Reload tmux environment

```
$ tmux source-file ~/.tmux.conf
```

## Configuration


| option | default | description    |
|-------|------|---|
| ``@tmux-sidebar-plus-window-key``  | p | Set window toggle key |
| ``@tmux-sidebar-plus-sidebar-key``  | o | Set sidebar toggle key |
| ``@tmux-sidebar-plus-layout-dir`` | none | Additional layouts directory \
