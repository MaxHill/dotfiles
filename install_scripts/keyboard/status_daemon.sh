#!/bin/bash

# No set -e, we want to continue even if some checks fail

echo "Keyboard Services Status"
echo "========================"
echo ""

# -------- LaunchDaemon Status --------
echo "LaunchDaemon Services:"
echo "----------------------"

if sudo launchctl list | grep -q "org.pqrs.Karabiner-VirtualHIDDevice-Daemon"; then
    echo "  [RUNNING] Karabiner daemon"
else
    echo "  [STOPPED] Karabiner daemon"
fi

if sudo launchctl list | grep -q "local.kanata"; then
    echo "  [RUNNING] Kanata"
else
    echo "  [STOPPED] Kanata"
fi

echo ""

# -------- Process Status --------
echo "Running Processes:"
echo "------------------"

if pgrep -f "Karabiner-VirtualHIDDevice-Daemon" > /dev/null; then
    echo "  [OK] Karabiner daemon process"
    ps aux | grep "Karabiner-VirtualHIDDevice-Daemon" | grep -v grep | awk '{print "       PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
else
    echo "  [FAIL] Karabiner daemon process not running"
fi

if pgrep -f "kanata" > /dev/null; then
    echo "  [OK] Kanata process"
    ps aux | grep "kanata" | grep -v grep | awk '{print "       PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
else
    echo "  [FAIL] Kanata process not running"
fi

echo ""

# -------- System Extension Status --------
echo "System Extension:"
echo "-----------------"

if systemextensionsctl list | grep -q "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice.*activated enabled"; then
    echo "  [OK] Karabiner driver extension active"
    systemextensionsctl list | grep "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice" | sed 's/^/       /'
else
    echo "  [WARNING] Karabiner driver extension not active"
fi

echo ""

# -------- Log Files --------
echo "Log Files:"
echo "----------"

if [ -f "/tmp/karabiner-daemon.err.log" ]; then
    KARABINER_LOG_SIZE=$(stat -f%z "/tmp/karabiner-daemon.err.log")
    echo "  Karabiner: /tmp/karabiner-daemon.err.log ($KARABINER_LOG_SIZE bytes)"
else
    echo "  Karabiner: No log file found"
fi

if [ -f "/tmp/kanata.err.log" ]; then
    KANATA_LOG_SIZE=$(stat -f%z "/tmp/kanata.err.log")
    echo "  Kanata: /tmp/kanata.err.log ($KANATA_LOG_SIZE bytes)"
else
    echo "  Kanata: No log file found"
fi

echo ""

# -------- Recent Errors --------
echo "Recent Errors (last 5 lines):"
echo "-----------------------------"

if [ -f "/tmp/kanata.err.log" ]; then
    echo "  Kanata:"
    tail -n 5 /tmp/kanata.err.log 2>/dev/null | sed 's/^/    /' || echo "    (no errors)"
else
    echo "  Kanata: No log file"
fi

echo ""
