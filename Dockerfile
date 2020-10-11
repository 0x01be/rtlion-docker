FROM 0x01be/rtlion:build as build

FROM alpine

RUN apk add --no-cache --virtual rtlion-runtime-dependecies \
    python3 \
    py3-matplotlib \
    py3-scipy \
    eudev \
    libusb

COPY --from=build /opt/ /opt/

RUN adduser -D -u 1000 rtlion

ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/rtlion/lib/python3.8/site-packages/
ENV PATH ${PATH}:/opt/librtlsrd/bin/:/opt/rtlion/bin/
ENV LD_LIBRARY_PATH /usr/lib/:/opt/librtlsdr/lib/

USER rtlion

WORKDIR /opt/rtlion/bin/

CMD ["python3", "RTLion.py"]

