curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

if [[ $(uname) == "Darwin" ]]; then
    ln -s /Applications/kitty.app/Contents/MacOS/kitty /usr/local/bin/kitty
    ln -s /Applications/kitty.app/Contents/MacOS/kitten /usr/local/bin/kitten
# elif [[ $(uname) == "Linux" ]]; then
    # Linux
fi
