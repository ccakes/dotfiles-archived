#!/bin/bash

DFILES=(.z.sh .antigen.zsh .gitconfig .perltidyrc .tmux.conf .zprofile)

echo "!!! Removing any conflicting files !!!"
echo "(Copies saves in $PWD/backup/)"
for file in ${DFILES[@]}; do
  if [ -f $HOME/$file ]; then
    cp $HOME/$file $PWD/backup/$file
    rm -i $HOME/$file
  fi
done

# Get libraries
echo ""
echo "Fetching z.sh and antigen from GitHub"
curl -sL -o $HOME/.z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh
curl -sL -o $HOME/.antigen.zsh git.io/antigen

echo "Copying dotfiles into place"
ln -s $PWD/gitconfig $HOME/.gitconfig
ln -s $PWD/perltidyrc $HOME/.perltidyrc
ln -s $PWD/tmux.conf $HOME/.tmux.conf
ln -s $PWD/zprofile $HOME/.zprofile

echo ""
echo "Finished!"
