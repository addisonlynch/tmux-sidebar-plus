# tmux-sidebar-plus

*Proof of Concept*

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
| ``@sidebar-plus-sidebar-key``  | b | Set sidebar toggle key |
| ``@sidebar-plus-layout-key`` | g | Set layout selection key |
| ``@sidebar-plus-layout-dir`` | none | Additional layouts directory |
| ``@sidebar-plus-position`` | left | Desired sidebar position (left or right)|


## Basic Usage

### Opening/Closing

Open and close the sidebar using prefix-b.

### Selecting a Layout

Select your desired layout using prefix-g.


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

To add custom layouts, create a directory and set its absolute path to
``@sidebar-plus-layout-dir``.

#### Formatting

The layout file should be named as desired and follow the below format:

```bash
LAYOUT_NAME="git"
PANES=3
MINIMUM_WIDTH="50"

populate_sidebar(){
    local sidebar_id="$1"
    tmux select-pane -t "$sidebar_id"
    tmux resize-pane -t "$sidebar_id" -x "${MINIMUM_WIDTH}"

    # Build & register panes
    local pane_1_id="$(split "${sidebar_id}" "vertical")"
    register_pane $sidebar_id $pane_1_id

    # Run panes' commands
    watched_dir_command $sidebar_id "git status"
    watched_dir_command $pane_1_id "git log --all --decorate --oneline --graph"
    select_base_pane
}

```

Where ``MINIMUM_WIDTH`` is the minimum width of the parent pane required to
open the sidebar.

#### Overriding Default Layouts

It is possible to override the default layouts by specifying a custom layout of
the same name. ``tmux-sidebar-plus`` will then use the custom layout's
configuration file.

#### Using ``update_dir.sh``

The ``update_dir.sh`` script runs a command every 3 seconds. This can be
included in any custom layout.

## To Do

* Enhanced layout caching (by pane, window, and session)
* Expanded default layouts (pull requests welcome)

## Attribution

tmux-sidebar-plus is an adapted implementation of [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar/commits?author=bruno-) written by [Bruno Sutic](https://github.com/bruno-).

## Contact

Email: ahlshop@gmail.com
Twitter: alynchfc

## License

Copyright © 2019 Addison Lynch

See LICENSE for details
