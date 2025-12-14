# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

# install remmina
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  set -eux; \
  apt-get update; \
    apt-get install -y --no-install-recommends \
      remmina-plugin-rdp remmina-plugin-vnc \
      remmina-plugin-x2go remmina-plugin-www; \
    # clean up
    apt-get clean -y

# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/remmina.conf
COPY --chown=neko remmina.pref /home/neko/.config/remmina/remmina.pref
COPY --chown=neko rdp.remmina spice.remmina vnc.remmina /home/neko/.local/share/remmina/
COPY run-remmina.sh /usr/bin/run-remmina.sh
ENV REMMINA_URL=
ENV REMMINA_PROFILE=
