# Angkou-Vps 轻量版

`akvps` 是在单台 VPS 内运行的中文初始设置工具。第一版只做一件事：把当前 VPS 准备成可接入主 3x-ui 的远端节点端。

## 安装

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/main/install.sh)
```

安装后会自动打开中文菜单。以后输入：

```bash
akvps
```

## 本地检查

```bash
./scripts/check.sh
```

## 第一版范围

- 完整实现：初始设置。
- 占位菜单：状态检查、接入信息、修复工具、设置 / 更新 / 卸载。
- 支持系统：Debian 11/12/13，Ubuntu 22.04/24.04。
- 不做本地总控、不做多 VPS 台账、不做 Komari、不做 Halo、不做成本统计。

## 初始设置做什么

- 保存主控 IPv4 和 Cloudflare Token 到 VPS 本机。
- 生成 `节点短名.kouzho.cc`。
- 配置 Termius 统一 SSH 公钥并禁用密码登录。
- 按内存判断是否创建 Swap。
- 安装必要工具并设置上海时区。
- 默认启用智能调优，也可选择基础调优。
- 配置 UFW。
- Cloudflare DNS 小灰云：有 IPv4 建 A，有 IPv6 建 AAAA。
- 用 3x-ui 官方非交互脚本安装或重设远端节点端。
- 生成本机接入报告。

## 固定端口

- 3x-ui 被控端面板：`11123/tcp`，只允许主控 IPv4 访问。
- VLESS Reality：`11789/tcp`。
- Hysteria2：`11799/udp`。
- Hysteria2 端口跳跃：`39999-59999/udp`。

## 本机文件

- 配置：`/etc/akvps/config.env`
- 敏感信息：`/etc/akvps/secrets.env`
- 报告：`/var/lib/akvps/reports/`

## 注意

第一版面向新 VPS 或可覆盖配置的 VPS。重复运行初始设置会刷新 3x-ui 被控端用户名、密码、WebBasePath 和 API Token，但保留已有 3x-ui 数据库、入站和客户端。

## 真实 VPS 测试前准备

- 一台 Debian 12 或 Ubuntu 24.04 新 VPS。
- 主控 3x-ui 的 IPv4。
- Cloudflare Token，权限包含 `Zone Read` 和 `DNS Edit`，作用范围为 `kouzho.cc`。
- 节点短名，例如 `jp1`。
- 本地到 VPS 的大概 ping 延迟。
