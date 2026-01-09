#!/bin/bash

set -e

# -------- CONFIG --------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLIST_SOURCE_DIR="$DOTFILES_DIR/configs/kanata/launchd"
LAUNCHDAEMONS_DIR="/Library/LaunchDaemons"

KARABINER_PLIST="org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"
KANATA_PLIST="local.kanata.plist"

# -------- FUNCTIONS --------

function check_prerequisites() {
    echo "Checking prerequisites..."
    
    # Check if Karabiner driver is installed
    if [ ! -d "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice" ]; then
        echo "ERROR: Karabiner-DriverKit-VirtualHIDDevice not installed"
        echo "Please install from: https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases"
        exit 1
    fi
    
    # Check if kanata is installed
    if [ ! -f "/Users/8717/.cargo/bin/kanata" ]; then
        echo "ERROR: kanata not found at /Users/8717/.cargo/bin/kanata"
        echo "Please install kanata: cargo install kanata"
        exit 1
    fi
    
    # Check if plist files exist
    if [ ! -f "$PLIST_SOURCE_DIR/$KARABINER_PLIST" ]; then
        echo "ERROR: $KARABINER_PLIST not found in $PLIST_SOURCE_DIR"
        exit 1
    fi
    
    if [ ! -f "$PLIST_SOURCE_DIR/$KANATA_PLIST" ]; then
        echo "ERROR: $KANATA_PLIST not found in $PLIST_SOURCE_DIR"
        exit 1
    fi
    
    echo "Prerequisites check passed"
}

function install_karabiner_daemon() {
    echo "Installing Karabiner daemon LaunchDaemon..."
    
    # Copy plist
    sudo cp "$PLIST_SOURCE_DIR/$KARABINER_PLIST" "$LAUNCHDAEMONS_DIR/"
    sudo chown root:wheel "$LAUNCHDAEMONS_DIR/$KARABINER_PLIST"
    sudo chmod 644 "$LAUNCHDAEMONS_DIR/$KARABINER_PLIST"
    
    # Unload if already loaded (ignore errors)
    sudo launchctl bootout system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
    
    # Load and enable
    sudo launchctl bootstrap system "$LAUNCHDAEMONS_DIR/$KARABINER_PLIST"
    sudo launchctl enable system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon
    
    echo "Karabiner daemon installed and started"
}

function install_kanata() {
    echo "Installing kanata LaunchDaemon..."
    
    # Copy plist
    sudo cp "$PLIST_SOURCE_DIR/$KANATA_PLIST" "$LAUNCHDAEMONS_DIR/"
    sudo chown root:wheel "$LAUNCHDAEMONS_DIR/$KANATA_PLIST"
    sudo chmod 644 "$LAUNCHDAEMONS_DIR/$KANATA_PLIST"
    
    # Unload if already loaded (ignore errors)
    sudo launchctl bootout system/local.kanata 2>/dev/null || true
    
    # Load and enable
    sudo launchctl bootstrap system "$LAUNCHDAEMONS_DIR/$KANATA_PLIST"
    sudo launchctl enable system/local.kanata
    
    echo "Kanata installed and started"
}

function verify_installation() {
    echo ""
    echo "Verifying installation..."
    
    # Wait a moment for services to start
    sleep 2
    
    # Check if services are running
    if sudo launchctl list | grep -q "org.pqrs.Karabiner-VirtualHIDDevice-Daemon"; then
        echo "  [OK] Karabiner daemon service registered"
    else
        echo "  [FAIL] Karabiner daemon service not registered"
    fi
    
    if sudo launchctl list | grep -q "local.kanata"; then
        echo "  [OK] Kanata service registered"
    else
        echo "  [FAIL] Kanata service not registered"
    fi
    
    # Check if processes are running
    if pgrep -f "Karabiner-VirtualHIDDevice-Daemon" > /dev/null; then
        echo "  [OK] Karabiner daemon process running"
    else
        echo "  [FAIL] Karabiner daemon process not running"
    fi
    
    if pgrep -f "kanata" > /dev/null; then
        echo "  [OK] Kanata process running"
    else
        echo "  [FAIL] Kanata process not running"
    fi
}

# -------- MAIN --------

echo "Keyboard LaunchDaemon Installation"
echo "===================================="
echo ""

check_prerequisites
echo ""
install_karabiner_daemon
echo ""
install_kanata
echo ""
verify_installation
echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  - Check status: just keyboard-status"
echo "  - View logs: just kanata-logs"
echo "  - Restart: just keyboard-restart"
echo "  - Reboot to verify auto-start"
