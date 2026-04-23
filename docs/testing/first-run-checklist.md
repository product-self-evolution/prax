# First-Run Checklist — Prax 新用户首次部署测试脚本

> **用途**: 用这份脚本做一次"从 0 到可运行 Agent"的完整测试。目的不是学会，而是帮 Prax 收集真实部署数据（Deploy Time / First Deploy Rate），作为 Phase 1 MVP 验证依据。
>
> **预计用时**: 60-90 分钟（含填写反馈）
> **你会得到**: 一个真实跑在你自己账号里的企业级 AI Agent
> **我们会得到**: 产品改进最关键的第一手数据

---

## 如果你是来做测试的

先谢谢你。你只需要做三件事：

1. 按下面的 **Pre-Flight Checklist** 准备好前置条件（10 分钟）
2. 按 **Test Protocol** 真实跑一次部署（30 分钟）
3. 填写 **Feedback Template** 交给我们（10 分钟）

全程遇到任何问题**别自己解决**，直接记下来并继续往下走，失败点本身就是我们最想要的数据。

---

## Pre-Flight Checklist

在开始计时前完成以下准备：

### 账号准备

- [ ] Dify 账号（推荐 [Dify Cloud](https://cloud.dify.ai) 免费注册，或自托管 Docker）
- [ ] 至少 1 个 LLM API Key
  - [ ] OpenAI：`https://platform.openai.com/api-keys`（最稳）
  - [ ] Anthropic：`https://console.anthropic.com/settings/keys`
  - [ ] 国产模型（阿里通义、月之暗面、智谱）任一均可
- [ ] SMTP 账号（仅测试 `ai-digest` 时需要）
  - Gmail: [生成应用专用密码](https://myaccount.google.com/apppasswords)
  - 其他邮箱: SMTP 授权码
- [ ] 一台能上外网的电脑

### 工具准备

- [ ] Git 已安装（`git --version` 能返回版本）
- [ ] 可编辑 YAML 文件的编辑器（VS Code / Cursor / Sublime / 记事本都可）

### 环境检查

```bash
git --version         # 期望: git version 2.x.x
echo $SHELL           # 期望: /bin/zsh 或 /bin/bash
```

如果任一检查失败，把失败信息记到反馈里，**不要尝试自己装依赖**，这是我们要改进的地方。

---

## Test Protocol

### Phase 0 — 克隆仓库（< 3 分钟）

```bash
git clone https://github.com/product-self-evolution/prax.git
cd prax
```

**🕐 记录开始时间**: `T0 = ___________`

### Phase 1 — 挑一个模板

Phase 1 MVP 只有 3 个模板，推荐顺序：

| 模板 | 难度 | 预计耗时 | 适合初次测试者 |
|---|---|---|---|
| `ai-digest` | ⭐⭐ 中 | 30 分钟 | ✅ 推荐首选（最接近真实场景） |
| `content-repurpose` | ⭐⭐⭐ 较难 | 40 分钟 | ⚠️ 需要审美判断 |
| `workflow-starter` | ⭐ 简单 | 20 分钟 | ❌ 只是骨架，不是真实场景 |

**新用户请选 `ai-digest`**。

### Phase 2 — 按模板 README 操作

```bash
cd modules/ai-digest
cat README.md          # 先快速读一遍，了解全貌
cat docs/deployment.md # 按这个操作
```

执行文档中的每一步时，**如果任何一步让你卡住超过 2 分钟**：

1. 记录：`卡点: 第 X 步做 Y 操作时遇到 Z 问题`
2. 继续跳过尝试下一步
3. **不要自己去搜索解决**（我们正是要找这些卡点）

### Phase 3 — 验收

当你做到任一情况都算本次测试结束：

#### 成功终点

- [ ] Agent workflow 在 Dify 里可运行
- [ ] 运行一次后收到邮件/看到 digest 输出
- [ ] 内容符合 `output/digest.sample.md` 结构

**🕐 记录结束时间**: `T1 = ___________`
**DT（Deploy Time） = T1 - T0 = _________ 分钟**

#### 失败终点（同样有价值）

选择以下一个并记录：

- [ ] 卡在某一步超过 10 分钟无法推进
- [ ] 文档指示不清楚，我不知道下一步做什么
- [ ] 某个前置条件我无法满足
- [ ] 其他: ___________

**🕐 记录放弃时间**: `T_give_up = ___________`
**放弃点**: `步骤 X - ___________`

---

## Feedback Template

复制以下内容填写，然后作为 Issue 提交到 https://github.com/product-self-evolution/prax/issues/new 或发给我们。

```markdown
## Prax First-Run Feedback

**测试人身份**: 产品经理 / 运营 / 开发者 / 其他___
**使用的 LLM**: OpenAI GPT-4 / Claude / 其他___
**测试的模板**: ai-digest / content-repurpose / workflow-starter

### 核心数据

- **DT (Deploy Time)**: ___ 分钟
- **结果**: 成功 / 失败（放弃点 = 步骤 ___）
- **FDR (First Deploy Rate)**: 成功 = 1 / 失败 = 0

### 卡点清单（按出现顺序）

1. 在 "___步骤___" 遇到 "___问题___"，期望的是 "___我以为会发生什么___"
2. ...

### 文档质量

- README 的哪一段最有帮助？ ___
- README 的哪一段最让人困惑？ ___
- 如果让你改一个地方，你会改什么？ ___

### 价值判断

- 这个 Agent 上线后，你会继续每天用吗？（Y / N / 也许）
- 如果 N，主要原因是？ ___
- 你认为它对"我的业务"有多大价值（1-5 分，5 最有价值）？ ___

### 推荐意愿

- 你会推荐给同事或朋友吗？（Y / N / 也许）
- 为什么？ ___

### 自由意见

任何建议、吐槽、想法：
___
```

---

## 常见失败模式（我们已知但还没修）

如果你遇到以下之一，可以确认它们是"已知问题"，但仍然请记录到反馈里：

| 已知问题 | 当前状态 |
|---|---|
| `workflow/*.dify.yaml` 是骨架，直接导入会报错 | Phase 1 收尾任务 - 需要在 Dify UI 搭建后导出正式 DSL |
| 没有中文界面的部署截图 | Phase 1.2 计划 - 录制部署视频 |
| 部分 RSS 源在国内访问缓慢 | 已知 - 建议用 `anthropic-news` / `hackernews` 等稳定源 |
| LLM 输出偶尔非 JSON 导致后续节点失败 | 已知 - 需要在 LLM 节点启用 `Response Format: JSON` |

---

## 隐私与数据

- 你填写的反馈会被用于 Prax 产品改进
- 我们不会收集你的 API Key、SMTP 密码、个人内容
- 你可以匿名提交（GitHub Issue 用 anonymous 账号）
- 反馈数据的汇总版会出现在未来的 release notes 里

---

感谢你愿意成为 Prax 的首批测试者。

如果你对 Prax 的整体方向感兴趣，欢迎关注 [github.com/product-self-evolution/prax](https://github.com/product-self-evolution/prax)。
