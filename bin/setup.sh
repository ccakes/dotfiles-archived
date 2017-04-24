#!/bin/bash

DFILES=(.z.sh .antigen.zsh .gitconfig .perltidyrc .tmux.conf .zprofile)

echo "!!! Removing any conflicting files !!!"
echo "(Copies saves in $PWD/backup/)"
for file in ${DFILES[@]}; do
  if [ -f $HOME/$file ]; then
    cp $HOME/$file $PWD/backup/$file
    rm -i $HOME/$file 2>/dev/null
  fi
done

# Get libraries
echo ""
echo "Fetching z.sh and antigen from GitHub"
curl -sL -o $HOME/.z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh
curl -sL -o $HOME/.antigen.zsh git.io/antigen

echo "Copying dotfiles into place"
ln -s $HOME/.gitconfig $PWD/gitconfig
ln -s $HOME/.perltidyrc $PWD/perltidyrc
ln -s $HOME/.tmux.conf $PWD/tmux.conf
ln -s $HOME/.zprofile $PWD/zprofile

echo ""
echo "Finished!"
