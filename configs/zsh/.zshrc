# Needs to be above tmux
export TERM="xterm-256color"


# Exported variables
export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES="$HOME/dotfiles"
export NOTES_HOME="$HOME/Dropbox/Notes"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Needed to fix for vi mode always overriding keybindings 
# see https://stackoverflow.com/questions/73033698/fzf-keybindings-doesnt-work-with-zsh-vi-mode 
# and https://stackoverflow.com/questions/73033698/fzf-keybindings-doesnt-work-with-zsh-vi-mode#:~:text=mode.%20As%20mentioned-,here,-%2C%20Loading%20the%20fzf
# export ZVM_INIT_MODE=sourcing 



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


# ZSH Plugins
# ------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh           # Auto suggestion for terminal
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh   # Syntax highlighting for terminal
# source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh   # Better vim mode

# vi mode
# ------------------
bindkey -v # Enable vi mode instead of emacs

# Edit command in vim
# ------------------
autoload -z edit-command-line
zle -N edit-command-line

# PATH Management
# ------------------
export PATH=$PATH:$HOME/dotfiles/scripts                                  # Add my custom scripts to path

export PATH="/usr/local/opt/curl/bin:$PATH"                               # Use cUrl from homebrew

export PATH="$PATH:/Applications"                               # Use cUrl from homebrew

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Keymap
# ------------------
bindkey '^y' autosuggest-accept # Accept suggestion
bindkey "^e" edit-command-line # Edit current command in vim
bindkey "^p" up-line-or-history
bindkey "^n" down-line-or-history

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
