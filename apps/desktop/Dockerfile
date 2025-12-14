# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

#
# install kde and all browsers/apps
SHELL ["/bin/bash", "-c"]
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/lib/dpkg \
    set -eux; \
    rm -f /var/lib/apt/lists/lock /var/lib/apt/lists/partial/lock; \
    apt-get update; \
    ARCH=$(dpkg --print-architecture); \
    #
    # install KDE and base dependencies
    apt-get install -y --no-install-recommends \
        kde-full kwin-x11 sudo \
        wget curl xz-utils jq unzip bzip2 file \
        apt-transport-https \
        libgtk-3-0t64 libdbus-glib-1-2 \
        libatk1.0-0 libatk-bridge2.0-0 libatomic1 \
        libcups2 libnss3 libpci3 libxcomposite1 libxss1; \
    #
    # add user to sudoers
    usermod -aG sudo neko; \
    echo "neko:neko" | chpasswd; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    apt remove xserver-xorg-legacy -y; \
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
        mkdir -p /usr/lib/firefox/distribution/extensions; \
        wget -O '/usr/lib/firefox/distribution/extensions/uBlock0@raymondhill.net.xpi' \
            https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi; \
        wget -O '/usr/lib/firefox/distribution/extensions/sponsorBlocker@ajay.app.xpi' \
            https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi; \
    fi; \
    #
    # install Chromium
    echo "deb http://ftp.de.debian.org/debian bookworm main" >> /etc/apt/sources.list; \
    rm -f /var/lib/apt/lists/lock /var/lib/apt/lists/partial/lock; \
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
    rm -f /var/lib/apt/lists/lock /var/lib/apt/lists/partial/lock; \
    apt-get update; \
    apt-get install -y --no-install-recommends brave-browser; \
    #
    # install Microsoft Edge
    API_URL="https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/"; \
    SRC_URL="${API_URL}$(wget -O - "${API_URL}" 2>/dev/null | sed -n 's/.*href="\([^"]*\).*/\1/p' | sort --version-sort | tail -1)"; \
    wget -O /tmp/microsoft-edge.deb "${SRC_URL}"; \
    apt-get install -y --no-install-recommends /tmp/microsoft-edge.deb; \
    rm -f /tmp/microsoft-edge.deb; \
    #
    # install Opera
    API_URL="https://download5.operacdn.com/pub/opera/desktop/"; \
    VERSIONS="$(wget -O - "${API_URL}" 2>/dev/null | sed -n 's/.*href="\([^"/]*\).*/\1/p' | sort --version-sort -r | head -n 10)"; \
    VERSION=""; \
    for v in $VERSIONS; do \
        if wget --spider "${API_URL}${v}/linux/opera-stable_${v}_amd64.deb" 2>/dev/null; then \
            VERSION="$v"; \
            break; \
        fi; \
    done; \
    if [ ! -z "$VERSION" ]; then \
        wget -O /tmp/opera.deb "${API_URL}${VERSION}/linux/opera-stable_${VERSION}_amd64.deb"; \
        apt-get install -y --no-install-recommends /tmp/opera.deb; \
        rm -f /tmp/opera.deb; \
    fi; \
    #
    # install Vivaldi
    wget -O /tmp/vivaldi.deb "https://downloads.vivaldi.com/stable/vivaldi-stable_${ARCH}.deb"; \
    apt install -y --no-install-recommends /tmp/vivaldi.deb; \
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
    CHROMIUM_VERSION="$(wget -O - "${API_URL}" 2>/dev/null | jq -r ".tag_name" | sed -e 's/v//' -e 's/-.*//')"; \
    EXTENSIONS_DIR="/usr/share/chromium/extensions"; \
    EXTENSIONS=( \
      cjpalhdlnbpafiamejdnhcphjbkeiagm \
      mnjggcdmjocbbbhaepdhchncahnbgone \
    ); \
    mkdir -p "${EXTENSIONS_DIR}"; \
    for EXT_ID in "${EXTENSIONS[@]}"; do \
      EXT_URL="https://clients2.google.com/service/update2/crx?response=redirect&nacl_arch=x86-64&prodversion=${CHROMIUM_VERSION}&acceptformat=crx2,crx3&x=id%3D${EXT_ID}%26installsource%3Dondemand%26uc"; \
      EXT_PATH="${EXTENSIONS_DIR}/${EXT_ID}.crx"; \
      wget -O "${EXT_PATH}" "${EXT_URL}"; \
      EXT_VERSION="$(unzip -p "${EXT_PATH}" manifest.json 2>/dev/null | jq -r ".version")"; \
      echo -e "{\n  \"external_crx\": \"${EXT_PATH}\",\n  \"external_version\": \"${EXT_VERSION}\"\n}" > "${EXTENSIONS_DIR}"/"${EXT_ID}".json; \
    done; \
    #
    # clean up
    apt-get --purge autoremove -y xz-utils jq bzip2 file; \
    rm -rf /var/lib/apt/lists/*

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/kde.conf
RUN cp -a /etc/neko/supervisord.dbus.conf /etc/neko/supervisord/dbus.conf
