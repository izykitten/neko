# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

ARG SRC_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

#
# install google chrome
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    wget -O /tmp/google-chrome.deb "${SRC_URL}"; \
    apt-get install -y --no-install-recommends openbox /tmp/google-chrome.deb; \
    #
    # clean up
    apt-get clean -y

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/google-chrome.conf
COPY --chown=neko preferences.json /home/neko/.config/google-chrome/Default/Preferences
COPY policies.json /etc/opt/chrome/policies/managed/policies.json
COPY openbox.xml /etc/neko/openbox.xml
