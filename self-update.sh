#!/bin/sh

set -e

cd ~/.dotfiles
echo "Checking for dotfile updates..."
git pull
