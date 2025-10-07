set fish_greeting # Remove welcome message
#  ------------------------------------------------------------------------
#  Key bindings                                                                     
#  ------------------------------------------------------------------------ 
# ctrl+y to accept autosuggestion
bind \cy accept-autosuggestion


#  ------------------------------------------------------------------------
#  Aliases                                                                     
#  ------------------------------------------------------------------------ 
alias ga='git add'
alias gai='git add -p' # Interactive chunked add
alias gaa='git add --all'
alias gcm='git checkout master'
alias gco='git checkout'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gnb='git checkout master && git checkout -b'
alias gst='git status'
alias nah='git reset HEAD --hard && git clean -df'
alias clean='git branch -d $(git branch --merged=master | grep -v master) && git fetch --prune'

# Shortening
alias d="docker"
alias dc="docker compose"
alias j="just"

# SSH
alias copySsh='pbcopy < ~/.ssh/id_ed25519.pub'

# Navigation
alias aliases='nvim ~/dotfiles/configs/fish/.config/fish/config.fish'
alias dotfiles='cd ~/dotfiles'
alias hosts='sudo vim /etc/hosts'
alias notes='cd ~/Dropbox/Notes'
alias code='cd ~/code'
alias notes2="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes"
function fr
    echo "Reloading Fish config..."
    source ~/.config/fish/config.fish
end
function kp 
    set -l port $argv[1]
    kill (lsof -t -i :$port)
end

alias ls="ls -lhG"
alias lsal="ls -lhAG"

# Remaps
alias rm="trash" # http://hasseg.org/trash/
alias cat='bat'
alias vim="nvim"

#  ------------------------------------------------------------------------
#  Prompt                                                                     
#  ------------------------------------------------------------------------ 
function fish_prompt
    # Show current directory in ~ format
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal

    # Git branch and dirty status (robust & quiet)
    if command -sq git
        if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
            set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if test -z "$branch"
                set branch "(no branch)"
            end

            # Check if working tree is dirty
            if test (git status --porcelain 2>/dev/null | wc -l) -gt 0
                echo -n " $branch*"
            else
                echo -n " $branch"
            end
        end
    end

    echo
    set_color green
    echo -n "❯ "
    set_color normal
end

#  ------------------------------------------------------------------------
#  Path                                                                     
#  ------------------------------------------------------------------------ 
# Add my custom scripts to path
set -x PATH $PATH $HOME/dotfiles/scripts

# Use cURL from Homebrew
set -x PATH /usr/local/opt/curl/bin $PATH

# Add /Applications to path
set -x PATH $PATH /Applications

# Add .NET SDKs from Homebrew
set -x PATH /opt/homebrew/opt/dotnet@6/bin $PATH
set -x PATH /opt/homebrew/opt/dotnet@8/bin $PATH
set -x ASPNETCORE_ENVIRONMENT "Development"
set -x ASPNETCORE_URLS "https://localhost:5000/"


# Setup GO
set -x GOPATH $HOME/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

# Setup Rust
set -x PATH $PATH ~/.cargo/bin

# Setup ripgrep
set -Ux RIPGREP_CONFIG_PATH ~/.ripgreprc


set -x PATH $PATH /opt/homebrew/bin

