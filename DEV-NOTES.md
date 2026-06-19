# 开发记录

更新时间：2026-06-19

## 当前版本

- 版本：`0.1.87-mvp`
- 形态：Bash 单文件主程序 + Bash 安装脚本。
- 运行位置：用户 SSH 登录到哪台 VPS，就在那台 VPS 上运行 `akvps`。
- 当前方向：单台 VPS 开荒、代理节点上线、3x-ui 主控接入、Komari 探针接入。

## 已实测闭环

- 主控 3x-ui 部署和主控卡片生成。
- 远端节点部署。
- Cloudflare DNS 自动创建小灰云记录。
- 主控节点自动添加和在线检测。
- 主控入站自动创建。
- 客户端自动创建并绑定目标入站。
- 主控入站同步到节点本机，节点端口可监听。
- v2rayN 可导入自动生成的 VLESS Reality 链接。
- VLESS Reality 代理可用，流量能回传到 3x-ui。
- 3x-ui 客户端页若显示数字关联入站，强制刷新页面后可恢复为入站名称。

## 当前已知边界

- 3x-ui 客户端页的入站下拉有前端缓存；脚本已经增加提示，但不能直接刷新浏览器页面。
- HY2 / HY2 端口跳跃还未做真实客户端连通测试，不能视为已验收。
- 当前重点是单节点 VPS 内工具，不做本地多 VPS 总控。
- 当前不做完整代理规则管理；规则交给 Clash/Mihomo、v2rayN 等客户端。
- 主控面板设置由昂寇登录 3x-ui 网站维护，脚本不做复杂巡检或自动修复。
- 敏感信息保存在 VPS 本机 `/etc/akvps/secrets.env`，不进入仓库。

## 发布仓库

```text
https://github.com/AngKouChan/akvps
```

安装命令：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/main/install.sh)
```
