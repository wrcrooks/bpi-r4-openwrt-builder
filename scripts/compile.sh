#!/bin/bash
./scripts/feeds update -a
./scripts/feeds install -a

curl -SL https://raw.githubusercontent.com/danpawlik/openwrt-builder/master/configs/mediatek/mt7988a/bpi-r4 > ../openwrt/.config
curl -SL https://raw.githubusercontent.com/wrcrooks/bpi-r4-openwrt-builder/main/configs/common/luci >> ../openwrt/.config
curl -SL https://raw.githubusercontent.com/wrcrooks/bpi-r4-openwrt-builder/main/configs/common/misc >> ../openwrt/.config
curl -SL https://raw.githubusercontent.com/danpawlik/openwrt-builder/master/configs/common/snapshot-short >> ../openwrt/.config

echo "CONFIG_PACKAGE_fail2ban=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-mhi-net=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-mhi-wwan-ctrl=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-acm=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-dwc3=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-net-rndis=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-cdns3=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-mhi-wwan-mbim=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-serial-qualcomm=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-serial-option=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-mtk-t7xx=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-usb-net-cdc-eem=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_kmod-wireguard=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_wireguard-tools=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_luci-proto-wireguard=y" >> ../openwrt/.config
echo "CONFIG_PACKAGE_qrencode=y" >> ../openwrt/.config

make defconfig

grep "=m" ../openwrt/.config | grep -v 'CONFIG_PACKAGE_libustream-mbedtls=m' | while read -r line; do module=$(echo "$line" | cut -f1 -d'='); sed -i "s/^$line$/# $module is not set/" ../openwrt/.config; done

make -j $(nproc) download
make -j $(nproc) world

#tar caf ../openwrt/bin/targets/mediatek/filogic/packages.tar.gz ../openwrt/bin/targets/mediatek/filogic/packages
#tar -cvf ../openwrt/bpi_r4-images.tar ../openwrt/bin/targets/mediatek/filogic

