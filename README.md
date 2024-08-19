# dots

This repo holds my dotfiles.

These dotfiles have the particular restriction that their dependencies must be available under the same name on at least Mac (Homebrew) and Ubuntu (apt).

To install:
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/HEAD/misc/install.sh)"
```

To uninstall/unstow:
```shell
sh ~/dots/misc/uninstall.sh"
```
Keep in mind uninstalling won't remove dependencies.

Afterwards, you can just run `up` in kitty to update your whole system, including the dotfiles.
