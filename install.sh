#!/usr/bin/env bash
set -Eeuo pipefail

AKVPS_REPO_RAW="${AKVPS_REPO_RAW:-https://raw.githubusercontent.com/AngKouChan/akvps/main}"
AKVPS_BIN="/usr/local/bin/akvps"

need_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "请在 VPS 上用 root 运行安装命令。"
    exit 1
  fi
}

install_akvps() {
  if [[ -f "./akvps" ]]; then
    install -m 0755 "./akvps" "$AKVPS_BIN"
  else
    tmp_file="$(mktemp)"
    curl -fsSL "$AKVPS_REPO_RAW/akvps" -o "$tmp_file"
    install -m 0755 "$tmp_file" "$AKVPS_BIN"
    rm -f "$tmp_file"
  fi
}

main() {
  need_root
  command -v curl >/dev/null 2>&1 || {
    echo "缺少 curl，请先安装 curl。Debian/Ubuntu 可执行：apt update && apt install -y curl"
    exit 1
  }
  install_akvps
  echo "akvps 已安装：$AKVPS_BIN"
  echo "正在打开中文菜单..."
  exec "$AKVPS_BIN"
}

main "$@"
