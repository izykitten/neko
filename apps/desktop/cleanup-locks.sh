#!/usr/bin/env bash
set -euo pipefail

USER_HOME="/home/neko"
CONFIG_DIR="$USER_HOME/.config"
PROFILE_FIREFOX="$USER_HOME/.mozilla/firefox"
PROFILE_WATERFOX="$USER_HOME/.waterfox"
TOR_DIR="/opt/tor-browser_en-US"

log_info() { printf '[cleanup] %s\n' "$*"; }
log_warn() { printf '[cleanup][warn] %s\n' "$*" >&2; }

# Ensure home exists
mkdir -p "$USER_HOME"
chown -R neko:neko "$USER_HOME"

clean_chromium_locks() {
  local app="$1"
  local dir="$CONFIG_DIR/$app"
  if [[ ! -d "$dir" ]]; then
    log_info "skip $app (no dir)"
    return 0
  fi

  # User data dir
  if ! find "$dir" \( -type f -o -type l \) \
      \( -name 'SingletonLock' -o -name 'SingletonCookie' -o -name 'SingletonSemaphore' \) \
      -print -delete; then
    log_warn "find failed in $dir"
  fi

  # Default profile
  if [[ -d "$dir/Default" ]]; then
    if ! find "$dir/Default" \( -type f -o -type l \) \
        \( -name 'SingletonLock' -o -name 'SingletonCookie' -o -name 'SingletonSemaphore' \) \
        -print -delete; then
      log_warn "find failed in $dir/Default"
    fi
  fi

  # Other profiles: Profile 1, Profile 2, etc.
  if ! find "$dir" -maxdepth 1 -type d -name 'Profile *' -print0 2>/dev/null | \
      while IFS= read -r -d '' profile; do
        if ! find "$profile" \( -type f -o -type l \) \
            \( -name 'SingletonLock' -o -name 'SingletonCookie' -o -name 'SingletonSemaphore' \) \
            -print -delete; then
          log_warn "find failed in $profile"
        fi
      done; then
    log_warn "profile scan failed in $dir"
  fi
}

for app in chromium "Google Chrome" microsoft-edge BraveSoftware/Brave-Browser Vivaldi opera; do
  clean_chromium_locks "$app"
done

clean_firefox_like() {
  local path="$1"
  [[ -d "$path" ]] || { log_info "skip $path (no dir)"; return 0; }
  for pattern in 'parent.lock' '*.lock'; do
    if ! find "$path" -type f -name "$pattern" -print -delete; then
      log_warn "find failed in $path for $pattern"
    fi
  done
}

clean_firefox_like "$PROFILE_FIREFOX"
clean_firefox_like "$PROFILE_WATERFOX"

if [[ -d "$TOR_DIR" ]]; then
  if ! find "$TOR_DIR" -type f -name 'parent.lock' -print -delete; then
    log_warn "find failed in $TOR_DIR"
  fi
else
  log_info "skip tor (no dir)"
fi

# Ensure ownership for existing dirs
for dir in "$CONFIG_DIR" "$PROFILE_FIREFOX" "$PROFILE_WATERFOX" "$TOR_DIR"; do
  [[ -d "$dir" ]] && chown -R neko:neko "$dir"
done

log_info "Browser lock cleanup complete."