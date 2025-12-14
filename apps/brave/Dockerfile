# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends apt-transport-https curl openbox; \
    #
    # install brave browser
    ARCH=$(dpkg --print-architecture); \
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=${ARCH}] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | tee /etc/apt/sources.list.d/brave-browser-release.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends brave-browser; \
    #
    # clean up
    apt-get clean -y

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/brave.conf
COPY --chown=neko preferences.json /home/neko/.config/brave/Default/Preferences
COPY policies.json /etc/brave/policies/managed/policies.json
COPY openbox.xml /etc/neko/openbox.xml
