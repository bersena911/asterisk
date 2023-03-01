FROM python:slim-bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install unzip git gnupg2 curl libnewt-dev libssl-dev libncurses5-dev subversion libsqlite3-dev build-essential libjansson-dev libxml2-dev uuid-dev subversion -y

WORKDIR /app
RUN curl -sL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz | tar --strip-components 1 -xz
RUN contrib/scripts/get_mp3_source.sh
RUN contrib/scripts/install_prereq install
RUN ./configure

RUN make menuselect/menuselect menuselect-tree menuselect.makeopts

RUN menuselect/menuselect --enable chan_mobile --enable chan_ooh323 --enable format_mp3 menuselect.makeopts

RUN menuselect/menuselect --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-ULAW --enable CORE-SOUNDS-EN-ALAW menuselect.makeopts
RUN menuselect/menuselect --enable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-EN-G729 --enable CORE-SOUNDS-EN-G722 menuselect.makeopts
RUN menuselect/menuselect --enable CORE-SOUNDS-EN-SLN16 --enable CORE-SOUNDS-EN-SIREN7 menuselect.makeopts

RUN menuselect/menuselect --enable MOH-OPSOUND-ULAW --enable MOH-OPSOUND-ALAW --enable MOH-OPSOUND-GSM menuselect.makeopts

RUN menuselect/menuselect --enable EXTRA-SOUNDS-EN-WAV --enable EXTRA-SOUNDS-EN-ULAW --enable EXTRA-SOUNDS-EN-ALAW menuselect.makeopts
RUN menuselect/menuselect --enable EXTRA-SOUNDS-EN-GSM --enable EXTRA-SOUNDS-EN-G729 --enable EXTRA-SOUNDS-EN-G722 menuselect.makeopts
RUN menuselect/menuselect --enable EXTRA-SOUNDS-EN-SLN16 --enable EXTRA-SOUNDS-EN-SIREN7 menuselect.makeopts

RUN make -j2
RUN make install
RUN make samples
RUN make config
RUN ldconfig

# Extensions watcher for debugging
COPY file_watch.py /app
RUN pip install watchdog

COPY run-asterisk.sh /app
CMD ["./run-asterisk.sh"]