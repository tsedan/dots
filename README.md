# dots

This repository holds my dotfiles (see stow folder).

**Warning:** please do not run any shell scripts (including the ones below) without reading them first!
The installer uses `sudo` to update packages using your system's package manager.
If you don't trust it, either refuse sudo privileges (such as by using `Ctrl-D` when prompted for your password), or instead install this repository manually by cloning and stowing it yourself.

To install:
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/HEAD/misc/install.sh)"
```

To update (optionally also updates all system packages):
```shell
up
```

To uninstall/unstow:
```shell
sh ~/dots/misc/uninstall.sh
```
Keep in mind uninstalling won't remove dependencies.
