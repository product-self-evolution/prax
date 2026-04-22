# ai-digest - 部署指南（30 分钟 Quick Deploy）

本指南帮助你在 30 分钟内，在 Dify 上部署 `ai-digest` Agent，并接通邮件推送。

---

## 前置条件清单（约 10 分钟）

在开始前，确保你拥有：

| 项目 | 说明 | 获取方式 |
|---|---|---|
| Dify 账号 | Dify Cloud 或本地部署 | https://cloud.dify.ai 或 `docker compose up` 自托管 |
| LLM API Key | 至少一个：OpenAI / Anthropic / 兼容 API | OpenAI / Anthropic 开发者后台 |
| SMTP 账号 | 邮件发送凭据 | Gmail 应用专用密码 / 企业邮箱 / 阿里云邮件推送 |
| RSS 源清单 | 3-5 个你关注的 RSS URL | 自行准备，或直接用 `configs/sources.sample.yaml` |

### 成本估算（MVP 规模）

- LLM 调用: 每日日报约 0.03 USD - 0.1 USD（取决于模型）
- SMTP: 免费层足够（Gmail 每日 500 封，远超日报需求）
- Dify 本地部署: 免费

---

## Step 1 - 准备配置文件（约 5 分钟）

复制 sample 并填入你自己的配置：

```bash
cd modules/ai-digest/configs
cp sources.sample.yaml sources.yaml
cp delivery.sample.yaml delivery.yaml
```

编辑 `sources.yaml`：
- 删除你不需要的 RSS 源
- 添加 2-3 个你真正关心的源
- 调整 `filters.min_score` 的严格度（推荐 6-7）

编辑 `delivery.yaml`：
- 填入你的 SMTP host、port、from 地址
- 设置收件人邮箱
- **不要在文件里写明文密码**，使用环境变量 `password_env` 字段

---

## Step 2 - 在 Dify 导入 Workflow（约 10 分钟）

### 2.1 登录 Dify 并创建 Workflow App

1. 进入 Dify → 创建应用 → Workflow
2. 命名为 `Prax - AI Digest Agent`

### 2.2 按骨架搭建节点

参考 `workflow/ai-digest.dify.yaml` 中的节点规划，依次添加 7 个节点：

```text
[Scheduled Start]
  ↓
[Fetch RSS Feeds]      (HTTP Request, 遍历 sources.yaml 中的 URL)
  ↓
[Parse RSS to Items]   (Code 节点, Python3, RSS XML → 结构化 items[])
  ↓
[Score Item Value]     (LLM 节点, 使用 prompts/scorer.prompt.md)
  ↓
[Filter by Score]      (Code 节点, 按 min_score 过滤)
  ↓
[Generate Digest]      (LLM 节点, 使用 prompts/summarizer.prompt.md)
  ↓
[Deliver via Email]    (HTTP Request, SMTP 发送)
```

### 2.3 配置 LLM 节点

- `Score Item Value` → System Prompt 粘贴 `prompts/scorer.prompt.md` 全文
- `Generate Digest` → System Prompt 粘贴 `prompts/summarizer.prompt.md` 全文

### 2.4 配置环境变量

在 Dify 工作流的 Environment Variables 中设置：

- `PRAX_SMTP_HOST`
- `PRAX_SMTP_PORT`
- `PRAX_SMTP_USER`
- `PRAX_SMTP_PASSWORD`
- `PRAX_EMAIL_FROM`
- `PRAX_EMAIL_TO`

---

## Step 3 - 跑一次手动测试（约 5 分钟）

1. 点击 workflow 右上角 `Run` 或 `Debug`
2. 观察每个节点的输入输出是否符合预期
3. 如果 `Deliver via Email` 成功，查收邮箱

**预期结果**: 收到一封结构化的 digest 邮件，内容对照 `output/digest.sample.md` 格式。

---

## Step 4 - 配置定时触发（约 3 分钟）

### 方式 A：Dify 自带 Schedule（推荐）

在 Dify workflow 设置中启用定时触发，设置为 `daily 09:00`。

### 方式 B：外部 cron + HTTP 调用

如果 Dify 版本不支持定时触发，用外部 cron 调用 Dify workflow 的 HTTP API：

```bash
# crontab 示例（每日 09:00 触发）
0 9 * * * curl -X POST https://your-dify-host/api/workflows/run \
  -H "Authorization: Bearer YOUR_APP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"inputs": {}, "response_mode": "blocking"}'
```

---

## Step 5 - 验收 DoD（Definition of Done）

- [ ] 首次导入到 Dify 并连线成功
- [ ] 手动跑一次 workflow，邮箱收到 digest
- [ ] 定时触发配置完成
- [ ] 第二天 09:00 自动收到一份 digest
- [ ] 内容与 `output/digest.sample.md` 结构一致

完成以上 5 条，模块视为 Deploy 完成。

---

## 常见问题排查

### Q1 RSS 源拉取失败

**症状**: `Fetch RSS Feeds` 节点报错 403/404

**原因**: 部分 RSS 源对 User-Agent 有要求

**修复**: 在 HTTP Request 节点的 Headers 中添加：

```
User-Agent: Mozilla/5.0 (compatible; PraxBot/1.0)
```

### Q2 LLM 评分返回非 JSON

**症状**: `Score Item Value` 输出不是有效 JSON，后续节点解析失败

**修复**:
- 在 LLM 节点启用 "Response Format = JSON"
- 或在 prompt 末尾强调 "只输出 JSON，无解释文字"

### Q3 SMTP 发送失败（Authentication Required）

**症状**: `Deliver via Email` 返回 535 认证错误

**原因**: 大多数邮箱不支持用登录密码直接 SMTP

**修复**:
- Gmail: 使用"应用专用密码"
- 企业邮箱: 启用 SMTP 专用授权码
- 阿里云邮件推送: 使用 SMTP 凭证而非控制台密码

### Q4 digest 内容空洞、全是套话

**症状**: 生成的 digest 充满"随着 AI 的发展..."

**修复**:
- 检查 `prompts/summarizer.prompt.md` 是否完整粘贴
- 把 `filters.min_score` 提高到 7 或 8
- 在 prompt 末尾追加: "严禁使用任何形容词开头的套话句式"

---

## 下一步

部署成功后：

- 调整 `sources.yaml` 适配你的行业
- 把日报改为周报（修改 `delivery.yaml` 的 `schedule.mode: weekly`）
- 参考 `modules/content-repurpose` 把 digest 进一步改写成多平台内容
- 预留 Phase 2 扩展：多渠道推送（Slack / 飞书 / 企业微信）
