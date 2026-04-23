# Module Quality Checklist — Prax 模板质量门槛

> **适用对象**: 模块作者、PR 审核者、任何想把模板贡献到 `modules/` 的人
>
> **核心原则**: Prax 不追求"数量多"，而追求"每一个模板都能被企业级场景用得起来"。质量不达标的模板即使结构完整，也会拒绝合并。

---

## 为什么需要这个门槛

过去的开源模板生态（Awesome-X 系列）都掉进了同一个坑：

- 模板数量膨胀但质量参差
- 新用户 fork 后发现跑不起来
- 维护者无力 review，新 PR 积压
- 整个仓库信任度下降，Star 数上升但使用率下降

Prax 的定位是"企业级 AI Agent 场景模板库"。**可信赖是比数量更重要的护城河**。这份 checklist 就是护城河的工事图。

---

## 分级体系

所有模板按质量分为 3 档：

| 档位 | 标签 | 含义 | 审核严格度 |
|---|---|---|---|
| **Official** | `tier: official` | 官方维护、稳定、有企业落地案例 | ⭐⭐⭐⭐⭐ |
| **Recommended** | `tier: recommended` | 社区贡献、通过严格 review、可用 | ⭐⭐⭐⭐ |
| **Experimental** | `tier: experimental` | 创新想法、结构完整、但未充分验证 | ⭐⭐⭐ |

新 PR 默认进入 **Experimental**，累积真实部署验证后可申请升级到 Recommended，长期稳定后由维护者升级到 Official。

---

## 必备交付物（Minimum Deliverables）

任何模板要进入 `modules/` 必须包含以下结构，**缺一不可**：

```text
modules/<your-agent-name>/
  README.md               # 对外说明 + 业务场景
  configs/
    *.sample.yaml         # 至少一份样例配置
  prompts/
    *.prompt.md           # 至少一个 LLM 节点的 prompt 源
  workflow/
    *.dify.yaml           # Dify workflow（骨架或完整 DSL）
  docs/
    deployment.md         # 30 分钟部署指南
  output/
    *.sample.md           # 至少一份样例输出
```

**可选但加分**:

```text
  input/
    *.sample.md           # 对于需要输入内容的模板
  docs/
    customization.md      # 定制指南
    troubleshooting.md    # 故障排查（超过 deployment.md 的部分）
    FAQ.md
```

---

## README.md 必须包含的章节

照着 `modules/ai-digest/README.md` 的结构来。**以下章节缺一不可**：

- [ ] 顶部 metadata block（`> **类型**` / `> **阶段**` / `> **预计部署时间**`）
- [ ] `Business Scenario` — 对应岗位 + 真实场景（不允许"通用"这种描述）
- [ ] `Architecture` — mermaid 架构图
- [ ] `Deliverables` — 文件列表与用途
- [ ] `Prerequisites` — 前置条件清单
- [ ] `Quick Start` — 5-10 步速览
- [ ] `Configuration` — 至少一个核心 YAML 的解释
- [ ] `Expected Output` — 具体输出样例（或指向 output/*.sample.md）
- [ ] `Customization` — 如何 fork 并改成自己的
- [ ] `DoD (Definition of Done)` — 部署完成的判定标准
- [ ] `Roadmap of this Module` — 模块自身的版本计划

---

## 质量维度（Review 时按这 5 个维度评分）

### 维度 1 — Clarity（清晰度）

| 项 | 评分标准 |
|---|---|
| 业务场景描述 | 能让非目标岗位的人 1 分钟内明白"这个模板解决谁的什么问题" |
| 架构图 | 任何开发者能在 30 秒内看懂数据流 |
| 命名规范 | kebab-case、语义化、避免缩写 |
| 术语定义 | 首次出现的术语附括号英文原意（如"RAG (Retrieval-Augmented Generation)"） |

**不通过示例**: "这是一个通用的 AI 助手，可以帮你做很多事情"（太虚）
**通过示例**: "帮产品经理每天早上 9 点自动收到 AI 行业日报，包括 3 条 Top News 和 3 条可执行行动建议"

### 维度 2 — Runability（可运行性）

| 项 | 评分标准 |
|---|---|
| Prerequisites 完整 | 前置条件写全了，不假设用户有未声明的依赖 |
| 步骤可复制 | 所有命令可直接复制粘贴，不需要"按你的情况修改 XXX" |
| 错误路径覆盖 | `troubleshooting` 至少列出 3 个常见失败点 |
| 样例数据 | input/ 和 output/ 下有 sample 文件，可直接跑通 |
| 时间可达 | `Quick Start` 的步骤真能在 30 分钟内完成 |

**验证方法**: PR 审核者必须找一台**没装过这个模板**的机器，按 README 真跑一遍。如果跑不通，直接打回。

### 维度 3 — Security（安全性）

| 项 | 评分标准 |
|---|---|
| 无硬编码凭据 | 所有 API Key / 密码使用环境变量（`_env` 字段） |
| 示例数据脱敏 | 样例中的邮箱、URL、人名都是占位符（`example.com`、`Your Name`） |
| 依赖来源可信 | HTTP 拉取的来源 URL 必须是稳定公开源（不用个人博客 RSS） |
| 输出不泄漏 | LLM 输出不包含用户上下文变量的明文（避免 prompt injection 泄漏） |
| 默认推送最小化 | 如果有推送渠道，默认配置为 `enabled: false` |

**自动检查**:

```bash
# Maintainer 在 review 时可跑一遍
grep -rE "(password|token|secret|api_key|key).*=.*['\"](?!.*_env).*['\"]" modules/<your-agent>/ \
  --include="*.yaml" --include="*.md" --include="*.sh"
```

应返回空结果。

### 维度 4 — Portability（可移植性）

| 项 | 评分标准 |
|---|---|
| 平台注明 | README 明确说明主战场（Dify / Coze / n8n） |
| 避免平台绑死 | Prompt 文件独立于 workflow，可在不同平台复用 |
| LLM 模型无关 | 模板不应强依赖特定模型（除非场景必须，且要说明） |
| 多语言友好 | 输出语言通过 `settings.language` 或 prompt 参数可切换 |
| 配置与逻辑分离 | YAML 配置 vs prompt 逻辑 vs workflow 编排三层解耦 |

### 维度 5 — Maintainability（可维护性）

| 项 | 评分标准 |
|---|---|
| 版本约定 | 模板内有自己的 `Roadmap of this Module`，用 SemVer |
| 变更日志 | 重大修改通过 PR 描述 + CHANGELOG 体现 |
| 测试数据可回归 | sample input/output 可用于后续回归测试 |
| 无孤儿依赖 | 所有引用的外部 URL / API 在 README 里有"如何获取"说明 |
| 贡献者署名 | `configs/workflow.sample.yaml` 的 `agent.owner` 字段填写 |

---

## PR 审核流程

### 1. 作者自检（提 PR 前）

- [ ] 跑过 `Quick Start` 全流程，自己能跑通
- [ ] 在另一台设备或另一个账号上再跑一遍
- [ ] 对照本 checklist 逐项打勾
- [ ] PR 描述包含业务场景 + 测试数据 + 已知限制

### 2. 维护者 review（3-7 天内响应）

- [ ] 结构合规性检查（必备交付物）
- [ ] README 章节完整性检查
- [ ] 在一台干净环境上尝试 Quick Start
- [ ] 5 个维度逐一打分（1-5 分，总分 ≥ 20/25 通过）
- [ ] Security 维度任何一项不通过 → 直接打回

### 3. 合并后动作

- 默认标签 `tier: experimental`
- 加入 `modules/README.md` 模板索引
- 下一次 release 的 release notes 里提及

### 4. 升级到 Recommended

需要满足：

- [ ] 至少 3 位外部用户成功部署（有反馈记录）
- [ ] 连续 30 天无严重 bug
- [ ] 作者活跃响应 Issue

### 5. 升级到 Official

需要满足：

- [ ] Recommended 状态连续 90 天稳定
- [ ] 至少 1 个公开企业落地案例（case-studies/）
- [ ] 主要维护者由 Prax 核心团队成员担任

---

## 反模式（Anti-Patterns）

以下情况会被直接拒绝，不进入 review：

- ❌ "通用 AI 助手"定位（不对应明确业务场景）
- ❌ README 没有 Business Scenario 或写得很虚
- ❌ 明文硬编码 API Key / SMTP 密码
- ❌ 复制粘贴来的 Awesome-X 式简短介绍（没有可运行步骤）
- ❌ Prompt 明显指向玩具场景（"帮我查天气"、"帮我写一首诗"）
- ❌ 依赖收费 SaaS 作为必备前置（除非是主流基础设施如 OpenAI）
- ❌ 没有任何样例输入/输出文件
- ❌ `workflow/` 是空目录或只有一个 README 占位

---

## 如果你不确定自己的模板够不够格

在 PR 里选 `Draft PR`，打上标签 `review-request`，我们会提前反馈"方向对不对 / 还缺什么"，再决定是否正式走 review 流程。

这比你花几天完善一个"方向就错了"的模板要省时得多。

---

## 附录：模板质量自检一键命令

```bash
# 在你的模板根目录下跑：
cd modules/<your-agent>

# 1. 必备文件检查
for f in README.md configs/ prompts/ workflow/ docs/deployment.md output/; do
  [ -e "$f" ] && echo "✅ $f" || echo "❌ $f"
done

# 2. 硬编码凭据扫描
grep -rE "(password|token|secret|api_key).*=.*['\"][^_][^e][^n][^v]" . \
  --include="*.yaml" --include="*.md" 2>/dev/null | head

# 3. 占位符检查
grep -E "your-email@|example\.com|<your" README.md configs/ -r | head

echo "自检完成。"
```

结果应该是：所有必备文件显示 ✅，硬编码凭据扫描为空，占位符在 configs/ 中普遍存在（这是对的）。
