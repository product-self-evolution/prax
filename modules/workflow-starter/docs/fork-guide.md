# workflow-starter - Fork Guide

当你想构建一个 Prax 里还不存在的 Agent 时（例如"客户反馈分析"、"竞品追踪"），从这个骨架派生是最快路径。

---

## 什么时候用 workflow-starter

| 场景 | 适合 | 不适合 |
|---|---|---|
| 有明确业务场景但缺起点 | ✅ | |
| 想学 Dify workflow 的标准结构 | ✅ | |
| 已经有明确模板（如 ai-digest） | | ❌（直接 fork 那个模板） |
| 想做纯 Chatbot | | ❌（Dify 的 Chatflow 更适合） |

---

## 5 步派生一个新 Agent

### Step 1 - 确定场景和命名

先写清楚：

- Agent 要做什么业务（一句话）
- 典型输入是什么
- 期望输出是什么

命名规则：`kebab-case`，例如 `competitor-tracker`, `feedback-analyzer`。

### Step 2 - 复制目录

```bash
cp -r modules/workflow-starter modules/<your-agent-name>
cd modules/<your-agent-name>
```

### Step 3 - 改配置文件

**`configs/workflow.yaml`**:
- 修改 `agent.id`, `agent.name`, `agent.description`
- 修改 `input.type` 和 `input.fields`
- 按需调整 `pipeline` 中的节点

### Step 4 - 写业务 prompt

在 `prompts/` 下创建你的 prompt 文件：

```bash
mkdir -p prompts
touch prompts/main.prompt.md
```

参考 `modules/ai-digest/prompts/summarizer.prompt.md` 的结构：

- 明确角色定位
- 严格输出格式
- 自检清单

### Step 5 - 在 Dify 搭建

基于 `workflow/workflow-starter.dify.yaml` 骨架：

1. 复制到 `workflow/<your-agent-name>.dify.yaml`
2. 在 Dify 创建新 Workflow App，按骨架连线
3. 把 `prompts/main.prompt.md` 粘贴到 LLM 节点的 System Prompt
4. 如果需要增加节点（retrieval / scoring / iteration），按下方"常见节点组合"添加

---

## 常见节点组合（按场景选用）

### 场景 A：简单生成型 Agent（默认）

```
Start → Validate → Reason (LLM) → Postprocess → End
```

适合：文本改写、问答、生成、格式化。

### 场景 B：检索增强型 Agent（RAG）

```
Start → Validate → Retrieve (Knowledge Base) → Reason (LLM) → Postprocess → End
```

适合：知识问答、文档摘要、企业内 RAG。

### 场景 C：评分筛选型 Agent（类似 ai-digest）

```
Start → Fetch → Parse → Iterate → Score (LLM) → Filter → Summarize (LLM) → Deliver → End
```

适合：信息聚合、批量处理、内容筛选。

### 场景 D：多步推理型 Agent（ReAct）

```
Start → Plan (LLM) → Iterate Tools → Reflect (LLM) → End
```

适合：工具调用、复杂任务、Agent 自主决策。

---

## 命名和元数据约定

每个新 Agent 应该在 README.md 顶部标注：

```markdown
> **类型**: Enterprise Agent Template
> **阶段**: Phase X
> **主战场平台**: Dify（可选 Coze / n8n）
> **预计部署时间**: <= 30 分钟
```

并在 `configs/workflow.yaml` 的 `agent` 字段保持一致。

---

## 如何把你的 Agent 贡献回 Prax

1. fork prax 主仓库
2. 在 `modules/<your-agent-name>/` 下完成你的 Agent
3. 确保通过 `modules/ai-digest` 同级的质量标准：
   - 有 README、configs、prompts、workflow、docs
   - 有至少一份样例输入和样例输出
   - 有 30 分钟部署指南
4. 提 PR，描述业务场景 + 部署数据

官方会把通过审核的模板加入 `marketplace/`（Phase 3 阶段）。
