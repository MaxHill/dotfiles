cd /tmp
GUM_VERSION="0.14.3" # Use known good version
wget -qO gum.tar.gz "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Darwin_arm64.tar.gz"

tar -xzf "gum.tar.gz"
sudo mv ./gum_${GUM_VERSION}_Darwin_arm64/gum /usr/local/bin/

rm "gum.tar.gz"
rm -rf "gum_${GUM_VERSION}_Darwin_arm64"
cd -
