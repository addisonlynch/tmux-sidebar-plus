# tmux-sidebar-plus

``tmux-sidebar-plus`` is a fast and customizable multi-window
[tmux](https://github.com/tmux/tmux) sidebar.

An enhanced fork of [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar),
the system information sidebar is available through the command ``prefix-b`` by default.

![tmux-sidebar-plus](/img/detailed_small.gif)

## Features


``tmux-sidebar-plus`` adds the following features to ``tmux-sidebar``:

- **multi-pane sidebar**<br/>
  Allows for multiple panes in a variety of layouts.
- **practical default layouts**</br>
  Including system monitoring, git tracking
- **easily-customizable commands**<br/>
  Create simple configuration files to manually determine the layout of the
  sidebar
- **layout selection**<br/>
  Select from a variety of default layouts, or a custom layout, using the
  layout selector key (default prefix+g)


On top of this, ``tmux-sidebar-plus`` folds in all the great features of
``tmux-sidebar``:

- **fast**<br/>
  Much faster than doing each step manually.
- **smart sizing**<br/>
  Sidebar remembers its size, so the next time you open it, it will have the
  **exact same** width. This is a per-directory property, so you can have just
  the right size for multiple dirs.
- **toggling**<br/>
  The same key binding opens and closes the sidebar.
- **uninterrupted workflow**<br/>
  The main `prefix + Tab` key binding opens a sidebar but **does not** move
  cursor to it.
- **pane layout stays the same**<br/>
  No matter which pane layout you prefer, sidebar tries hard not to mess your
  pane splits. Open, then close the sidebar and everything should look the same.


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

A number of useful layouts are provided by ``tmux-sidebar-plus``, including:

* ``default`` - system monitoring using [Glances](https://nicolargo.github.io/glances/),
  [htop](https://hisham.hm/htop/), or [top](https://linux.die.net/man/1/top)
* ``git`` - git status & log monitoring

### Default

![Default Layout](/img/default_small.gif)

### Git

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


## Testing

This plugin uses the [tmux-test](https://github.com/tmux-plugins/tmux-test)
framework as a test suite. All tests are located in the tests/ directory.

### Requirements

* Vagrant
* virtualbox

