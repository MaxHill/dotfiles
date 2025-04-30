# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#  Aliases
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Git
alias lz = lazygit
alias g = git
alias ga = git add
alias gai = git add -p # Interactive chunked add
alias gaa = git add --all
# alias gaa = gai
alias gc = git commit -m
alias Gc = git commit
alias gac = gaa and gc
alias gpu = git push
alias gp = gpr
alias gpr = git pull --rebase
alias gcm = git checkout master
alias gcd = git checkout develop
alias gco = git checkout
alias gm = git merge
alias glg = git log --graph --pretty = format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset --abbrev-commit
alias gnb = git checkout master and git checkout -b
alias gst = git status
alias gas = functionApplyStashByName
alias nah = git reset HEAD --hard and git clean -df
alias nope = functionDeleteCurrentBranch

# Docker
alias d = docker
alias dc = docker compose

# Just
alias j = just

# Vim
alias vim = nvim

# SSH
alias copySsh = pbcopy < ~/.ssh/id_ed25519.pub

# Helpers
alias aliases = nvim ~/dotfiles/zsh/aliases.sh
alias dotfiles = cd ~/dotfiles
alias vscode = functionOpenVsCodeInsiders
alias zR = exec zsh and echo ZSH updated!
alias hosts = sudo vim /etc/hosts
alias caws = vim ~/.aws/credentials
alias nm = tmux neww -n meeting-note" "~/dotfiles/scripts/cli-notes --dir "meetings" |xargs nvim
alias notes = cd ~/Dropbox/Notes
alias code = cd ~/code

# Overrides 
alias rm = trash # http://hasseg.org/trash/
alias !rm = rm
alias cat = bat


def kp [port_nr:number] {
    let port = [":", $port_nr] | str join;
    let pid = do {lsof -t -i $port} | into string
    if (is-not-empty $pid) {
        let msg = ["Killing pid: ", $pid] | str join 
        let pid = $pid | into int
        print $msg
        kill -9 $pid
    } else {
        ["Nothing running on port ", $port] | str join | print
    }
}
