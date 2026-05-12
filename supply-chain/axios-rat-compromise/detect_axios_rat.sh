#!/bin/bash
# detect_axios_rat.sh
# Detects compromised axios npm package versions associated with RAT delivery
# Compatible with macOS and Linux
# Deploy via JumpCloud Custom Command, Run As: root
#
# Author: Keith A. Oquelí
# Version: 1.0 | May 2026

COMPROMISED_VERSIONS=("1.14.1" "0.30.4")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
FINDINGS=0

echo "============================================"
echo "axios RAT Detection Script"
echo "Timestamp: $TIMESTAMP"
echo "Hostname:  $HOSTNAME"
echo "============================================"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm not found on this endpoint. No axios packages to scan."
    echo "============================================"
    exit 0
fi

# Search for axios in global npm packages
echo "Scanning global npm packages..."
GLOBAL_AXIOS=$(npm list -g axios --depth=0 2>/dev/null | grep axios)

if [ -n "$GLOBAL_AXIOS" ]; then
    for VERSION in "${COMPROMISED_VERSIONS[@]}"; do
        if echo "$GLOBAL_AXIOS" | grep -q "$VERSION"; then
            echo "CRITICAL: Compromised axios v$VERSION found in global npm packages"
            echo "$GLOBAL_AXIOS"
            FINDINGS=$((FINDINGS + 1))
        fi
    done
fi

# Search common project directories for axios
echo "Scanning common project directories..."
SEARCH_DIRS=("$HOME/Documents" "$HOME/Desktop" "$HOME/Projects" "/var/www" "/opt")

for DIR in "${SEARCH_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        while IFS= read -r -d '' PACKAGE_JSON; do
            PROJECT_DIR=$(dirname "$PACKAGE_JSON")
            AXIOS_VERSION=$(node -e "try{const p=require('$PROJECT_DIR/node_modules/axios/package.json');console.log(p.version)}catch(e){}" 2>/dev/null)
            if [ -n "$AXIOS_VERSION" ]; then
                for VERSION in "${COMPROMISED_VERSIONS[@]}"; do
                    if [ "$AXIOS_VERSION" = "$VERSION" ]; then
                        echo "CRITICAL: Compromised axios v$VERSION found in $PROJECT_DIR"
                        FINDINGS=$((FINDINGS + 1))
                    fi
                done
            fi
        done < <(find "$DIR" -name "package.json" -not -path "*/node_modules/*" -print0 2>/dev/null)
    fi
done

echo "============================================"
if [ "$FINDINGS" -gt 0 ]; then
    echo "STATUS:    CRITICAL - $FINDINGS compromised axios installation(s) found"
    echo "ACTION:    Isolate endpoint and escalate to Security Operations immediately"
    exit 1
else
    echo "STATUS:    CLEAN - No compromised axios versions detected"
    exit 0
fi