# Servers
alias bonito='ssh -X jyx@jyx.mooo.com'
alias fsdata='ssh -X jyx@jyxpi.mooo.com'
alias people='ssh -X joakim.bech@people.linaro.org'
alias mount_people='sshfs joakim.bech@people.linaro.org:/home/joakim.bech /home/jbech/people'

# Tools
alias t='$HOME/bin/todo.sh'

# Git related alias
alias gb='git branch'
alias gs='git status'
alias grv='git remote -v'
alias gh_url="git remote -v | head -1 | awk '{print $2}' | sed -e 's/https:\/\/github.com\/\(.*\)/git@github.com:\1/g'"
alias review_tag="echo \"Reviewed-by: Joakim Bech <joakim.bech@linaro.org>\""

# Repo related alias
alias rpo_rev='repo forall -c '\''echo $REPO_PATH -- `git log --oneline -1`'\'''
alias rpo_clean_all="repo forall -c 'echo Cleaning ... \$REPO_PATH && git clean -xdf && git checkout -f'"

alias tmux='tmux -2'

# Cscope specific
alias cscopeme='find `pwd` -name "*.[chsS]" > cscope.files && cscope -b -q -k'
alias chfind='find . -name "*.[ch]"'

# Overriding standard flags
alias rgrep='rgrep --color'

# Fast help
alias dump_zip_details='echo "Client ID: 3792773" && echo "Host Passcode: 3832979710" && echo "Participant Passcode: 6054489411" && echo "Sweden 08 5065 3956"'

# Functions
function mgrep()
{
	find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -print0 | xargs -0 grep --color -n "$@"
}

# Copy files to clipboard
alias file_to_clip="xclip -sel clip <"

alias ll='ls -al'

alias nemo='nemo --no-desktop'

# If we're using globash, then change PS1 slightly
[ -n "$GHOME" ] && PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\n\$ '
