# tmux-sidebar-plus

``tmux-sidebar-plus`` is a [tmux](https://github.com/tmux/tmux) plugin
provides fast and flexible multi-window sidebar functionality.

## Features

Two convenient commands are provided:

**Sidebar** - built on [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar), the system information sidebar is available through the command ``C-o`` by default

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

## Custom Layouts

It is possible to override the default layouts by specifying a custom layout of
the same name. ``tmux-sidebar-plus`` will then use the custom layout's
configuration file.

### Using ``update_dir.sh``

The ``update_dir.sh`` script runs a command every 3 seconds.
