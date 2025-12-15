# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/izykitten/neko/systemd-base:latest
FROM $BASE_IMAGE

#
# install browsers and tools
SHELL ["/bin/bash", "-c"]

#
# install kde
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends kde-full kwin-x11 sudo; \
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
        wget -O /tmp/firefox-setup.tar.xz "${SRC_URL}"; \
        tar -xJf /tmp/firefox-setup.tar.xz -C /tmp; \
        mv /tmp/firefox /usr/lib/firefox; \
        rm -f /tmp/firefox-setup.tar.xz; \
        ln -s /usr/lib/firefox/firefox /usr/bin/firefox; \
    fi; \
    #
    # install Chromium
    echo "deb http://ftp.de.debian.org/debian trixie main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends chromium chromium-common chromium-sandbox; \
    #
    # install Google Chrome
    wget -O /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"; \
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
    curl -fsSLo /usr/share/keyrings/microsoft-edge-keyring.gpg \
        https://packages.microsoft.com/keys/microsoft.asc; \
    echo "deb [signed-by=/usr/share/keyrings/microsoft-edge-keyring.gpg arch=${ARCH}] https://packages.microsoft.com/repos/edge stable main" \
        | tee /etc/apt/sources.list.d/microsoft-edge-dev.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends microsoft-edge-stable; \
    #
    # install Opera
    curl -fsSLo /usr/share/keyrings/opera-archive-keyring.gpg \
        https://deb.opera.com/archive.key; \
    echo "deb [signed-by=/usr/share/keyrings/opera-archive-keyring.gpg] https://deb.opera.com/opera stable non-free" \
        | tee /etc/apt/sources.list.d/opera.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends opera-stable; \
    #
    # install Vivaldi
    wget -O /tmp/vivaldi.deb "https://downloads.vivaldi.com/stable/vivaldi-stable_${ARCH}.deb"; \
    apt-get install -y --no-install-recommends /tmp/vivaldi.deb; \
    rm -f /tmp/vivaldi.deb; \
    #
    # install VLC
    apt-get install -y --no-install-recommends vlc; \
    #
    # install Remmina with RDP and VNC support only
    apt-get install -y --no-install-recommends remmina remmina-plugin-rdp remmina-plugin-vnc; \
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
    SRC_URL="$(wget -O - "${API_URL}" 2>/dev/null | jq -r "[.assets[] | select(.browser_download_url | contains(\"tar.xz\"))][-1] | .browser_download_url")"; \
    wget -O /tmp/chromium.tar.xz "${SRC_URL}"; \
    tar -xJf /tmp/chromium.tar.xz -C /tmp; \
    rm -f /usr/lib/ungoogled-chromium; \
    mv /tmp/ungoogled-chromium_* /usr/lib/ungoogled-chromium; \
    mv /usr/lib/ungoogled-chromium/chrome_sandbox /usr/lib/ungoogled-chromium/chrome-sandbox; \
    chown root:root /usr/lib/ungoogled-chromium/chrome-sandbox; \
    chmod 4755 /usr/lib/ungoogled-chromium/chrome-sandbox; \
    rm -f /tmp/chromium.tar.xz; \
    #
    # clean up (keep apt cache for BuildKit)
    apt-get --purge autoremove -y xz-utils jq bzip2 file; \
    apt-get clean

#
# copy configuration files
RUN mv /etc/neko/supervisord.dbus.conf /etc/neko/supervisord/dbus.conf
COPY cleanup-locks.sh /usr/local/bin/cleanup-locks.sh
RUN chmod +x /usr/local/bin/cleanup-locks.sh
COPY supervisord.conf /etc/neko/supervisord/kde.conf
COPY supervisord.cleanup.conf /etc/neko/supervisord/cleanup.conf
