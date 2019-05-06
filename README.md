# tmux-sidebar-plus

``tmux-sidebar-plus`` is a fast and flexible [tmux]
(https://github.com/tmux/tmux) sidebar.

## Features

Two convenient commands are provided:

**Sidebar** - built on [tmux-sidebar]
(https://github.com/tmux-plugins/tmux-sidebar), the system information sidebar
is available through the command ``prefix-h`` by default


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


### tmux Options

| option | default | description    |
|-------|------|---|
| ``@sidebar-plus-sidebar-key``  | o | Set sidebar toggle key |
| ``@sidebar-plus-layout-key`` | g | Set layout selection key |
| ``@sidebar-plus-layout-dir`` | none | Additional layouts directory \


## Layouts

### Default Layouts

A number of useful layouts are provided by ``tmux-sidebar-plus``, including:

* ``default`` - system monitoring using [Glances](https://nicolargo.github.io/glances/),
  [htop](https://hisham.hm/htop/), or [top](https://linux.die.net/man/1/top)
* ``git`` - git status & log monitoring

#### ``default``

![Default Layout](/img/default_small.gif)

#### ``git``

![Git Layout](/img/git_small.gif)

### Custom Layouts

It is possible to override the default layouts by specifying a custom layout of
the same name. ``tmux-sidebar-plus`` will then use the custom layout's
configuration file.

#### Using ``update_dir.sh``

The ``update_dir.sh`` script runs a command every 3 seconds.

# To Do

* Enhanced layout caching (by pane, window, and session)
* Expanded default layouts (pull requests welcome)
