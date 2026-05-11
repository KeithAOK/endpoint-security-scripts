#!/bin/bash
# detect_gemini_nano.sh
# Detects the presence of Google Chrome Gemini Nano model weights on macOS
# Deploy via JumpCloud Custom Command, Run As: root
#
# Author: Keith Oquelí | Security Operations Manager, GRC
# Version: 1.2 | May 2026

cd /Users/Shared
sleep 1

localuser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ -z "${localuser}" ]; then
    echo "No user is currently logged in."
    exit 1
fi

sudo -u "$localuser" /bin/bash <<'EOF'
MODEL_PATH=$(find "$HOME/Library/Application Support/Google/Chrome/OptGuideOnDeviceModel" -name "weights.bin" 2>/dev/null | head -1)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "============================================"
echo "Gemini Nano Detection Script"
echo "Timestamp: $TIMESTAMP"
echo "Hostname:  $(hostname)"
echo "User:      $(whoami)"
echo "============================================"

if [ -n "$MODEL_PATH" ] && [ -f "$MODEL_PATH" ]; then
    SIZE=$(du -sh "$MODEL_PATH" 2>/dev/null | cut -f1)
    SIZE_BYTES=$(stat -f%z "$MODEL_PATH" 2>/dev/null)
    MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$MODEL_PATH" 2>/dev/null)
    echo "STATUS:    FOUND"
    echo "Path:      $MODEL_PATH"
    echo "Size:      $SIZE ($SIZE_BYTES bytes)"
    echo "Modified:  $MODIFIED"
    echo "============================================"
    echo "ACTION REQUIRED: Gemini Nano model weights detected."
    echo "Review remediation options in security advisory."
    exit 1
else
    echo "STATUS:    NOT FOUND"
    echo "Path checked: $MODEL_PATH"
    echo "============================================"
    echo "No action required on this endpoint."
    exit 0
fi
EOF