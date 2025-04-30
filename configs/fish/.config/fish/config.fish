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
