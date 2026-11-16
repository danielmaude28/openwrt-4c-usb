#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/openwrt/target/linux/ramips/dts"
DTS="$TMP/openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4c.dts"
cat > "$DTS" <<'EOF'
/dts-v1/;
&ehci {
        status = "disabled";
};
EOF

bash "$ROOT/scripts/enable-usb-dts.sh" "$TMP/openwrt"
grep -A12 '&ehci {' "$DTS" | grep -q 'status = "okay";'
grep -A12 '&ohci {' "$DTS" | grep -q 'status = "okay";'

# Kedua blok sudah ada tetapi tanpa status: script harus menambahkan status.
cat > "$DTS" <<'EOF'
/dts-v1/;
&ehci {
        phy-mode = "usb";
};
&ohci {
        num-ports = <1>;
};
EOF
bash "$ROOT/scripts/enable-usb-dts.sh" "$TMP/openwrt"
grep -A12 '&ehci {' "$DTS" | grep -q 'status = "okay";'
grep -A12 '&ohci {' "$DTS" | grep -q 'status = "okay";'

# DTS hilang harus gagal, bukan diam-diam meneruskan build.
rm -f "$DTS"
if bash "$ROOT/scripts/enable-usb-dts.sh" "$TMP/openwrt" >/dev/null 2>&1; then
  echo "ERROR: script seharusnya gagal saat DTS tidak ditemukan" >&2
  exit 1
fi

echo "Tes DTS USB lulus."
