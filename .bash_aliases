################################################################################
# Server alias
################################################################################
alias bonito='ssh -X jyx@jyx.mooo.com'
alias fsdata='ssh -X jyx@jyxpi.mooo.com'
alias hackbox='ssh -X joakim.bech@hackbox.linaro.org'
alias mount_hackbox='sshfs joakim.bech@hackbox.linaro.org:/home/joakim.bech /home/jbech/mnt/hackbox'
alias people='ssh -X joakim.bech@people.linaro.org'
alias mount_people='sshfs joakim.bech@people.linaro.org:/home/joakim.bech /home/jbech/mnt/people'

################################################################################
# Tools
################################################################################
alias t='$HOME/bin/todo.sh'

################################################################################
# GPG
################################################################################
# Yubikey keys
ENC_KEY=FCDCDE19
SIGN_KEY=3B8DDE54
AUTH_KEY=C70DCE4D

# Older keys (but more secure)
OLD_ENC_KEY=1F6ABFB3
OLD_SIGN_KEY=DC190DB5
export GPGKEY=189693C7

alias gpg='gpg2'

# Function use to encrypt files locally for my own sake
function encrypt () { gpg -e -r "$ENC_KEY!" $1; }
function decrypt () { gpg -d --output $1.plaintext $1; }

function sign () { gpg --default-key "$SIGN_KEY!" -o $1.sig --detach-sign $1; }
function check_sign () { gpg --verify $1.sig $1; }

################################################################################
# Git related alias
################################################################################
alias gb='git branch'
alias gs='git status'
alias grv='git remote -v'
alias gh_url="git remote -v | head -1 | awk '{print $2}' | sed -e 's/https:\/\/github.com\/\(.*\)/git@github.com:\1/g'"
alias review_tag="echo \"Reviewed-by: Joakim Bech <joakim.bech@linaro.org>\""

################################################################################
# Repo related alias
################################################################################
alias rpo_rev='repo forall -c '\''echo $REPO_PATH -- `git log --oneline -1`'\'''
alias rpo_clean_all="repo forall -c 'echo Cleaning ... \$REPO_PATH && git clean -xdf && git checkout -f'"
alias rpo_jbech='repo forall -c "git remote add jbech git@github.com:jbech-linaro/\$REPO_PATH.git"'
alias rpo_s='repo sync -j3 -d'

alias tmux='tmux -2'

################################################################################
# Cscope specific
################################################################################
alias cscopeme='find `pwd` -name "*.[chsS]" > cscope.files && cscope -b -q -k'

################################################################################
# Hexdump
################################################################################
alias hd='hexdump -C -v'
function hdh () { hd $1 | head $2 $3; }
function hdt () { hd $1 | tail $2 $3; }

################################################################################
# Docker
################################################################################
alias dr='docker'
alias dr_ps='docker ps -a'
alias dr_stopall='docker stop $(docker ps -a -q)'
alias dr_remall='docker rm $(docker ps -a -q)'
alias dr_stoprem='docker rm -f $(docker ps -a -q)'

################################################################################
# ccache
################################################################################
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache


################################################################################
# Various search and find
################################################################################
alias rgrep='grep -r --color'

alias chfind='find . -name "*.[ch]"'
alias chfindx='find . -name "*.[ch]" | xargs grep --color'
alias chfinds='find . -name "*.[chsS]" | xargs grep --color'
alias chfinda='find -iname '*.mk' -o -iname '*.ld' -o -iname '*.[chsS]'  | xargs grep --color'

function mgrep()
{
	find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -print0 | xargs -0 grep --color -n "$@"
}

ff() {
	echo "$1 : $2"
	if [ $# -eq 1 ]; then
		find . | grep --color -e "\.$1\$"
	else
		find . | grep --color -e "\.$1\$" | grep --color -e "$2" | grep --color -e "\.$1\$"
	fi
}


################################################################################
# Paste services
################################################################################
alias file_to_clip="xclip -sel clip <"
alias tb="nc termbin.com 9999"

transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

################################################################################
# i3 tweaks
################################################################################
alias nemo='nemo --no-desktop'

################################################################################
# SSH settings
################################################################################
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
        echo "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
}
else
        start_agent;
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
	. "${HOME}/.gpg-agent-info"
	export GPG_AGENT_INFO
	export SSH_AUTH_SOCK
	export SSH_AGENT_PID
fi
