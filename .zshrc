# This profile expects the following 3rd parties applications to be installed on the system
# - oh-my-posh: brew install oh-my-posh; sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
# - zoxide: brew install zoxide; apt install zoxide

# Add homebrew apps to path
case `uname` in 
	Darwin)
		eval "$(/opt/homebrew/bin/brew shellenv)"
esac
# Disable brew auto update
# export HOMEBREW_NO_AUTO_UPDATE=1

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# source/load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippits
zinit snippet OMZP::git
#zinit snippet OMZP::docker
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Source oh-my-posh prompt
# Does not work on OSX build in Terminal App so check
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/pure.toml)"
fi

# keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[A' history-search-backward
bindkey '^[OA' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[OB' history-search-forward

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias afk="osascript -e 'tell app \"System Events\" to key code 12 using {control down, command down}'"
# interact with dell kvm (from mac side)
alias switch="/Users/carl.neuhaus/Downloads/m1ddc-1.2.0/m1ddc display 11B779B9-7A11-4A52-AAA9-9AE32F876362 set input 15"
alias localports='sudo lsof -PiTCP -sTCP:LISTEN'
# Docker specific
alias dockerstart="osascript -e 'tell app \"Docker\" to activate'"
alias dockerstop="osascript -e 'quit app \"Docker\"'"
alias dockershell='docker run --rm -i -t --entrypoint=/bin/bash'
alias dockershellsh='docker run --rm -i -t --entrypoint=/bin/sh'
alias dockershellpersistent="docker run -i -t --entrypoint=/bin/bash -v '/Users/poppy/.dockershared':'/data/'"
alias nginxhere='docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" rflathers/nginxserve'
alias uploadhere='docker run -p 25478:25478 -v $HOME/tmp:/var/root mayth/simple-upload-server app -token f9403fc5f537b4ab332d /var/root'
alias uploadhere='docker run --rm -it -p80:3000 -v "${PWD}:/data" rflathers/postfiledump'
alias metasploit='docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole'
alias metasploitports='docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 4444:4444 -p 8443-8500:8443-8500 metasploitframework/metasploit-framework ./msfconsole'
alias mobsecurity='docker run --rm -it -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest'
alias torproxy='docker run --rm -it -p 127.0.0.1:9150:9150  peterdavehello/tor-socks-proxy:latest'
alias domainhunter='docker run --rm -it domainhunter'
alias rpcclient='docker run --rm -it --entrypoint=/bin/bash dperson/samba'
alias gitleaks='docker run --rm zricethezav/gitleaks -v'
alias reqdump='docker run --rm -it -p 80:3000 rflathers/reqdump'
alias impacket="docker run --rm -v '/Users/poppy/.impacket/':'/opt/impacket/examples' -it rflathers/impacket"
alias impacketenv="docker run --rm -v '/Users/poppy/.impacket/':'/opt/impacket/examples' -e KRB5CCNAME=/opt/carl.ccache -it rflathers/impacket"
# Okta specific aliases
alias pgit='GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519  -o IdentitiesOnly=yes" git'

# Functions
# Docker functions
function dockerconnect { docker exec -it $1 bash; }
function dockerconnectsh { docker exec -it $1 sh; }
# Get Okta Org
function get_org_id() {
    result=$(curl -sS "https://$1.okta.com/.well-known/okta-organization" | jq '{id: .id, cell: .cell}')
    id=$(echo "$result" | jq -r '.id')

    if [[ "$id" == "00oplaODtXoEq1eQo0g3" ]]; then
        echo '{"error": "org doesnt exist"}' | jq
    else
        echo "$result" | jq
    fi
}
# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}
# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Shell integrations
#eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Environment exports
export EDITOR='vim'
# Don't clear the screen when exiting man
export MANPAGER='less -X'
# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
#setopt hist_ignore_all_dups
#setopt hist_save_no_dups
#setopt hist_ignore_dups
#setopt hist_find_no_dups