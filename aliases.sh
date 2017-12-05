# Git
alias g='git'
alias ga='git add'
alias gai='git add -p' # Interactive chunked add
alias gaa='git add --all'
alias gc='git commit -m'
alias gcm='git checkout master'
alias gco='git checkout'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gnb='git checkout master && git checkout -b'
alias gpr='git pull --rebase'
alias gst='git status'
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'
alias nah='git reset HEAD --hard && git clean -df'

# Docker
alias d="docker"
alias dc="docker-compose"
dbash() {
    NAME=$1
    sudo docker exec -i -t {$NAME} /bin/bash
}
# Apply stash by name
gas() {
    NAME=$1
    git stash apply stash^{/$NAME}
}

#Mdb - generators
alias g:v="npm run-script generate:view"
alias g:c="npm run-script generate:component"
alias g:e="npm run-script generate:element"
alias g:t="npm run-script generate:test"

# SSH
alias fdev='ssh -o ServerAliveInterval=60 maxh@81.93.147.151'
alias fdev56='ssh -o ServerAliveInterval=60 maxh@81.93.147.150'
alias fdev8='ssh root@81.93.147.140'

alias s1="ssh root@81.93.147.133"
alias s2="ssh root@81.93.147.134"
alias s3="ssh root@81.93.147.135"
alias s4="ssh root@81.93.147.136"
alias s5="ssh root@81.93.147.137"
alias s6="ssh root@81.93.147.138"
alias s7="ssh root@81.93.147.139"
alias s8="ssh root@81.93.147.140"
alias deploy="bash ~/ssh-tmux 81.93.147.133 81.93.147.134 81.93.147.135 81.93.147.136 81.93.147.137 81.93.147.138"
alias stageCron="ssh root@81.93.147.157"



# Mount
alias mountPim='sshfs maxh@maxh.fdev.se:/home/maxh/www/pimcore/website /Users/maxhill/code/website'
alias mountAdminx='sshfs maxh@maxh.fdev.se:/home/maxh/www/pimcore/adminx /Users/maxhill/code/adminx'
alias mountLib='sshfs maxh@maxh.fdev.se:/home/maxh/www/library /Users/maxhill/code/library'
alias mountWww='sshfs maxh@maxh.fdev.se:/home/maxh/www /Users/maxhill/code/www'
alias mountWww6='sshfs maxh@81.93.147.150:/home/maxh/www /Users/maxhill/code/www'

# Helpers
alias aliases='vim ~/.aliases.sh'
alias zSource='source ~/.zshrc && echo "ZSH updated!"'
alias hosts='sudo subl /etc/hosts'
alias a="php artisan"
alias t="phpunit"
alias mm="bundle exec middleman"

#navigate
alias lsl="ls -l"
alias lsal="ls -al"
alias code='cd /mnt/c/code'
alias moln='cd /mnt/c/code/Molnlycke/src/Molnlycke.MVC'
alias forever='cd ~/code/storm'

nope() {
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

crap() {
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m' #no color
    echo ""
    echo ""
    echo "          ${YELLOW}Fix input/output error${NC}"
    echo "          1) Find the culprit sshfs process:"
    echo "          ${GREEN}$ pgrep -lf sshfs${NC}"
    echo ""
    echo "          2) Kill it:"
    echo "          ${GREEN}$ kill -9 <pid_of_sshfs_process>${NC}"
    echo ""
    echo "          3) sudo force unmount the "unavailable" directory:"
    echo "          ${GREEN}$ sudo umount -f <mounted_dir>${NC}"
    echo ""
    echo "          4) Remount the now "available" directory with sshfs ... and then tomorrow morning go back to step 1."
    echo ""
    echo ""
}

# Create jekyll blogpost
post() {
    GREEN='\033[0;32m'
    NAME=$1
    DATE=`date +%Y-%m-%d`

    touch $DATE'-'$NAME'.md'
    echo ${GREEN}'Created: ' $DATE'-'$NAME'.md'
}

sgrok() {
    # https://www.npmjs.com/package/kkpoon-pushbullet-cli

    # ngrok http $1 --log=stdout > /dev/null &
    # sleep 5

    NGROK_URL=`curl -s http://127.0.0.1:4040/status | sed -ne 's/.*\(http[^"]*ngrok.io\).*/\1/p'`

    if [[ $NGROK_URL != *"http"* ]]; then
        echo "No url found. Is ngrok running?"
        return
    fi
    echo $NGROK_URL
    pushbullet push link --title "Devsite" --body "Development site" --url $NGROK_URL > /dev/null 2>&1
}
