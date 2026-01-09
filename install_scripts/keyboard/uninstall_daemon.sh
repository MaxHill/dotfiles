#!/bin/bash

set -e

# -------- CONFIG --------
LAUNCHDAEMONS_DIR="/Library/LaunchDaemons"
KARABINER_PLIST="org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"
KANATA_PLIST="local.kanata.plist"

# -------- FUNCTIONS --------

function stop_services() {
    echo "Stopping services..."
    
    # Stop Karabiner daemon
    if sudo launchctl list | grep -q "org.pqrs.Karabiner-VirtualHIDDevice-Daemon"; then
        echo "  Stopping Karabiner daemon..."
        sudo launchctl bootout system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
    fi
    
    # Stop kanata
    if sudo launchctl list | grep -q "local.kanata"; then
        echo "  Stopping kanata..."
        sudo launchctl bootout system/local.kanata 2>/dev/null || true
    fi
    
    echo "Services stopped"
}

function remove_plists() {
    echo "Removing LaunchDaemon plist files..."
    
    if [ -f "$LAUNCHDAEMONS_DIR/$KARABINER_PLIST" ]; then
        sudo rm -f "$LAUNCHDAEMONS_DIR/$KARABINER_PLIST"
        echo "  Removed $KARABINER_PLIST"
    fi
    
    if [ -f "$LAUNCHDAEMONS_DIR/$KANATA_PLIST" ]; then
        sudo rm -f "$LAUNCHDAEMONS_DIR/$KANATA_PLIST"
        echo "  Removed $KANATA_PLIST"
    fi
}

function verify_uninstall() {
    echo ""
    echo "Verifying uninstallation..."
    
    if sudo launchctl list | grep -q "org.pqrs.Karabiner-VirtualHIDDevice-Daemon\|local.kanata"; then
        echo "  [WARNING] Some services still registered"
    else
        echo "  [OK] All services unregistered"
    fi
    
    if pgrep -f "Karabiner-VirtualHIDDevice-Daemon\|kanata" > /dev/null; then
        echo "  [WARNING] Some processes still running"
    else
        echo "  [OK] All processes stopped"
    fi
}

# -------- MAIN --------

echo "Keyboard LaunchDaemon Uninstallation"
echo "====================================="
echo ""

stop_services
echo ""
remove_plists
echo ""
verify_uninstall
echo ""
echo "Uninstallation complete!"
echo ""
echo "Note: The Karabiner driver system extension is still installed."
echo "To remove it completely, run the Karabiner uninstaller from:"
echo "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/"
