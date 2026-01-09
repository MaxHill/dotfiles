#!/usr/bin/env just --justfile
# SETTINGS
set dotenv-load := true
# set dotenv-filename := "app/.env"

# List available commands
default:
    @just --list

# Install keyboard LaunchDaemons (Karabiner + kanata)
install-keyboard:
    @./install_scripts/keyboard/install_daemon.sh

# Uninstall keyboard LaunchDaemons
uninstall-keyboard:
    @./install_scripts/keyboard/uninstall_daemon.sh

# Check keyboard services status
keyboard-status:
    @./install_scripts/keyboard/status_daemon.sh

# Restart all keyboard services
keyboard-restart:
    @./install_scripts/keyboard/restart_daemon.sh all

# Restart Karabiner daemon only
karabiner-restart:
    @./install_scripts/keyboard/restart_daemon.sh karabiner

# Restart kanata only (useful after config changes)
kanata-restart:
    @./install_scripts/keyboard/restart_daemon.sh kanata

# Enable experimental 32-key split keyboard layout
kanata-experimental:
    @echo "Switching to experimental 32-key layout..."
    @cp ~/.config/kanata/kanata.kbd ~/.config/kanata/kanata.kbd.backup
    @cp ~/.config/kanata/kanata-32key-experimental.kbd ~/.config/kanata/kanata.kbd
    @./install_scripts/keyboard/restart_daemon.sh kanata
    @echo "✓ Experimental 32-key layout enabled"
    @echo "To revert: just kanata-normal"

# Restore normal kanata config from backup
kanata-normal:
    @echo "Restoring normal config..."
    @if [ -f ~/.config/kanata/kanata.kbd.backup ]; then \
        cp ~/.config/kanata/kanata.kbd.backup ~/.config/kanata/kanata.kbd; \
        ./install_scripts/keyboard/restart_daemon.sh kanata; \
        echo "✓ Normal config restored"; \
    else \
        echo "✗ No backup found. Please restore manually from dotfiles repo."; \
    fi

# Pause kanata daemon (stops the service temporarily)
kanata-pause:
    @echo "Pausing kanata daemon..."
    @sudo launchctl bootout system/local.kanata 2>/dev/null || true
    @echo "✓ Kanata daemon paused"
    @echo "To resume: just kanata-resume"

# Resume kanata daemon (restart the service)
kanata-resume:
    @echo "Resuming kanata daemon..."
    @./install_scripts/keyboard/restart_daemon.sh kanata
    @echo "✓ Kanata daemon resumed"

# Test experimental 32-key layout without replacing config (Ctrl+C to exit)
kanata-test-experimental:
    @echo "Testing experimental 32-key layout..."
    @echo "This will pause the daemon and run kanata in foreground."
    @echo "Press Ctrl+C to stop, then run 'just kanata-resume' to restore daemon."
    @echo ""
    @sudo launchctl bootout system/local.kanata 2>/dev/null || true
    @echo "Starting experimental config in debug mode..."
    @sudo kanata --cfg ~/.config/kanata/kanata-32key-experimental.kbd

# View kanata logs in real-time
kanata-logs:
    @echo "Kanata logs (Ctrl+C to exit):"
    @tail -f /tmp/kanata.err.log

# View Karabiner daemon logs
karabiner-logs:
    @echo "Karabiner daemon logs (Ctrl+C to exit):"
    @tail -f /tmp/karabiner-daemon.err.log

# View recent kanata errors
kanata-errors:
    @echo "Recent kanata errors (last 50 lines):"
    @tail -n 50 /tmp/kanata.err.log

# Manual keyboard testing (stops services temporarily)
keyboard-test:
    @echo "Stopping LaunchDaemon services for manual testing..."
    @sudo launchctl bootout system/local.kanata 2>/dev/null || true
    @echo "Starting kanata in debug mode (Ctrl+C to exit)..."
    @echo "Services will NOT restart automatically - run 'just install-keyboard' to restore"
    @sudo kanata --cfg ~/.config/kanata/kanata.kbd --debug

brew:
    ansible-playbook bootstrap.yml --tags "brew" 

dependencies:
    ansible-playbook bootstrap.yml --tags "dependencies"

symlinks:
    ansible-playbook bootstrap.yml --tags "symlinks"


