# Needs to be above tmux
export TERM="xterm-256color"


# Exported variables
export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES="$HOME/dotfiles"


# ZSH options
# ------------------
set -o AUTO_CD        # Don't require cd 


# Imports
# ------------------
source ~/.zsh_aliases


# fnm (fast node manager)
# ------------------
eval "$(fnm env --use-on-cd --version-file-strategy "recursive" --log-level "quiet")"  # Init fnm (fast node manager)


# Tmux
# ------------------
# Start tmux if installed
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  if [ "$TMUX" = "" ]; then tmux attach || tmux new; fi
fi

# Install tmux plugins
~/.config/tmux/plugins/tpm/bin/install_plugins >> /dev/null


# Pure prompt
# ------------------
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure
export PURE_PROMPT_SYMBOL=""


# ZSH Plugins
# ------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh           # Auto suggestion for terminal
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh   # Syntax highlighting for terminal


# Keymap
# ------------------
bindkey '^n' autosuggest-accept


# PATH Management
# ------------------
export PATH=$PATH:$HOME/dotfiles/scripts                                  # Add my custom scripts to path

export PATH="$PATH:/Users/maxhill/.dotnet/tools"                          # Add .NET Core SDK tools

export PATH="/usr/local/opt/curl/bin:$PATH"                               # Use cUrl from homebrew

[ -f "/Users/maxhill/.ghcup/env" ] && source "/Users/maxhill/.ghcup/env" # ghcup-env

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
