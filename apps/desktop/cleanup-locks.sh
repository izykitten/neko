#!/usr/bin/env bash
set -euo pipefail

USER_HOME="/home/neko"
CONFIG_DIR="$USER_HOME/.config"
PROFILE_FIREFOX="$USER_HOME/.mozilla/firefox"
PROFILE_WATERFOX="$USER_HOME/.waterfox"

# Ensure home exists
mkdir -p "$USER_HOME"
chown -R neko:neko "$USER_HOME" || true

# Delete Chromium-family singleton locks
for app in chromium Google\ Chrome microsoft-edge BraveSoftware/Brave-Browser Vivaldi opera; do
  dir="$CONFIG_DIR/$app"
  find "$dir" -type f \( -name 'SingletonLock' -o -name 'SingletonCookie' -o -name 'SingletonSemaphore' \) -print -delete 2>/dev/null || true
  # Also clean Default profile subdir if exists
  find "$dir/Default" -type f \( -name 'SingletonLock' -o -name 'SingletonCookie' -o -name 'SingletonSemaphore' \) -print -delete 2>/dev/null || true
done

# Firefox/Waterfox lock cleanup
# Remove parent.lock and .lock files from default profiles
find "$PROFILE_FIREFOX" -type f -name 'parent.lock' -print -delete 2>/dev/null || true
find "$PROFILE_FIREFOX" -type f -name '*.lock' -print -delete 2>/dev/null || true
find "$PROFILE_WATERFOX" -type f -name 'parent.lock' -print -delete 2>/dev/null || true
find "$PROFILE_WATERFOX" -type f -name '*.lock' -print -delete 2>/dev/null || true

# Tor Browser lock cleanup
find "/opt/tor-browser_en-US" -type f -name 'parent.lock' -print -delete 2>/dev/null || true

# Ensure ownership
chown -R neko:neko "$CONFIG_DIR" "$PROFILE_FIREFOX" "$PROFILE_WATERFOX" "/opt/tor-browser_en-US" 2>/dev/null || true

echo "Browser lock cleanup complete."