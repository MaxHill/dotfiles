# dotfiles
Max dotfiles

# Installing basic terminal programms with my settings
## Install the following
* oh-my-zsh
* vs-code insider
* vim
* git
* tmu
* ack & ag ( the silver searcher )
* nvm and latest node

Use the following commands to install them.
```bash
brew install vim &&
brew install git &&
brew install tmux &&
brew install ack && brew install the_silver_searcher &&
brew install nvm && nvm install node --latest-npm && nvm alias default node
```
These you need to follow the guides on the sites
* oh-my-zsh ( https://github.com/robbyrussell/oh-my-zsh )
* vs-code insider ( https://code.visualstudio.com/insiders/ )

## Run the clean script
This script cleans out the default files created by those programs.

```bash
bash clean.sh
```

## Run the install script
This script crates symlinks to with my config files for the programms. It will not replace any existing files. Thats what the clean script is for.

```bash
bash install.sh
```

# Nicer prompt and terminal
## Install pure prompt
```bash
npm install --global pure-prompt
```

## Install Dracula theme
Go here and install it where it's wanted.

https://draculatheme.com