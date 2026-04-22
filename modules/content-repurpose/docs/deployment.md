# content-repurpose - 部署指南（30 分钟 Quick Deploy）

本指南帮助你在 30 分钟内部署 `content-repurpose` Agent，把单篇内容自动改写为多平台适配草稿。

---

## 前置条件清单（约 5 分钟）

| 项目 | 说明 | 获取方式 |
|---|---|---|
| Dify 账号 | Cloud 或本地部署均可 | https://cloud.dify.ai |
| LLM API Key | OpenAI / Anthropic 任一，推荐 Claude 或 GPT-4 级别 | 开发者后台 |
| SMTP / 飞书 Webhook（可选） | 仅当需要通知时 | 略 |

### 成本估算（一次改写 3 个平台）

- 短文（1000 字以内）: ~0.02 USD
- 中文（2000-3000 字）: ~0.05 USD
- 长文（>5000 字）: ~0.15 USD

---

## Step 1 - 准备配置（约 5 分钟）

```bash
cd modules/content-repurpose/configs
cp platforms.sample.yaml platforms.yaml
cp delivery.sample.yaml delivery.yaml
```

编辑 `platforms.yaml`：

- 关闭你不需要的平台（`enabled: false`）
- 调整 `constraints.max_chars` 等字数约束到你的习惯
- 修改 `tone` 到你的个人风格（保守/活泼/专业）

编辑 `delivery.yaml`（可选）：

- MVP 默认只把草稿写入 `output/` 目录
- 如需通知，填入 SMTP 或飞书 Webhook

---

## Step 2 - 在 Dify 搭建 Workflow（约 15 分钟）

### 2.1 创建 Workflow App

1. 进入 Dify → 创建应用 → Workflow
2. 命名为 `Prax - Content Repurpose Agent`

### 2.2 按骨架搭建节点

参考 `workflow/content-repurpose.dify.yaml` 的节点规划：

```text
[Start] (输入 source_content)
  ↓
[Load Platforms Config]    (Code 节点, 读取 platforms.yaml)
  ↓
[Iterate Platforms]        (Iteration 节点, 遍历 enabled platforms)
  ↓ (每次迭代)
[Rewrite for Platform]     (LLM 节点, 使用 prompts/rewriter.prompt.md)
  ↓
[Collect Drafts]           (Variable Aggregator, 汇总所有草稿)
  ↓
[Save Drafts]              (Code 节点, 写入 output/drafts/)
  ↓
[Send Notification]        (HTTP Request, 可选)
```

### 2.3 配置 LLM 节点

- `Rewrite for Platform` → System Prompt 粘贴 `prompts/rewriter.prompt.md` 全文
- User Message: `source={{ source }}, platform={{ platform }}, settings={{ settings }}`

### 2.4 配置环境变量（仅在启用通知时）

- `PRAX_SMTP_HOST`, `PRAX_SMTP_PASSWORD`
- `PRAX_FEISHU_WEBHOOK`

---

## Step 3 - 跑一次测试（约 5 分钟）

1. 打开 workflow 调试模式
2. 在 `source_content` 输入框粘贴 `input/source.sample.md` 的内容
3. 运行
4. 检查 `output/drafts/` 目录下的草稿文件

**预期结果**: 生成 3 份（默认启用的 3 个平台）草稿，分别对应：

- `xiaohongshu-2026-04-08-<slug>.md`
- `wechat-article-2026-04-08-<slug>.md`
- `video-script-2026-04-08-<slug>.md`

对照 `output/*.sample.md` 看结构是否一致。

---

## Step 4 - 验收 DoD

- [ ] workflow 导入并连线成功
- [ ] 用 sample input 跑通，生成 3 份草稿
- [ ] 草稿符合各平台 constraints（字数、格式）
- [ ] 草稿没有违反"事实严格"（没有虚构 source 中不存在的内容）
- [ ] （可选）通知渠道收到"草稿已生成"消息

完成以上 4 条 → 模块部署完成。

---

## 常见问题排查

### Q1 草稿字数超出 constraints

**症状**: 小红书平台输出超过 1000 字

**修复**:
- 在 `platforms.yaml` 中调小 `max_chars`
- 在 Rewriter prompt 末尾加一句："严格把总字数控制在 {{ platform.constraints.max_chars }} 以内，否则重写"

### Q2 AI 虚构了 source 中没有的事实

**症状**: 生成的草稿出现 source 里没提到的数据、人名

**修复**:
- 在 Rewriter prompt 中加重"事实严格"规则的强调
- 使用更强的模型（Claude Sonnet 或 GPT-4）
- 在 source 中标明"禁止添加 [X] 类信息"

### Q3 LinkedIn 英文输出含中文残留

**症状**: 启用 LinkedIn 平台后，输出混杂中文

**修复**:
- 在 platforms.yaml 的 LinkedIn 配置中明确 `output_language: en-US`
- 在 prompt 中加："For LinkedIn platform, output must be 100% English"

### Q4 所有平台输出都很模板化

**症状**: 各平台草稿读起来像同一个模子

**修复**:
- 检查 `platforms.yaml` 的 `tone` 差异化是否够明显
- 给每个平台的 `ai_hints` 加 3-5 条更具体的风格示范
- 使用 Claude 级别模型，它对 tone 的区分更敏感

---

## 进阶：与 ai-digest 模块联动

这两个 Agent 可以组合成一个内容生产流水线：

```mermaid
flowchart LR
    rss["RSS 源"] --> digest["ai-digest Agent"]
    digest --> draft["内容素材"]
    draft --> repurpose["content-repurpose Agent"]
    repurpose --> platforms["多平台草稿"]
```

实现方式：在 Dify 中创建"主 workflow"，顺序调用两个子 workflow。

## 下一步

- 根据业务场景调整 `platforms.yaml`
- 建立你的"待改写队列"（Notion / 文件夹）
- 预留 Phase 2 扩展：直接发布到平台 API（小红书 Open API、公众号 Draft API 等）
