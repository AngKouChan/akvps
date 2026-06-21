# Angkou-Vps 轻量版

`akvps` 是在单台 VPS 内运行的中文 VPS 部署与维护工具。第一版重点做：代理节点、探针 Agent、3x-ui 主控面板、Komari 探针主站。

主控面板和探针主站是两个独立角色，可以部署在同一台 VPS，也可以部署在不同 VPS。

## 安装

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/main/install.sh)
```

安装后会自动打开中文菜单。以后输入：

```bash
akvps
```

菜单会逐级返回：二级菜单里的功能执行完，会留在当前二级菜单；只有选择 `0. 返回` 才回到上一级。

进入菜单后会先显示本机状态，包括基础信息、主控面板、代理节点、探针 Agent、探针主站是否已配置或正在运行；本机角色只显示本机实际部署过的角色，并支持彩色显示。

## 本地检查

```bash
./scripts/check.sh
```

## 第一版范围

- 完整实现：基础设置、本机部署、日常维护、更新卸载。
- 支持系统：Debian 11/12/13，Ubuntu 22.04/24.04。
- 不做本地总控、不做多 VPS 台账、不做 Halo、不做成本统计。

## 菜单

```text
1. 调优开荒

2. 开始部署
   1. 代理节点
   2. 3x-ui 主控
   3. 探针站
   0. 返回

3. 基础设置
   1. 一键导入
   2. 基础信息
   3. 主控信息
   4. 探针信息
   5. 查看信息
   0. 返回

4. 本机部署
   1. 代理节点
   2. 探针部署
   3. 设为主控机
   4. 设为探针站
   0. 返回

5. 日常维护
   1. 接入主控
   2. 验证接入
   3. 验证探针
   4. 恢复密码登录
   0. 返回

6. 更新卸载
   1. 更新脚本
   2. 更新 3x-ui
   3. 更新 Komari 探针
   4. 清除所有设定
   5. 卸载脚本
   6. 完整清除本机环境（危险）
   7. 查看版本
   0. 返回
```

## 调优开荒做什么

- 安装必要工具并设置上海时区。
- 按内存判断是否创建 Swap。
- 可选择稳妥调优、进阶网络调优、基础调优或 BBRv3。
- BBRv3 使用 Eric86777/vps-tcp-tune；首次会先安装内核并暂停，重启 VPS 后再继续。
- 可选是否禁用 IPv6，默认保留 IPv6。
- 调优完成后会记录状态，后续部署节点、主控或探针站时不会覆盖这部分网络参数。

## 基础设置做什么

- `一键导入`：一次性粘贴通用信息和节点预填信息，例如根域名、Cloudflare Token、主控信息、节点短名、节点协议、延迟、Komari 主站地址、自动发现密钥和月重置日。
- `基础信息`：粘贴导入主控 IPv4、主控 IPv6、Cloudflare Token、根域名。
- `主控信息`：粘贴导入 3x-ui 主控域名、面板完整地址、API Token。
- `探针信息`：粘贴导入 Komari 主站域名和主站地址。
- `查看信息`：查看当前配置、远端节点接入信息、面板卡片、探针卡片、主站卡片；Token 默认遮挡。
- 敏感信息保存到 `/etc/akvps/secrets.env`，不上传 GitHub。

一键导入示例：

```env
AKVPS_ROOT_DOMAIN=kouzho.cc
CLOUDFLARE_TOKEN=你的 Cloudflare Token
MASTER_IPV4=主控 IPv4
MASTER_IPV6=
PANEL_DOMAIN=x.kouzho.cc
PANEL_URL=https://x.kouzho.cc/随机路径
PANEL_API_TOKEN=主控 API Token
NODE_NAME=jp1
NODE_PROTOCOLS=vless / hy2端口跳跃
RTT_MS=180
VPS_MBPS=1000
KOMARI_ENDPOINT=https://status.kouzho.cc
KOMARI_AUTO_DISCOVERY_KEY=Komari 自动发现密钥
KOMARI_MONTH_ROTATE=
END
```

`PANEL_URL` 建议填写到随机路径为止，不需要带 `/panel`；如果从浏览器地址栏复制了 `/panel`，akvps 会自动去掉再调用 API。

## 节点部署做什么

- 保存主控 IPv4 和 Cloudflare Token 到 VPS 本机。
- 生成 `节点短名.kouzho.cc`。
- 如果已完成调优开荒，会跳过调优，不覆盖前面的网络参数。
- 如果未完成调优开荒，会提示先执行；也可以跳过后继续部署。
- 配置 Termius 统一 SSH 公钥并禁用密码登录。
- 安装必要工具并设置上海时区。
- 配置 UFW。
- Cloudflare DNS 小灰云：有 IPv4 建 A，有 IPv6 建 AAAA。
- 用 3x-ui 官方非交互脚本安装或重设远端节点端，并通过 Caddy 暴露 HTTPS 面板。
- 如果本机已经是主控面板，会直接复用主控 3x-ui，不刷新主控登录信息，也不把自己导入为远端节点。
- 如果本机只是装过 3x-ui，会复用现有安装，避免重复安装冲突。
- 生成本机接入报告。
- 如果已配置主控信息，自动接入主控、验证节点在线，并按所选协议自动创建主控入站和客户端；客户端分享链接未生成时会中断并提示。
- Hysteria2 / 端口跳跃入站会自动使用节点 3x-ui 面板证书路径，避免 Xray 因 TLS 证书缺失启动失败。

## 主控面板做什么

- 输入主控短名，生成 `主控短名.kouzho.cc`。
- 复用 Cloudflare Token，自动新增或更新 DNS，小灰云。
- 用 3x-ui 官方非交互脚本安装或重设主控面板，并通过 Caddy 暴露 HTTPS 面板。
- 自动生成用户名、密码、随机访问路径和 API Token。
- 自动保存主控域名、面板地址、API Token。
- 输出主控面板卡片。
- 卡片里会生成一段可复制到「基础设置 -> 一键导入」的主控信息。
- 主控本机不自动给自己建入站；远端节点接入后会自动在主控创建远端入站。
- 主控面板的订阅、规则、出站等高级设置由用户登录 3x-ui 网站自行维护，`akvps` 不做复杂巡检或自动修复。

## 一键接入主控做什么

- 读取当前节点信息和主控信息。
- 先调用 3x-ui 主控 API 测试节点连通。
- 测试在线后，自动把当前节点添加到主控节点列表。
- 自动按节点协议创建或更新主控入站。
- VLESS Reality 会通过 3x-ui 官方 API 生成 X25519 公钥 / 私钥，并创建客户端。
- Hysteria2 会创建 Hysteria2 客户端；端口跳跃会写入 `finalmask.quicParams.udpHop.ports`。
- 自动验证客户端分享链接；VLESS 需要 `vless://`，Hysteria2 需要 `hysteria2://`，端口跳跃还会检查 `mport`。
- 重复运行会保留已有客户端、Reality 密钥和 Short ID；如果客户端存在但未绑定当前入站，会自动补绑定。
- 主控机本机做代理时，不需要接入自己，直接在主控面板里创建本机入站。
- 若 3x-ui 客户端页的关联入站只显示数字，通常是浏览器缓存，强制刷新页面即可恢复显示入站名称。

## 探针部署做什么

- 输入 Komari 面板地址。
- 如果已导入 Komari 自动发现密钥，会自动注册本机，不需要手工复制节点 Token。
- 网络统计月重置日可在一键导入里预填，也可部署时单独填写。
- 使用 Komari 官方 agent 安装脚本。
- 默认关闭 Web SSH / 远程命令，只保留监控探针。
- 输出 Komari 探针卡片。

## 主站部署做什么

- 输入主站短名，生成 `主站短名.kouzho.cc`。
- 复用 Cloudflare Token，自动新增或更新 DNS，小灰云。
- 使用 Komari 官方主站安装脚本。
- 如果本机已经运行 Komari 主站，可选择复用或重装；重装会删除旧 Komari 数据并重新生成账号密码。
- Komari 后端默认端口 `25774`，外部通过 Caddy 自动 HTTPS 访问。
- 输出 Komari 主站卡片。

## 固定端口

- 3x-ui 被控端面板：本机 `11123/tcp`，公网通过 Caddy 的 `443/tcp` 访问。
- 3x-ui 主控面板：本机 `11123/tcp`，公网通过 Caddy 的 `443/tcp` 访问。
- Komari 主站：外部开放 `80/tcp`、`443/tcp`，后端 `25774/tcp` 不直接开放。
- VLESS Reality：`11789/tcp`。
- Hysteria2：`11799/udp`。
- Hysteria2 端口跳跃：服务端口 `11799/udp`，跳跃范围 `39999-59999/udp`。

## 本机文件

- 配置：`/etc/akvps/config.env`
- 敏感信息：`/etc/akvps/secrets.env`
- 报告和卡片：`/var/lib/akvps/reports/`

`更新卸载 -> 清除所有设定` 只清除 akvps 自己保存的配置、密钥、角色状态和报告，不删除 3x-ui、Komari，也不改 SSH / UFW。

## 注意

第一版面向新 VPS 或可覆盖配置的 VPS。重复运行面板部署会刷新 3x-ui 用户名、密码、WebBasePath 和 API Token，但保留已有 3x-ui 数据库、入站和客户端；主控机再运行代理节点时会复用主控面板信息，不会刷新主控登录信息，也不会把自己导入为远端节点。

## 真实 VPS 测试前准备

- 一台 Debian 12 或 Ubuntu 24.04 新 VPS。
- 主控 3x-ui 的 IPv4；如果主控有 IPv6，也填 IPv6。
- Cloudflare Token，权限包含 `Zone Read` 和 `DNS Edit`，作用范围为 `kouzho.cc`。
- 节点短名，例如 `jp1`。
- 本地到 VPS 的大概 ping 延迟。
- 如果使用 Komari 自动发现，可以提前导入 Komari 主站地址、自动发现密钥和月重置日。
