FROM alpine:3.9

# install packages wanted in the final image
RUN apk --no-cache add \
    bash \
    mariadb-client \
    mariadb-connector-c-dev \
    perl \
    postgresql-client \
    postgresql-libs \
    pv

# Set the time zone
ENV TZ="America/Los_Angeles"
RUN apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
    && apk del tzdata

# Install Sqitch and dependencies
RUN apk --no-cache --virtual .build-deps add \
    build-base \
    gcc \
    make \
    mariadb-dev \
    perl-dev \
    postgresql-dev \
    tar \
    wget \
  && wget -O cpanm https://cpanmin.us \
  && chmod +x cpanm \
  && ./cpanm -n DBD::Pg DBD::mysql Template DWHEELER/App-Sqitch-0.9997.tar.gz \
  && rm -rf cpanm $HOME/.cpanm \
  && find /usr/local/share/man -type f -delete \
  && apk del .build-deps
