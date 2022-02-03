# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="af-magic"

# Set tmux screen
export TERM="xterm-256color"

# Start tmux if installed
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  # ZSH_TMUX_AUTOSTART=true
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  plugins=(
    git 
    tmux 
    zsh-syntax-highlighting
    zsh-autosuggestions
  )


  source $ZSH/oh-my-zsh.sh
fi

# User configuration


# Example aliases
source ~/.aliases.sh

# NVM & Node
# Run following to install nvm (mac)
#$ brew update && brew upgrade
#$ brew install nvm
export NVM_DIR=~/.nvm

source $(brew --prefix nvm)/nvm.sh

