FROM python:slim-bullseye

ENV ASTERISK_VERSION 20-current
ENV OPUS_CODEC       asterisk-20.0/x86-64/codec_opus-20.0_current-x86_64

COPY build-prerequisities.sh /
RUN /build-prerequisities.sh

COPY build-asterisk.sh /
RUN /build-asterisk.sh

# Extensions watcher for debugging
COPY file_watch.py /
RUN pip install watchdog

EXPOSE 5060/udp 5060/tcp

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY run-asterisk.sh /
CMD ["./run-asterisk.sh"]