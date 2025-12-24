# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

#
# install browsers and tools
SHELL ["/bin/bash", "-c"]

# Install systemd
RUN apt-get update && \
    apt-get install -y --no-install-recommends systemd systemd-sysv

#
# install kde
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends kde-full kwin-x11 sudo \
    konsole; \
    #
    # add user to sudoers
    usermod -aG sudo neko; \
    echo "neko:neko" | chpasswd; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    # clean up
    apt remove xserver-xorg-legacy -y; \
    apt-get clean -y

#
# disable autolock
RUN mkdir -p /etc/xdg; \
    echo -e "[Daemon]\nAutolock=false" > /etc/xdg/kscreenlockerrc; \
    chown root:root /etc/xdg/kscreenlockerrc

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    ARCH=$(dpkg --print-architecture); \
    #
    # install base browser dependencies
    apt-get install -y --no-install-recommends \
        wget curl xz-utils jq unzip bzip2 file \
        apt-transport-https \
        libatk1.0-0 libatk-bridge2.0-0 libatomic1 \
        libcups2 libnss3 libpci3 libxcomposite1 libxss1; \
    #
    # install Firefox
    if [ "${ARCH}" = "amd64" ]; then \
        SRC_URL="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"; \
    elif [ "${ARCH}" = "arm64" ]; then \
        SRC_URL="https://download.mozilla.org/?product=firefox-latest&os=linux64-aarch64&lang=en-US"; \
    fi; \
    if [ ! -z "${SRC_URL}" ]; then \
        curl -fsSL -o /tmp/firefox-setup.tar.xz "${SRC_URL}"; \
        tar -xJf /tmp/firefox-setup.tar.xz -C /tmp; \
        mv /tmp/firefox /usr/lib/firefox; \
        rm -f /tmp/firefox-setup.tar.xz; \
        ln -s /usr/lib/firefox/firefox /usr/bin/firefox; \
    fi; \
    #
    # install Chromium (detect Debian vs Ubuntu)
    . /etc/os-release; \
    if [ "$ID" = "debian" ]; then \
        echo "deb http://deb.debian.org/debian ${VERSION_CODENAME} main" >> /etc/apt/sources.list; \
        apt-get update; \
        apt-get install -y --no-install-recommends chromium chromium-common chromium-sandbox; \
    elif [ "$ID" = "ubuntu" ]; then \
        apt-get update; \
        apt-get install -y --no-install-recommends chromium-browser openbox || apt-get install -y --no-install-recommends chromium openbox; \
    else \
        apt-get update; \
        apt-get install -y --no-install-recommends chromium chromium-common chromium-sandbox; \
    fi; \
    #
    # install Google Chrome
    curl -fsSL -o /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"; \
    apt-get install -y --no-install-recommends /tmp/google-chrome.deb; \
    rm -f /tmp/google-chrome.deb; \
    #
    # install Brave
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=${ARCH}] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | tee /etc/apt/sources.list.d/brave-browser-release.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends brave-browser; \
    #
    # install Microsoft Edge
    API_URL="https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/"; \
    SRC_URL="${API_URL}$(curl -fsSL "${API_URL}" | sed -n 's/.*href="\([^"]*\).*/\1/p' | sort --version-sort | tail -1)"; \
    curl -fsSL -o /tmp/microsoft-edge.deb "${SRC_URL}"; \
    apt-get install -y --no-install-recommends /tmp/microsoft-edge.deb; \
    rm -f /tmp/microsoft-edge.deb; \
    #
    # install Opera
    . /etc/os-release; \
    if [ "$ID" = "debian" ] && [ "${ARCH}" = "amd64" ]; then \
        curl -fsSLo /usr/share/keyrings/opera-archive-keyring.gpg \
            https://deb.opera.com/archive.key; \
        echo "deb [signed-by=/usr/share/keyrings/opera-archive-keyring.gpg] https://deb.opera.com/opera stable non-free" \
            | tee /etc/apt/sources.list.d/opera.list; \
        apt-get update; \
        apt-get install -y --no-install-recommends opera-stable; \
    elif [ "$ID" = "ubuntu" ] && [ "${ARCH}" = "amd64" ]; then \
        OPERA_BASE_URL="https://download3.operacdn.com/pub/opera/desktop/"; \
        OPERA_VERSION="$(curl -fsSL "${OPERA_BASE_URL}" | sed -n 's/.*href=\"\([0-9][^\"]*\)\/\".*/\1/p' | sort --version-sort | tail -1)"; \
        OPERA_DEB_URL="${OPERA_BASE_URL}${OPERA_VERSION}/linux/opera-stable_${OPERA_VERSION}_amd64.deb"; \
        curl -fsSL -o /tmp/opera.deb "${OPERA_DEB_URL}"; \
        apt-get install -y --no-install-recommends /tmp/opera.deb; \
        rm -f /tmp/opera.deb; \
    fi; \
    #
    # install Vivaldi
    curl -fsSL -o /tmp/vivaldi.deb "https://downloads.vivaldi.com/stable/vivaldi-stable_${ARCH}.deb"; \
    apt-get install -y --no-install-recommends /tmp/vivaldi.deb; \
    rm -f /tmp/vivaldi.deb; \
    #
    # install VLC
    apt-get install -y --no-install-recommends vlc; \
    #
    # install Remmina with RDP and VNC support only
    apt-get install -y --no-install-recommends remmina remmina-plugin-rdp remmina-plugin-vnc; \
    #
    # install OBS Studio (official PPA for Ubuntu, package repo for Debian)
    . /etc/os-release; \
    if [ "$ID" = "ubuntu" ]; then \
        apt-get install -y --no-install-recommends software-properties-common; \
        add-apt-repository -y ppa:obsproject/obs-studio; \
        apt-get update; \
        apt-get install -y --no-install-recommends obs-studio; \
    elif [ "$ID" = "debian" ]; then \
        apt-get install -y --no-install-recommends obs-studio; \
    fi; \
    #
    # install Tor Browser
    DOWNLOAD_URI="$(curl -s -N https://www.torproject.org/download/ | grep -Po -m 1 '(?=(dist/torbrowser)).*(?<=.tar.xz)')"; \
    curl -sSL -o /tmp/tor.tar.xz "https://www.torproject.org/$DOWNLOAD_URI"; \
    tar -xJf /tmp/tor.tar.xz -C /tmp; \
    mv /tmp/tor-browser* /opt/tor-browser_en-US; \
    chown -R neko:neko /opt/tor-browser_en-US/; \
    rm -f /tmp/tor.tar.xz; \
    #
    # install Ungoogled Chromium
    API_URL="https://api.github.com/repos/macchrome/linchrome/releases/latest"; \
    SRC_URL="$(curl -fsSL "${API_URL}" | jq -r "[.assets[] | select(.browser_download_url | contains(\"tar.xz\"))][-1] | .browser_download_url")"; \
    curl -fsSL -o /tmp/chromium.tar.xz "${SRC_URL}"; \
    tar -xJf /tmp/chromium.tar.xz -C /tmp; \
    rm -f /usr/lib/ungoogled-chromium; \
    mv /tmp/ungoogled-chromium_* /usr/lib/ungoogled-chromium; \
    mv /usr/lib/ungoogled-chromium/chrome_sandbox /usr/lib/ungoogled-chromium/chrome-sandbox; \
    chown root:root /usr/lib/ungoogled-chromium/chrome-sandbox; \
    chmod 4755 /usr/lib/ungoogled-chromium/chrome-sandbox; \
    rm -f /tmp/chromium.tar.xz; \
    #
    # install Jellyfin Desktop
    . /etc/os-release; \
    if [ "$ID" = "debian" ]; then \
        JELLYFIN_DIST="trixie"; \
    elif [ "$ID" = "ubuntu" ]; then \
        JELLYFIN_DIST="noble"; \
    fi; \
    if [ -n "$JELLYFIN_DIST" ]; then \
        JELLYFIN_VERSION="$(curl -fsSL https://api.github.com/repos/jellyfin/jellyfin-desktop/releases/latest | jq -r '.tag_name')"; \
        curl -fsSL -o /tmp/jellyfin.deb "https://github.com/jellyfin/jellyfin-desktop/releases/download/${JELLYFIN_VERSION}/jellyfin-media-player_${JELLYFIN_VERSION#v}-${JELLYFIN_DIST}.deb"; \
        apt-get install -y --no-install-recommends /tmp/jellyfin.deb; \
        rm -f /tmp/jellyfin.deb; \
    fi
    #
    # clean up
    #apt-get --purge autoremove -y xz-utils jq bzip2 file

#
# copy configuration files
RUN mkdir -p /etc/neko/supervisord
COPY supervisord.kde.conf /etc/neko/supervisord/kde.conf
RUN mv /etc/neko/supervisord.dbus.conf /etc/neko/supervisord/dbus.conf
COPY cleanup-locks.sh /usr/local/bin/cleanup-locks.sh
COPY supervisord.cleanup.conf /etc/neko/supervisord/cleanup.conf
RUN chmod +x /usr/local/bin/cleanup-locks.sh
