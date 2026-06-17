#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")/.."

echo "检查 Bash 语法..."
bash -n install.sh
bash -n akvps

if command -v shellcheck >/dev/null 2>&1; then
  echo "运行 ShellCheck..."
  shellcheck install.sh akvps
else
  echo "未安装 ShellCheck，跳过。"
fi

echo "检查版本命令..."
bash akvps --version >/dev/null

echo "检查完成。"
