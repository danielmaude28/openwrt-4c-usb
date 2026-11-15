#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:-openwrt/.config}"
[[ -f "$CONFIG_FILE" ]] || { echo "ERROR: konfigurasi tidak ditemukan: $CONFIG_FILE" >&2; exit 1; }

require_config() {
  local option="$1"
  if ! grep -qx "$option=y" "$CONFIG_FILE"; then
    echo "ERROR: konfigurasi wajib tidak aktif: $option" >&2
    exit 1
  fi
}

# Target harus tetap tepat untuk Xiaomi Mi Router 4C.
require_config CONFIG_TARGET_ramips
require_config CONFIG_TARGET_ramips_mt76x8
require_config CONFIG_TARGET_ramips_mt76x8_DEVICE_xiaomi_mi-router-4c

# Semua fitur yang sudah ada dan fitur baru merupakan persyaratan build.
required_packages=(
  luci luci-app-sqm sqm-scripts kmod-sched-cake
  luci-app-ttyd luci-app-nlbwmon iftop conntrack htop nano curl
  usbutils block-mount blkid
  kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-storage kmod-usb-storage-uas
  kmod-fs-ext4 kmod-fs-vfat kmod-fs-exfat exfat-fsck exfat-mkfs
  kmod-tun zerotier
  ddns-scripts ddns-scripts-services luci-app-ddns
  adblock luci-app-adblock
)

for package in "${required_packages[@]}"; do
  require_config "CONFIG_PACKAGE_$package"
done

echo "Konfigurasi Xiaomi Mi Router 4C dan seluruh paket wajib valid."
