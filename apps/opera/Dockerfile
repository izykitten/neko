# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

ARG API_URL="https://download5.operacdn.com/pub/opera/desktop/"


#
# install opera
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    #
    # fetch latest release
    VERSION="$(wget -O - "${API_URL}" 2>/dev/null | sed -n 's/.*href="\([^"/]*\).*/\1/p' | sort --version-sort | tail -1)"; \
    wget -O /tmp/opera.deb "${API_URL}${VERSION}/linux/opera-stable_${VERSION}_amd64.deb"; \
    apt-get install -y --no-install-recommends openbox curl jq unzip /tmp/opera.deb; \
    #
    # clean up
    apt-get --purge autoremove -y curl jq unzip; \
    apt-get clean -y

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/opera.conf
COPY openbox.xml /etc/neko/openbox.xml

