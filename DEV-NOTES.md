# 开发记录

## 当前版本

- 版本：`0.1.3-mvp`
- 目标：先完成功能一「初始设置」，补极简「面板部署」「探针部署」「主站部署」。
- 形态：Bash 单文件主程序 + Bash 安装脚本。

## 待真实 VPS 补齐

- 主控 IPv4：运行时输入并保存到 `/etc/akvps/config.env`。
- Cloudflare Token：运行时输入并保存到 `/etc/akvps/secrets.env`。
- 真实 VPS 测试：Debian 12 或 Ubuntu 24.04 优先。
- 面板部署：用新 VPS 实测 3x-ui HTTPS 证书签发和登录卡片。
- 探针部署：用真实 Komari 面板 Token 测试 agent 注册和服务状态。
- 主站部署：用新 VPS 实测 Komari 官方脚本、默认端口和初始密码读取。

## 发布目标

公开仓库：

```text
https://github.com/AngKouChan/akvps
```

安装命令：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/main/install.sh)
```
