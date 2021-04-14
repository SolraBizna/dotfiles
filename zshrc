#!/bin/zsh

export FAKE_BROWSER="Mozilla/3.01Gold (Macintosh; I; 68K)"

# list these in ASCENDING order of priority
for DIR in /usr/games/bin /usr/local/games/bin /usr/local/bin /opt/wine-staging/bin /opt/wine-devel/bin ~/.cargo/bin /opt/homebrew/bin ~/osxcross/target/bin ~/bin; do
	if test ! -d "$DIR"; then continue; fi
	if echo "$PATH" | tr ':' '\n' | grep -q -F "$DIR"; then continue; fi
	export PATH="$DIR:$PATH"
done

if test -z "$EMACS"; then
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

