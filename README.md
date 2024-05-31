# 2C Desktop: Bspwm

This repository contains my ([2art](mailto:2art@pm.me)) personal desktop configuration on Arch Linux, for the [Bspwm window manager](https://github.com/baskerville/bspwm). This theme configuration uses and configures the following default applications:

- Window Manager: **Bspwm**
- Compositor: **Picom**
- Notification Daemon: **Dunst**
- App Launcher/Switcher: **Rofi**
- File Manager: **Thunar**
- Web Browser: **LibreWolf**
- Keyboard Shortcuts: **Sxhkd**, **Xorg-Xmodmap**
- Terminal Emulator: **Alacritty**
- Top Bar: **Polybar**
- Editors: **Nano**, **Mousepad**
- Media: **Mpv**, **Viewnior**, **Feh**

Configs and default apps that are used are updated as this project develops; For example, terminal editor (nvim) config is not included yet, although it may get it's own repository instead.

## Script for Setting Up Repository

### Setup sym-links:

```bash
# First, find symlinks in home directory that are broken and delete any. Ask the
# user before deleting any to confirm.
broken_symlinks=( $(find ~ -type l -xtype l -and \( -not -path "*dxo.profile*/*" -and -not -ipath "*/Steam*" -and -not -path "*.steam*" \) -print) )
if (( $#broken_symlinks > 0 )); then
  printf '\e[34;1mFound following broken symlinks from home directory:\n\e[22;33m'
  for d in "${broken_symlinks[@]}"; do echo $d; done
  printf '\e[0m\n\nDelete these broken symlinks? [y/N]: '
  read -k1 ans
  printf '\n'
  if [[ $ans =~ '^[yY]$' ]]; then
    for d in "${broken_symlinks[@]}"; do rm -fv "$d"; done
  fi
fi

# Find directories to be symlinked; Process each one by one, to see if the symlink is missing so far.
find /home/dxo/.2c/bspwm/home/.config/* -maxdepth 0 -type d -not -path '*/.git/*' | while read f; do
  tgt="/home/dxo/.config/${f##*.config/}"
  if [[ ! -h "$tgt" ]]; then
        printf '\e[32;1mCreating symlink: %s\n\e[33;22m' "${tgt}"
        ln -sfv "${f}" "${tgt}"
        printf '\e[0m\n'
  fi
done
```

### Packages to Install

- Theme: [xfce-simple-dark](https://github.com/simonkrauter/Xfce-Simple-Dark) (included in pacman command lines below)
- Icons: [candy-icons-git](https://github.com/EliverLara/candy-icons) (included in pacman command lines below)
- Fonts: Mainly 'EnvyCodeR Nerd Font'

  > Clone [NerdFonts](https://github.com/ryanoasis/nerd-fonts) with `git clone --depth 1 https://github.com/ryanoasis/nerd-fonts` and follow the installation instructions in `README.md`.

  > > Optionally, just install 'ttf-envycoder-nerd' via `pacman -Syu ttf-envycoder-nerd` to only use this one recommended font.

### pacman/yay Command Line Copy-Paste

```bash
# Required packages
sudo pacman -Syu --needed bspwm picom dunst rofi thunar sxhkd xorg-xmodmap alacritty polybar nano mousepad mpv viewnior feh lxappearance-gtk3
yay -Syu --needed librewolf-bin xfce-simple-dark candy-icons-git

# Optional Applications:
sudo pacman -Syu thunar-volman thunar-media-tags-plugin thunar-archive-plugin ttf-envycoder-nerd bat
yay -Syu profile-sync-daemon-librewolf
```

# Git Branching Model

The model detailed [here](https://nvie.com/posts/a-successful-git-branching-model) is somewhat followed in all repos. Below are general rules for branching and merges, for all repositories.

- Merges should never be fast-forwarded, but merge-commits instead. This means using either `git merge --no-ff <branch>`, or specifying `git config merge.ff false` in `.gitconfig`. This way the command-line option doesn't need to be specified each time.

- Branches should provide a description (`git branch --edit-description`), which helps in organizing, and is also appended into merge messages.

- `main` contains a working-state copy from a certain point in development.

- `dev` is used as a base for all development, and the repository usually sits in this state. Only this branch merges to `main` when appropriate.

- Feature and bugfix branches branch from `dev` and should generally not be long-lived. They should **always** be deleted after being merged, with `git branch -d`. Same branch name may be used again later, but still delete right after merge.

- Version releases are done using tags when it feels appropriate (e.g. structure changes, finished scripts, modules or plugins). Read more about it here: [Git Tagging Basics](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [Git Tag Reference](https://git-scm.com/docs/git-tag).
