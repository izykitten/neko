# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest
FROM $BASE_IMAGE

#
# install kde
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked --mount=type=tmpfs,target=/var/lib/dpkg \
    set -eux; \
    rm -f /var/lib/apt/lists/lock /var/lib/apt/lists/partial/lock; \
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

#
# copy configuation files
COPY supervisord.conf /etc/neko/supervisord/kde.conf

