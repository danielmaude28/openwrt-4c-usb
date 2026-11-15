#!/usr/bin/env bash
set -euo pipefail

OPENWRT_DIR="${1:-openwrt}"
DTS="$OPENWRT_DIR/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4c.dts"

if [[ ! -f "$DTS" ]]; then
  echo "ERROR: DTS Xiaomi Mi Router 4C tidak ditemukan: $DTS" >&2
  echo "DTS kandidat yang tersedia:" >&2
  find "$OPENWRT_DIR/target/linux/ramips/dts" -maxdepth 1 -type f -iname '*4c*.dts' -print >&2 || true
  exit 1
fi

echo "Status USB sebelum perubahan:"
grep -n -B1 -A3 -E '&(ehci|ohci)' "$DTS" || echo "(belum ada blok ehci/ohci)"

for controller in ehci ohci; do
  if grep -q "&$controller" "$DTS"; then
    sed -i "/&$controller {/,/};/ s/status = \"disabled\"/status = \"okay\"/" "$DTS"
  else
    printf '\n&%s {\n\tstatus = "okay";\n};\n' "$controller" >> "$DTS"
  fi
done

echo "Status USB setelah perubahan:"
grep -n -B1 -A3 -E '&(ehci|ohci)' "$DTS"
