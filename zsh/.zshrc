# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="eastwood"

plugins=(git vagrant docker z fzf)


# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='vim'
#
# gpu switch
# sudo pmset -a gpuswitch x
# x = 0 = integrated
# x = 1 = discrete
# x = 2 = autoswitch

# stop brew autoupdating
export HOMEBREW_NO_AUTO_UPDATE=1 

# geos
export GEOS_DIR=/usr/local/Cellar/geos/3.7.1_1/

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/poppy/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/poppy/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/poppy/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/poppy/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

alias cat="batcat"
alias catp="batcat -p"
alias space="ncdu"
alias pbcopy="xclip -sel clip"
alias pbpaste="xclip -o -sel clip"


#alias android='/Users/poppy/Library/Android/sdk/emulator/emulator'
export PATH="/usr/local/opt/openssl/bin:$PATH"

alias localports='sudo lsof -PiTCP -sTCP:LISTEN'

#enrich current terminal window with AWS credentials
alias enrichAWS="echo 'Touch key' && gpg -d ~/.aws/env.gpg | source /dev/stdin"

# add pip local user stuff to path
export PATH="/home/skittles/.local/bin":$PATH

# System stats
alias temps="watch -n 1 sensors"
alias gtemps="watch -n 1 nvidia-smi"
alias syst="inxi -b"
alias cpugraph="s-tui"
alias windirstat="baobab"

# provides alias to view current steam background shader logs
alias shaderlogs="tail -f ~/.steam/root/logs/shader_log.txt"

## vscode
#alias code="/var/lib/flatpak/app/com.visualstudio.code/x86_64/stable/8036dd3058a666867c0fe112370049638971d1f4060946b1fea5b3327cec1f7e/files/extra/vscode/bin/code"

# Cuda NVCC gcc for gpu
export PATH=$PATH:/usr/local/cuda-12.4/bin/

# Discord process finished notify webhook
# usage: <command> && notify
alias notify='curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST --data "{\"content\": \"Process finished\"}" https://discord.com/api/webhooks/1257984703361847377/KfiNhXZMvoXhwlgSvsRthoM-R84gncrbmyUukzFPefE6Kcx9XaRziOPKw6-w6DLXsOUU  -s -o nul'

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

alias jamjarenv="docker run  -i -t --entrypoint=/bin/bash -v '/Users/poppy/Documents/JamJar/:/jamjar'"

alias dockernginx="docker run --rm -i -t --entrypoint=/bin/bash -p 80:80 -p 443:443"

alias dfimage="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock centurylink/dockerfile-from-image"

# Docker functions
function dockerconnect { docker exec -it $1 bash; }
function dockerconnectsh { docker exec -it $1 sh; }

function mysqlclient {
  if [ "$#" -ne 2 ]; then
    echo "mysqlclient <host> <username>"
    return
  fi
  docker run -it arey/mysql-client -h $1 -u $2 -p;
}

function org { sort | uniq -c | sort -n }

export HISTFILE=~/.zsh_history
export HISTSIZE=999999999
setopt EXTENDED_HISTORY
export SAVEHIST=$HISTSIZE

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# begin forge completion
#. <(forge --completion)
# end forge completion
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PROMPT='$FG[008][%M]$(git_custom_status)%{$fg[cyan]%}[%~% ]%{$reset_color%}%B$%b '

# protontricks
#alias protontricks='flatpak run /home/skittles/.var/app/com.github.Matoking.protontricks/cache/protontricks'
#alias protontricks-launch='flatpak run --command=protontricks-launch /home/skittles/.var/app/com.github.Matoking.protontricks/cache/protontricks'
