# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

#
# install vlc
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends openbox vlc; \
    #
    # clean up
    apt-get clean -y

ENV VLC_MEDIA="/media"

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/vlc.conf
COPY openbox.xml /etc/neko/openbox.xml
