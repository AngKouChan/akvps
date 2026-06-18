# Angkou-Vps 轻量版

`akvps` 是在单台 VPS 内运行的中文 VPS 部署与维护工具。第一版重点做：代理节点、探针 Agent、3x-ui 主控面板、Komari 探针主站。

## 安装

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/main/install.sh)
```

安装后会自动打开中文菜单。以后输入：

```bash
akvps
```

菜单会逐级返回：二级菜单里的功能执行完，会留在当前二级菜单；只有选择 `0. 返回` 才回到上一级。

## 本地检查

```bash
./scripts/check.sh
```

## 第一版范围

- 完整实现：基础设置、本机部署、日常维护、更新 / 卸载。
- 支持系统：Debian 11/12/13，Ubuntu 22.04/24.04。
- 不做本地总控、不做多 VPS 台账、不做 Halo、不做成本统计。

## 菜单

```text
1. 基础设置
   1. 一键导入
   2. 基础信息
   3. 主控信息
   4. 探针信息
   5. 查看信息
   0. 返回

2. 本机部署
   1. 代理节点
   2. 探针Agent
   3. 主控面板
   4. 探针主站
   0. 返回

3. 日常维护
   1. 接入主控
   2. 验证接入
   3. 验证探针
   4. 恢复密码登录
   0. 返回

4. 更新 / 卸载
   1. 更新脚本
   2. 更新 3x-ui
   3. 更新 Komari 探针
   4. 卸载脚本
   5. 查看版本
   0. 返回
```

## 基础设置做什么

- `一键导入`：一次性粘贴根域名、Cloudflare Token、主控信息、探针信息。
- `基础信息`：粘贴导入主控 IPv4、Cloudflare Token、根域名。
- `主控信息`：粘贴导入 3x-ui 主控域名、面板完整地址、API Token。
- `探针信息`：粘贴导入 Komari 主站域名和主站地址。
- `查看信息`：查看当前配置、远端节点接入信息、面板卡片、探针卡片、主站卡片；Token 默认遮挡。
- 敏感信息保存到 `/etc/akvps/secrets.env`，不上传 GitHub。

## 节点部署做什么

- 保存主控 IPv4 和 Cloudflare Token 到 VPS 本机。
- 生成 `节点短名.kouzho.cc`。
- 配置 Termius 统一 SSH 公钥并禁用密码登录。
- 按内存判断是否创建 Swap。
- 安装必要工具并设置上海时区。
- 默认启用智能调优，也可选择基础调优。
- 配置 UFW。
- Cloudflare DNS 小灰云：有 IPv4 建 A，有 IPv6 建 AAAA。
- 用 3x-ui 官方非交互脚本安装或重设远端节点端。
- 如果本机已经是主控面板，会直接复用主控 3x-ui，不刷新主控登录信息，也不把自己导入为远端节点。
- 如果本机只是装过 3x-ui，会复用现有安装，避免重复安装冲突。
- 生成本机接入报告。
- 如果已配置主控信息，自动接入主控并验证。

## 主控面板做什么

- 输入主控短名，生成 `主控短名.kouzho.cc`。
- 复用 Cloudflare Token，自动新增或更新 DNS，小灰云。
- 用 3x-ui 官方非交互脚本安装或重设主控面板。
- 自动生成用户名、密码、随机访问路径和 API Token。
- 自动保存主控域名、面板地址、API Token。
- 输出主控面板卡片。
- 卡片里会生成一段可复制到「基础设置 -> 一键导入」的主控信息。
- 暂不自动创建入站。

## 一键接入主控做什么

- 读取当前节点信息和主控信息。
- 先调用 3x-ui 主控 API 测试节点连通。
- 测试在线后，自动把当前节点添加到主控节点列表。
- 目前不自动创建入站，入站仍在主控面板里配置。
- 主控机本机做代理时，不需要接入自己，直接在主控面板里创建本机入站。

## 探针部署做什么

- 输入 Komari 面板地址和节点 Token。
- 使用 Komari 官方 agent 安装脚本。
- 默认关闭 Web SSH / 远程命令，只保留监控探针。
- 输出 Komari 探针卡片。

## 主站部署做什么

- 输入主站短名，生成 `主站短名.kouzho.cc`。
- 复用 Cloudflare Token，自动新增或更新 DNS，小灰云。
- 使用 Komari 官方主站安装脚本。
- 默认端口 `25774`。
- 输出 Komari 主站卡片。
- 暂不配置 HTTPS / 反向代理，后续再补。

## 固定端口

- 3x-ui 被控端面板：`11123/tcp`，只允许主控 IPv4 访问。
- 3x-ui 主控面板：`11123/tcp`。
- Komari 主站：`25774/tcp`。
- VLESS Reality：`11789/tcp`。
- Hysteria2：`11799/udp`。
- Hysteria2 端口跳跃：`39999-59999/udp`。

## 本机文件

- 配置：`/etc/akvps/config.env`
- 敏感信息：`/etc/akvps/secrets.env`
- 报告和卡片：`/var/lib/akvps/reports/`

## 注意

第一版面向新 VPS 或可覆盖配置的 VPS。重复运行面板部署会刷新 3x-ui 用户名、密码、WebBasePath 和 API Token，但保留已有 3x-ui 数据库、入站和客户端；主控机再运行代理节点时会复用主控面板信息，不会刷新主控登录信息，也不会把自己导入为远端节点。

## 真实 VPS 测试前准备

- 一台 Debian 12 或 Ubuntu 24.04 新 VPS。
- 主控 3x-ui 的 IPv4。
- Cloudflare Token，权限包含 `Zone Read` 和 `DNS Edit`，作用范围为 `kouzho.cc`。
- 节点短名，例如 `jp1`。
- 本地到 VPS 的大概 ping 延迟。
- 如果部署 Komari 探针，需要先在 Komari 面板中创建节点并复制 Token。
