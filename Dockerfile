FROM alpine:3.17.2 AS base-image

# install packages wanted in the final image
RUN apk --no-cache add \
    bash \
    mariadb-client \
    mariadb-connector-c \
    perl \
    postgresql14-client \
    pv \
    zsh

# Set the time zone
ENV TZ="America/Los_Angeles"
RUN apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
    && apk del tzdata

FROM base-image AS sqitch-build

# Install Sqitch and dependencies
RUN apk --no-cache add \
    build-base \
    gcc \
    make \
    mariadb-dev \
    mariadb-connector-c-dev \
    perl-dev \
    perl-app-cpanminus \
    postgresql-dev \
    tar \
    wget

# Install extra CPAN modules
RUN cpanm -n \
    DBD::Pg \
    DBD::mysql \
    Template \
    Template::Plugin::Digest::MD5

# Install Sqitch
RUN cpanm -n DWHEELER/App-Sqitch-v1.3.1.tar.gz

FROM base-image
COPY --from=sqitch-build /usr/local/share/perl5 /usr/local/share/perl5
COPY --from=sqitch-build /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=sqitch-build /usr/local/bin/* /usr/local/bin/
COPY --from=sqitch-build /usr/local/etc/sqitch /usr/local/etc/sqitch
