FROM ubuntu:latest
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install cron \
    git \
    curl \
    wget \
    vim \
    libnewt-dev \
    libssl-dev \
    libncurses5-dev \
    subversion \
    libsqlite3-dev \
    build-essential \
    libjansson-dev \
    libxml2-dev \
    uuid-dev \
    unixodbc \
    unixodbc-dev \
    odbc-postgresql \
    libedit-dev \
    libiksemel-dev \
    libvorbis-dev \
    libspeex-dev
RUN cd /usr/src \
  && git clone --depth 1 -b certified/16.8 https://github.com/asterisk/asterisk.git asterisk \
  && cd asterisk/ \
  && ./configure \
  && make menuselect/menuselect menuselect-tree menuselect.makeopts \
  && menuselect/menuselect \
    --enable chan_sip \
    --enable cdr_odbc \
    --enable res_odbc \
    --enable pbx_realtime \
    menuselect.makeopts \
make && make install && make samples && make config && ldconfig
COPY ./conf/odbc.ini /etc/odbc.ini
COPY ./conf/* /etc/asterisk/
# COPY ./conf/extensions.conf /etc/asterisk/extensions.conf
# COPY ./conf/http.conf /etc/asterisk/http.conf
# COPY ./conf/res_odbc.conf /etc/asterisk/res_odbc.conf
# COPY ./conf/sip.conf /etc/asterisk/sip.conf
RUN groupadd asterisk && \
useradd -r -d /var/lib/asterisk -g asterisk asterisk && \
usermod -aG audio,dialout asterisk && \
chown -R asterisk.asterisk /etc/asterisk && \
chown -R asterisk.asterisk /usr/lib/asterisk
RUN echo "pretty = yes" >> /etc/asterisk/ari.conf && \
echo "enabled = yes" >> /etc/asterisk/http.conf && \
echo "sippeers => odbc,asterisk,ast_sipfriends" >> /etc/asterisk/extconfig.conf && \
echo "extensions => odbc,asterisk,ast_extensions" >> /etc/asterisk/extconfig.conf

EXPOSE 5060/udp 8088 20000-30000/udp
ENTRYPOINT ["/bin/bash", "-c", "service asterisk start && tail -f /dev/null"]
