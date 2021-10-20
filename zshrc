#!/bin/zsh

export FAKE_BROWSER="Mozilla/3.01Gold (Macintosh; I; 68K)"
export GPG_TTY="$TTY"

# list these in ASCENDING order of priority
for DIR in /usr/games/bin /usr/local/games/bin /usr/local/bin /opt/wine-staging/bin /opt/wine-devel/bin ~/.cargo/bin /opt/homebrew/bin ~/osxcross/target/bin ~/.local/bin ~/bin /Library/TeX/texbin ~/android_sdk/cmdline-tools/bin; do
	if [ ! -d "$DIR" ]; then continue; fi
	if echo "$PATH" | tr ':' '\n' | grep -q -F "$DIR"; then continue; fi
	export PATH="$DIR:$PATH"
done

if [ -d ~/android_sdk ]; then
    export ANDROID_SDK_ROOT=~/android_sdk
fi

case "$-" in
    *i*)
	# We're interactive. Try to self-update if flock is available..
	# (We can't do this before altering PATH, because flock might be
	# installed outside /usr/bin, e.g. on BSD or macOS.)
	if [ -z "$__DID_SELF_UPDATE" -a -z "$__NO_SELF_UPDATE" -a \
	     ! -f ~/.dotfiles-no-self-update ] &&
	   which flock >/dev/null 2>&1 &&
	   [ -z "$(find ~/.dotfiles/ \
	           -name .last-self-update -a -mtime -7)" ]
	then
	    flock ~/.dotfiles/.last-self-update ~/.dotfiles/self-update.sh
	    # I hope git updates files the way I think it does...
	    __DID_SELF_UPDATE=1
	    source ~/.zshrc
	    unset __DID_SELF_UPDATE
	    return
	fi
	;;
esac

if [ -z "$EMACS" ]; then
    if which emacs >/dev/null; then
	EMACS=$(which emacs)
	export EDITOR="$EMACS"
	export VISUAL="$EMACS"
	emacs() {
	    case $TERM in
		xterm-256color) TERM=xterm "$EMACS" "$@" ;;
		screen-256color) TERM=screen "$EMACS" "$@" ;;
		*) "$EMACS" "$@" ;;
	    esac
	}
    else
	echo "WARNING: no emacs on this host yet! install it!"
    fi
fi

if [ -z "$SSH_CLIENT" -a "$(whoami)" != "root" ]; then
	PS1="%B%(!.%F{red}.%F{magenta})%n%f %F{cyan}%1~%f%(?.%F{white}.%F{red})%(!.#.%#) %f%b"
else
	PS1="%B%(!.%F{red}.%F{magenta})%n%b@%m%B %F{cyan}%1~%f%(?.%F{white}.%F{red})%(!.#.%#) %f%b"
fi

case "$-" in
    *i*)
        # Running interactively. Maybe print a banner.
	if [ -x ~/.banner ]; then
	    ~/.banner
	fi
	;;
esac
