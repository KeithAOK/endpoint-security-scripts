#!/bin/bash
# remediate_gemini_nano.sh
# Removes Google Chrome Gemini Nano model weights and applies persistent policy
# to prevent re-download on macOS managed endpoints
# Deploy via JumpCloud Custom Command, Run As: root
#
# Author: Keith Oquelí
# Version: 1.0 | May 2026

cd /Users/Shared
sleep 1

localuser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ -z "${localuser}" ]; then
    echo "No user is currently logged in."
    exit 1
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)

echo "============================================"
echo "Gemini Nano Remediation Script"
echo "Timestamp: $TIMESTAMP"
echo "Hostname:  $HOSTNAME"
echo "User:      $localuser"
echo "============================================"

# Find and remove weights.bin
MODEL_PATH=$(find "/Users/$localuser/Library/Application Support/Google/Chrome/OptGuideOnDeviceModel" -name "weights.bin" 2>/dev/null | head -1)

if [ -n "$MODEL_PATH" ]; then
    VERSION_DIR=$(dirname "$MODEL_PATH")
    rm -rf "$VERSION_DIR"
    echo "REMEDIATED: Removed $MODEL_PATH"
else
    echo "NOT FOUND: Gemini Nano weights.bin not present on this endpoint"
    echo "No file removal required"
fi

# Apply persistent Chrome policy to prevent re-download
PLIST_DIR="/Library/Managed Preferences"
PLIST_FILE="$PLIST_DIR/com.google.Chrome.plist"

if [ ! -d "$PLIST_DIR" ]; then
    mkdir -p "$PLIST_DIR"
fi

/usr/bin/defaults write "$PLIST_FILE" GenAILocalFoundationalModelSettings -int 1
/usr/bin/defaults write "$PLIST_FILE" OnDeviceModelEnabled -bool false

echo "POLICY:     Chrome managed preference profile applied"
echo "POLICY:     GenAILocalFoundationalModelSettings set to 1"
echo "POLICY:     OnDeviceModelEnabled set to false"
echo "============================================"
echo "Remediation complete. Chrome restart required to apply policy."
exit 0