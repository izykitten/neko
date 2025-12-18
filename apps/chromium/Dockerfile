# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

COPY ./widevinecdm.sh /widevine.sh

#
# install neko chromium
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    . /etc/os-release && \
    if [ "$ID" = "debian" ]; then \
        echo "deb http://deb.debian.org/debian ${VERSION_CODENAME} main" >> /etc/apt/sources.list && \
        apt-get update && \
        apt-get install -y --no-install-recommends chromium chromium-common chromium-sandbox; \
    elif [ "$ID" = "ubuntu" ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends chromium-browser openbox || apt-get install -y --no-install-recommends chromium openbox; \
    else \
        apt-get update && \
        apt-get install -y --no-install-recommends chromium chromium-common chromium-sandbox; \
    fi && \
    apt-get --purge autoremove -y xz-utils

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/chromium.conf
COPY --chown=neko preferences.json /home/neko/.config/chromium/Default/Preferences
COPY policies.json /etc/chromium/policies/managed/policies.json
COPY openbox.xml /etc/neko/openbox.xml
