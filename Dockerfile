FROM debian:latest

WORKDIR /openwrt
COPY . /openwrt

RUN apt update && apt upgrade -y && apt install -y sudo git build-essential clang flex bison g++ gawk \
            gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
            python3-setuptools rsync swig unzip zlib1g-dev file wget curl

RUN adduser -u 5678 --disabled-password --gecos "" openwrt && chown -R openwrt /openwrt && cd /openwrt
USER openwrt

RUN git clone -b be14-and-hostapd-janusz-v3 https://github.com/danpawlik/openwrt

RUN cd openwrt && ./scripts/feeds update -a && ./scripts/feeds install -a

RUN curl -SL https://raw.githubusercontent.com/danpawlik/openwrt-builder/master/configs/mediatek/mt7988a/bpi-r4 > .config && \
          curl -SL https://raw.githubusercontent.com/wrcrooks/bpi-r4-openwrt-builder/main/configs/common/luci >> .config && \
          curl -SL https://raw.githubusercontent.com/wrcrooks/bpi-r4-openwrt-builder/main/configs/common/misc >> .config && \
          curl -SL https://raw.githubusercontent.com/danpawlik/openwrt-builder/master/configs/common/snapshot-short >> .config

RUN echo "CONFIG_PACKAGE_fail2ban=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-mhi-net=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-mhi-wwan-ctrl=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-acm=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-dwc3=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-net-rndis=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-cdns3=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-mhi-wwan-mbim=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-serial-qualcomm=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-serial-option=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-mtk-t7xx=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-usb-net-cdc-eem=y" >> .config && \
          echo "CONFIG_PACKAGE_kmod-wireguard=y" >> .config && \
          echo "CONFIG_PACKAGE_wireguard-tools=y" >> .config && \
          echo "CONFIG_PACKAGE_luci-proto-wireguard=y" >> .config && \
          echo "CONFIG_PACKAGE_qrencode=y" >> .config

