#!/bin/sh

set -e

# exit self-update early if somebody else recently did it
# (stops the "all six terminals updating" problem)
if [ ! \( -z "$__DID_SELF_UPDATE" -a -z "$__NO_SELF_UPDATE" -a \
       ! -f ~/.dotfiles-no-self-update \) ]; then exit; fi

cd ~/.dotfiles
echo "Checking for dotfile updates..."
git pull --ff-only
touch .last-self-update
