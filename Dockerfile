FROM alpine:3.10
LABEL maintainer="Karl Fathi <karl@pixelfordinner.com>"

ENV LANG C.UTF-8

ARG DUPLICITY_VERSION=0.8.01

RUN addgroup -S duplicity && \
    mkdir -p /mnt/app && \
    adduser -D -S -u 1896 -h /mnt/app -s /sbin/nologin -G duplicity duplicity

RUN apk add --no-cache \
    su-exec \
    ca-certificates \
    dbus \
    gnupg \
    krb5-libs \
    lftp \
    libffi \
    librsync \
    ncftp \
    openssh \
    openssl \
    py2-gobject3 \
    tzdata \
    py-pip \
    && sync \
    && pip install --upgrade pip

RUN apk add --no-cache --virtual .build \
        build-base \
        krb5-dev \
        libffi-dev \
        librsync-dev \
        linux-headers \
        openssl-dev \
        python-dev \
    && pip install --no-cache-dir  \
        azure-storage \
        b2 \
        boto \
        dropbox \
        gdata \
        lockfile \
        mediafire \
        mega.py \
        paramiko \
        pexpect \
        pycryptopp \
        PyDrive \
        pykerberos \
        pyrax \
        python-keystoneclient \
        python-swiftclient \
        PyNaCl==1.2.1 \
        requests \
        requests-oauthlib \
        urllib3 \
        https://code.launchpad.net/duplicity/$(echo $DUPLICITY_VERSION | sed -r 's/^([0-9]+\.[0-9]+)([0-9\.]*)$/\1/')-series/$DUPLICITY_VERSION/+download/duplicity-$DUPLICITY_VERSION.tar.gz \
    && apk del .build

RUN apk del --purge py-pip

ADD ./data/bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

ENV HOME=/mnt/app

ENTRYPOINT ["entrypoint"]
