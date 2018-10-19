#!/bin/bash
set -euo pipefail

########################
# Helper functions
die() {
  echo "$(tput setaf 9)[ ERROR]$(tput sgr0) $1"
  exit 255;
}

warn() {
  echo -e "$(tput setaf 11)[  WARN]$(tput sgr0) $1"
}

notice() {
  echo -e "$(tput setaf 10)[NOTICE]$(tput sgr0) $1"
}

noticen() {
  echo -en "$(tput setaf 10)[NOTICE]$(tput sgr0) $1"
}

readlinkf() {
  perl -MCwd -e 'print Cwd::abs_path shift' "$1";
}

########################
# Setup functions
check_pwd() {
  REMOTE=$(git remote get-url origin)
  if { [ "$REMOTE" != "git@github.com:ccakes/dotfiles.git" ] && [ "$REMOTE" != "https://github.com/ccakes/dotfiles" ]; }; then
    die "Run install.sh from the git root"
  fi

  return 0
}

check_files() {
  DIE=
  for f in $(find * -type f -not -path '.git/*' -not -path 'bin/*'); do
    if { [ -h "$HOME/.${f}" ] && [ "$(readlinkf $HOME/.${f})" != "$(pwd)/$f" ]; }; then
      warn "File exists or symlink is incorrect: $HOME/.${f}"
      DIE=1
    fi
  done

  [ ! -z $DIE ] && die "Backup and remove any conflicting files"

  return 0
}

check_depends() {
  DEPENDS="curl git tico ag fzf"
  for dep in $DEPENDS; do
    if ! command -v $dep >/dev/null 2>&1; then
      echo "$dep missing and is required"
      exit 255
    fi
  done

  return 0
}

install_depends() {
  if [ ! -f "$HOME/.z.sh" ]; then
    notice "Installing z.sh (https://github.com/rupa/z)"
    curl -sL -o "$HOME/.z.sh" https://github.com/rupa/z/raw/master/z.sh
  fi

  if [ ! -f "$HOME/.antigen.zsh" ]; then
    notice "Installing antigen"
    curl -sL -o "$HOME/.antigen.zsh" https://git.io/antigen
  fi

  return 0
}

install_symlinks() {
  notice "Creating symlinks..."

  UPDATED=
  for f in $(find * -type f -not -path '.git/*' -not -path 'bin/*'); do
    if { [ -h "$HOME/.${f}" ] && [ "$(readlinkf $HOME/.${f})" == "$(pwd)/$f" ]; }; then
      continue
    else
      notice "   $HOME/.${f} → $(pwd)/$f"
      ln -s "$(pwd)/$f" "$HOME/.${f}"
      UPDATED=1
    fi
  done

  if [ -z $UPDATED ]; then
    notice "Nothing to do - up to date!"
    exit 0
  fi

  notice "Done!"
  echo ""
  echo "    exec \$SHELL -l or restart your terminal for any updates to take effect"
  echo ""
}

check_pwd
check_files
check_depends && install_depends
install_symlinks