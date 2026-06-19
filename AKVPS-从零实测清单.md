# AKVPS 从零实测清单

更新时间：2026-06-19

## 一、测试版本

当前测试固定版：`0.1.87-mvp`

固定提交：

```text
5c02f79aec1ef80f93332e30eba90790f6ff1d0e
```

安装命令：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AngKouChan/akvps/5c02f79aec1ef80f93332e30eba90790f6ff1d0e/install.sh)
```

注意：不要使用 `main` raw 地址测试。当前 GitHub raw 的 `main` 仍可能缓存旧版。

## 二、测试前确认

- VPS 可以重装或清空。
- 已能用 root 登录。
- 系统建议 Debian 12 或 Ubuntu 22.04/24.04。
- 域名 DNS 可以改，并且代理节点域名使用 DNS only。
- 不要在 Malibu、Megabox、netcup 主控、已交付 Zouter 上贸然测试。

## 三、主控测试

1. 在主控 VPS 执行安装命令。
2. 选择部署主控面板。
3. 记录主控卡片。
4. 打开 3x-ui 面板确认能登录。
5. 确认主控卡片里有 `PANEL_URL` 和 `PANEL_API_TOKEN`。

验收：

- 3x-ui 服务正常。
- 主控卡片生成成功。
- API Token 已保存，不在公开地方泄露完整值。

## 四、节点测试

1. 在节点 VPS 执行同一个安装命令。
2. 使用一键导入粘贴主控卡片。
3. 部署代理节点。
4. 选择协议，当前已验收 `vless`；`hy2` 和 `hy2端口跳跃` 需单独实测。
5. 执行一键接入主控。

验收：

- 主控节点列表出现该节点。
- 节点状态 online。
- Xray 状态正常。
- 自动生成 VLESS Reality 入站。
- 如选择 HY2 / HY2 端口跳跃，应自动生成对应入站。
- 自动生成客户端。
- 客户端已写入对应入站的 `settings.clients`。
- 如果 3x-ui 客户端页的关联入站只显示数字，强制刷新页面后应显示入站名称。

## 五、客户端测试

1. 在主控面板打开客户端链接。
2. 导入 v2rayN。
3. 测延迟。
4. 测网页连通。

验收：

- v2rayN 能识别 VLESS Reality。
- 如果本轮测试选择 HY2 或 HY2 端口跳跃，v2rayN 应能识别对应链接。
- 至少一个节点延迟正常。
- 能实际访问外网。
- 3x-ui 客户端页和入站页能看到流量回传。

## 六、出错时回传给小寇

请尽量贴以下信息：

- 当前在哪一步失败。
- 失败提示原文或截图。
- `akvps version` 输出。
- 面板里节点状态。
- 面板里入站和客户端是否出现。
- v2rayN 报错文字。
- 3x-ui 客户端页是否强制刷新过。

不要发完整 API Token、私钥、UUID、订阅密钥。
