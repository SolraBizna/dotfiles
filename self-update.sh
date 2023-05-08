#!/bin/sh

set -e

if [ ! \( -z "$__DID_SELF_UPDATE" -a -z "$__NO_SELF_UPDATE" -a \
       ! -f ~/.dotfiles-no-self-update \) ]; then exit; fi
# exit self-update early if somebody else recently did it
# (stops the "all six terminals updating" problem)
if [ ! -z "$(find ~/.dotfiles/ -name .last-self-update -a -mtime -7)" ]; then
    exit
fi

cd ~/.dotfiles
echo "Checking for dotfile updates..."
git pull --ff-only
touch .last-self-update
