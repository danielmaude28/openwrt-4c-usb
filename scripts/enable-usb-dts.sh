#!/usr/bin/env bash
set -euo pipefail

OPENWRT_DIR="${1:-openwrt}"
DTS="$OPENWRT_DIR/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4c.dts"

if [[ ! -f "$DTS" ]]; then
  echo "ERROR: DTS Xiaomi Mi Router 4C tidak ditemukan: $DTS" >&2
  find "$OPENWRT_DIR/target/linux/ramips/dts" -maxdepth 1 -type f -iname '*4c*.dts' -print >&2 || true
  exit 1
fi

echo "Memastikan controller EHCI dan OHCI aktif pada $DTS"
python3 - "$DTS" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text()
for name in ("ehci", "ohci"):
    pattern = re.compile(rf"(?m)(^[ \t]*&{name}[ \t]*\{{)(.*?)(^[ \t]*\}};)", re.S)
    matches = list(pattern.finditer(text))
    if len(matches) > 1:
        raise SystemExit(f"ERROR: ditemukan lebih dari satu blok &{name}")

    if matches:
        match = matches[0]
        body = match.group(2)
        if re.search(r'(?m)^\s*status\s*=', body):
            body = re.sub(r'(?m)^(\s*status\s*=\s*)"(?:okay|ok|disabled|fail)"\s*;',
                          r'\1"okay";', body)
        else:
            body += '\n\tstatus = "okay";\n'
        replacement = match.group(1) + body + match.group(3)
        text = text[:match.start()] + replacement + text[match.end():]
    else:
        text += f'\n&{name} {{\n\tstatus = "okay";\n}};\n'

    verify = re.search(rf"(?m)^\s*&{name}\s*\{{(.*?)^\s*\}};", text, re.S)
    if not verify or not re.search(r'(?m)^\s*status\s*=\s*"okay"\s*;', verify.group(1)):
        raise SystemExit(f"ERROR: gagal memastikan &{name} berstatus okay")

path.write_text(text)
print("EHCI=okay; OHCI=okay")
PY

# Fail-closed: kedua controller wajib terlihat aktif setelah perubahan.
for controller in ehci ohci; do
  if ! grep -A12 -E "^[[:space:]]*&${controller}[[:space:]]*\\{" "$DTS" | grep -q 'status = "okay";'; then
    echo "ERROR: controller $controller tidak terbukti aktif" >&2
    exit 1
  fi
done

echo "Patch DTS USB berhasil diverifikasi."
