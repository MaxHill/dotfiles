#!/bin/bash

set -e

# -------- CONFIG --------
SERVICE_NAME="${1:-all}"

# -------- FUNCTIONS --------

function restart_karabiner() {
    echo "Restarting Karabiner daemon..."
    if sudo launchctl list | grep -q "org.pqrs.Karabiner-VirtualHIDDevice-Daemon"; then
        sudo launchctl kickstart -k system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon
        echo "  Karabiner daemon restarted"
    else
        echo "  [ERROR] Karabiner daemon not registered"
        exit 1
    fi
}

function restart_kanata() {
    echo "Restarting kanata..."
    if sudo launchctl list | grep -q "local.kanata"; then
        # Daemon is loaded, just restart it
        sudo launchctl kickstart -k system/local.kanata
        echo "  Kanata restarted"
    else
        # Daemon is not loaded, bootstrap it
        echo "  Kanata not running, loading daemon..."
        if [ -f /Library/LaunchDaemons/local.kanata.plist ]; then
            sudo launchctl bootstrap system /Library/LaunchDaemons/local.kanata.plist
            sudo launchctl enable system/local.kanata
            echo "  Kanata loaded and started"
        else
            echo "  [ERROR] Kanata plist not found at /Library/LaunchDaemons/local.kanata.plist"
            exit 1
        fi
    fi
}

# -------- MAIN --------

case "$SERVICE_NAME" in
    karabiner)
        restart_karabiner
        ;;
    kanata)
        restart_kanata
        ;;
    all)
        restart_karabiner
        echo ""
        restart_kanata
        ;;
    *)
        echo "Usage: $0 [karabiner|kanata|all]"
        echo "  karabiner - Restart only Karabiner daemon"
        echo "  kanata    - Restart only kanata"
        echo "  all       - Restart both (default)"
        exit 1
        ;;
esac

echo ""
echo "Restart complete!"
