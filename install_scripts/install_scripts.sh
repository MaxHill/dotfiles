
# Run terminal installers
for installer in ~/dotfiles/install_scripts/terminal/*.sh; do source $installer; done

# Run desktop installers
for installer in ~/dotfiles/install_scripts/desktop/*.sh; do source $installer; done
