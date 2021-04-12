#!/bin/bash

set -e

function emplace() {
    SRC="$1"
    DST="$2"
    if test -L "$DST"; then return
    elif test -e "$DST"; then
	if test -d "$DST"; then
	    echo "*** ERROR ***"
	    echo "$DST already exists, and is a directory."
	    false
	else
	    rm -i "$DST"
	fi
    fi
    ln -vs "$SRC" "$DST"
}

emplace .dotfiles/zshrc ~/.zshrc
