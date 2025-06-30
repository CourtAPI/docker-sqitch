FROM alpine:3.22.0 AS base-image

# install packages wanted in the final image
RUN apk --no-cache add \
    bash \
    mariadb-client \
    mariadb-connector-c \
    perl \
    postgresql15-client \
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
RUN cpanm -nv \
    DBD::Pg \
    DBD::mysql@4.052 \
    Pod::Find \
    Template \
    Template::Plugin::Digest::MD5

# Install Sqitch
RUN cpanm -n DWHEELER/App-Sqitch-v1.5.2.tar.gz

FROM base-image
COPY --from=sqitch-build /usr/local/share/perl5 /usr/local/share/perl5
COPY --from=sqitch-build /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=sqitch-build /usr/local/bin/* /usr/local/bin/
COPY --from=sqitch-build /usr/local/etc/sqitch /usr/local/etc/sqitch

# Pod::Find ets stored in /usr/share/perl5/core_perl, so pull all of that over as well.
COPY --from=sqitch-build /usr/share/perl5/core_perl /usr/share/perl5/core_perl
