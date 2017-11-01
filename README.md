# dotfiles

Simple dotfiles collection, primarily for me to quickly setup remote boxes with my settings but open to all.

[Screenshot](https://i.imgur.com/zJny3xO.png)

## Installation

```bash
git clone https://github.com/ccakes/dotfiles
cd dotfiles
bash bin/install.sh
```

This will check to make sure there are no conflicts (and bail if there are) then set up symlinks in `$HOME`. It'll also download a couple of minor dependencies which are listed below for completeness.

 - https://github.com/rupa/z
 - Antigen

### Updating

Same as above, the install script checks for conflicts but if a file exists **and is symlinked to the current repo** it'll ignore it. Pulling the repo and re-running the script will only create links for any new files.

## Wishlist

Loading all the plenv, rbenv & co is painfully slow. On my laptop, the shell start time is 700ms. I'd love to find a convenient way to get this down.

I've looked at shadowing the commands with a shell function of my own to do a type of lazy loading however I tend to throw one-liners at these interpreters a lot and the lazy loading breaks that. Definitely open to suggestions there.