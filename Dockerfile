FROM arm32v6/alpine

RUN apk add --no-cache --virtual rtlion-build-dependecies \
    git \
    build-base \
    cmake \
    python3-dev \
    py3-pip \
    py3-matplotlib \
    py3-scipy \
    eudev-dev

ENV RTLION_REVISION master
RUN git clone --depth 1 --branch ${RTLION_REVISION} https://github.com/RTLion-Framework/RTLion /rtlion

ENV LIBRTLSRD_REVISION master
RUN git clone --depth 1 --branch ${LIBRTLSRD_REVISION} https://github.com/radiowitness/librtlsdr.git /librtlsdr

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN apk add libusb-dev
WORKDIR /librtlsdr/build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/librtlsdr \
    -DINSTALL_UDEV_RULES=ON \
    -DDETACH_KERNEL_DRIVER=ON \
    ..
RUN make
RUN make install

WORKDIR /rtlion

RUN pip install --prefix /opt/rtlion \
    pyrtlsdr \
    flask-socketio~=3.2.2 \
    peakutils

