FROM blitznote/debootstrap-amd64:16.04

ENV STRDICT_VERSION 3.0.2

COPY stardict-tools-tabfile-fix-issue37.diff /tmp

WORKDIR /tmp
RUN grep '^# deb-src' /etc/apt/sources.list \
    | sed 's/^#//' > /etc/apt/sources.list.d/deb-src.list \
 && apt-get update && apt-get install -y --no-install-recommends \
    dpkg-dev \
    quilt \
    devscripts \
    fakeroot \
    grep \
    sed \
    curl \
    ruby2.3 \
    git \
    dictzip \
 && apt-get source -y stardict-tools \
 && apt-get build-dep -y stardict-tools \
 && (cd /tmp/stardict-tools-${STRDICT_VERSION} && \
      quilt import ../stardict-tools-tabfile-fix-issue37.diff && \
      quilt push -a && \
      debuild -us -uc -b -i ) \
 && dpkg -i ./*.deb \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/*

 WORKDIR /
