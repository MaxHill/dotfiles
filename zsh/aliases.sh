# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#  Aliases
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Git
alias g='git'
alias ga='git add'
alias gai='git add -p' # Interactive chunked add
#alias gaa='git add --all'
alias gaa='gai'
alias gc='git commit -m'
alias Gc='git commit'
alias gac='gaa && gc'
alias gpu='git push'
alias gp='gpr'
alias gpr='git pull --rebase'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gco='git checkout'
alias gm='git merge'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias branches='git for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes'
alias gnb='git checkout master && git checkout -b'
alias gst='git status'
alias gas='functionApplyStashByName'
alias nah='git reset HEAD --hard && git clean -df'
alias nope='functionDeleteCurrentBranch'
alias clean='git branch -d $(git branch --merged=master | grep -v master) && git fetch --prune'

# AWS
alias invoke="sls invoke local -f example-request-response --data '{ "input":[1,2]}'"

# Docker
alias d="docker"
alias dc="docker compose"

# NPM
alias y="yarn"

# Vim
alias vim="nvim"

# SSH
alias copySsh='pbcopy < ~/.ssh/id_rsa.pub'

# Helpers
alias aliases='nvim ~/dotfiles/zsh/aliases.sh'
alias dotfiles='cd ~/dotfiles'
alias vscode='functionOpenVsCodeInsiders'
alias zR='exec zsh && echo "ZSH updated!"'
alias hosts='sudo vim /etc/hosts'
alias kp='functionKillPort'
alias firefox='/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox --start-debugger-server'
alias lan='functionGetLan'
alias caws="vim ~/.aws/credentials"
alias n='note new | xargs nvim'
alias no='note open | xargs nvim'
alias nm='note meeting-note --folder "Polestar/meetings" | xargs nvim'
alias cat='bat'
alias notes='cd ~/Dropbox/Notes'
alias code='cd ~/code'

# Navigate
alias ls="ls -lhG"
alias lsal="ls -lhAG"
cdls() { cd "$@" && ls; } # Automatically ls when cd
alias cd="cdls"

# Overrides 
alias rm="trash" # http://hasseg.org/trash/
alias !rm="rm"
alias mkdir="mkdir -p"
alias !mkdir="mkdir -p"

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#  Functions
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# All these are aliased above. Use the alias instead of the functions.
# You don't have to care about the functions if you don't want

## Boilerplate
function functionBoilerplate() {
  TYPE=$1
  FOLDER=$2

  # Create folder
  mkdir -p ${FOLDER}
  cd ${FOLDER}

  # Run command
  if [ "client" = ${TYPE} ]; then
    yo @polestar/vs-alpha-frontend
  elif [ "api" = ${TYPE} ]; then
    yo @polestar/boilerplate:api
  else
    yo @polestar/boilerplate:sls-node
  fi
  
  # Cleanup
  cd ..
  echo "Created ${FOLDER}"
  echo "cd ${FOLDER}"
  echo "And start working."
}

## Git
# Apply named stash
function functionApplyStashByName() { 
    NAME=$1
    git stash apply stash^{/$NAME}
}

# Delete whatever branch you are on in git 
function functionDeleteCurrentBranch() { 
    GREEN='\033[0;32m'
    BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')


    if [ "master" = ${BRANCH} ]; then
        echo 'Cant delete branch master'
    else
        git checkout -f master
        git branch -D ${BRANCH}
        echo "${GREEN}Deleted branch ${BRANCH}"
    fi
}

# Open VsCode from terminal
function functionOpenVsCode() {
  if [[ $# = 0 ]]
  then
      open -a "Visual Studio Code"
  else
      [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
      open -a "Visual Studio Code" --args "$F"
  fi
}

# Open VsCode Insider from terminal
function functionOpenVsCodeInsiders() {
  if [[ $# = 0 ]]
  then
      open -a "Visual Studio Code - Insiders"
  else
      [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
      open -a "Visual Studio Code - Insiders" --args "$F"
  fi
}

# Kill what's running on specific port
function functionKillPort() {
  kill $(lsof -t -i:$1)
}

function functionVsCode () {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
        open -a "Visual Studio Code" --args "$F"
    fi
}

function functionGetLan() {
  PORT=$1
  IP=$(ipconfig getifaddr en0)
  URL="http://${IP}:${PORT}"
  echo "${URL}" | pbcopy
  echo "${URL}"
}


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Outdated stuff
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
