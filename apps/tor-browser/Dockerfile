# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

#
# install dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked --mount=type=tmpfs,target=/var/lib/dpkg \
    set -eux; \
    rm -f /var/lib/apt/lists/lock /var/lib/apt/lists/partial/lock; \
    apt-get update; \
    apt-get install -y --no-install-recommends openbox curl xz-utils file libgtk-3-0t64 libdbus-glib-1-2; \
    #
    # download TOR browser
    DOWNLOAD_URI="$(curl -s -N https://www.torproject.org/download/ | grep -Po -m 1 '(?=(dist/torbrowser)).*(?<=.tar.xz)')"; \
	echo "Downloading $DOWNLOAD_URI"; \
	curl -sSL -o /tmp/tor.tar.xz "https://www.torproject.org/$DOWNLOAD_URI"; \
    tar -xvJf /tmp/tor.tar.xz -C /opt; \
    mv /opt/tor-browser* /opt/tor-browser_en-US; \
    chown -R neko:neko /opt/tor-browser_en-US/; \
    rm -f /tmp/tor.tar.xz; \
    #
    # clean up
    apt-get --purge autoremove -y curl xz-utils; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*;

#
# copy configuation file
COPY supervisord.conf /etc/neko/supervisord/tor-browser.conf
COPY openbox.xml /etc/neko/openbox.xml
