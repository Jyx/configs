source $HOME/.myenv

################################################################################
# Bash alias
################################################################################
alias ls='ls --color=auto'
alias ll='ls -al --color=auto'

################################################################################
# Server alias
################################################################################
alias bonito2='ssh -X jyx@jyx.mooo.com'
alias fsdata='ssh -X jyx@jyxpi.mooo.com'
alias hackbox='ssh -X joakim.bech@hackbox.linaro.org'
alias mount_hackbox='sshfs joakim.bech@hackbox.linaro.org:/home/joakim.bech /home/jbech/mnt/hackbox'
alias mount_people='sshfs joakim.bech@people.linaro.org:/home/joakim.bech /home/jbech/mnt/people'
alias optee='ssh -X optee@optee.mooo.com -p 2222'
alias people='ssh -X joakim.bech@people.linaro.org'

################################################################################
# Tools
################################################################################
alias t='$HOME/bin/todo.sh'

################################################################################
# GPG
################################################################################
# RSA keys update 2018-12-05
ENC_KEY=7AC319FD
SIGN_KEY=3CEB3C94
AUTH_KEY=0EC497DA

export GPGKEY=189693C7

alias gpg='gpg2'

# Function use to encrypt files locally for my own sake.
# Note to use this the private keys must reside in the keyring!
function encrypt () { gpg -e -r "$ENC_KEY!" $1; }
function decrypt () { gpg -d --output $1.plaintext $1; }

function sign () { gpg --default-key "$SIGN_KEY!" -o $1.sig --detach-sign $1; }
function check_sign () { gpg --verify $1.sig $1; }

################################################################################
# Git related alias
################################################################################
alias gb='git branch -v'
alias gs='git status'
alias grv='git remote -v'
alias gh_url="git remote -v | head -1 | awk '{print $2}' | sed -e 's/https:\/\/github.com\/\(.*\)/git@github.com:\1/g'"
alias review_tag="echo \"Reviewed-by: Joakim Bech <joakim.bech@linaro.org>\""

alias gsm='git submodule'
alias gsm_clean_all='git submodule foreach "git clean -xdf && git checkout -f"'
alias gsm_jbech="git submodule foreach 'git remote add jbech git@github.com:jbech-linaro/$name.git'"

# To checkout a GitHub pull request directly
function gpr_origin_as_branch () { git fetch origin pull/$1/head:github_pr_$1 && git checkout github_pr_$1; }
function gpr_origin { git fetch origin pull/$1/head && git checkout FETCH_HEAD; }

function gpr_github_as_branch () { git fetch github pull/$1/head:github_pr_$1 && git checkout github_pr_$1; }
function gpr_github { git fetch github pull/$1/head && git checkout FETCH_HEAD; }

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

################################################################################
# Repo related alias
################################################################################
alias rpo_rev='repo forall -c '\''echo $REPO_PATH -- `git log --oneline -1`'\'''
alias rpo_clean_all="repo forall -c 'echo Cleaning ... \$REPO_PATH && git clean -xdf && git checkout -f'"
alias rpo_jbech='repo forall -c "git remote add jbech git@github.com:jbech-linaro/\$REPO_PATH.git"'
alias rpo_s='repo sync -j3 -d'
alias rpo_gcc='./toolchains/aarch32/bin/arm-linux-gnueabihf-gcc --version | grep "GNU Toolchain" && ./toolchains/aarch64/bin/aarch64-linux-gnu-gdb --version | grep "GNU Toolchain"'

alias tmux='tmux -2'
alias byobunew='byobu new -s'

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
# Android / AOSP
################################################################################
alias adb_tee="adb logcat TrustyKeymaster:V GoldfishGatekeeper:V *:S -v long,color -d"
alias emulator_tee="emulator -no-window -no-boot-anim -no-audio -ranchu"
alias adb_unlock_screen="adb shell input keyevent 82 && adb shell input text 1234 && adb shell input keyevent 66"

# Comes from make/envsetup.sh in AOSP
function gettop
{
    local TOPFILE=GTAGS
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            local T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function croot()
{
    local T=$(gettop)
    if [ "$T" ]; then
        if [ "$1" ]; then
            \cd $(gettop)/$1
        else
            \cd $(gettop)
        fi
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

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

################################################################################
# QEMU Arm on x86
################################################################################
alias qemu_arm='qemu-arm -E LD_LIBRARY_PATH=/media/jbech/SSHD_LINUX/devel/optee_projects/reference/toolchains/aarch32/arm-linux-gnueabihf/libc/lib/ /media/jbech/SSHD_LINUX/devel/optee_projects/reference/toolchains/aarch32/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3'

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
	#echo "$1 : $2"
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
alias gnome_settings='env XDG_CURRENT_DESKTOP=GNOME gnome-control-center'

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
