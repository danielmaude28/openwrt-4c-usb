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

require_config CONFIG_TARGET_ramips
require_config CONFIG_TARGET_ramips_mt76x8
require_config CONFIG_TARGET_ramips_mt76x8_DEVICE_xiaomi_mi-router-4c

for package in kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-usb-storage sqm-scripts luci kmod-tun zerotier; do
  require_config "CONFIG_PACKAGE_$package"
done

for package in luci-app-sqm luci-app-ttyd luci-app-nlbwmon iftop conntrack htop nano curl usbutils block-mount kmod-fs-ext4 kmod-fs-vfat blkid kmod-sched-cake; do
  if ! grep -qx "CONFIG_PACKAGE_$package=y" "$CONFIG_FILE"; then
    echo "WARNING: paket opsional tidak terpilih: $package"
  fi
done

echo "Konfigurasi target dan paket wajib valid."
