# Prax Workflow - Rora 开发与 GitHub 发布流程

## 1. 目标

你要求的工作模式是：

1. `Prax` 作为一个**独立项目**保留可发布版本  
2. 后续所有日常修改都在 `Rora` 仓库内的 `01-Projects/06-Prax` 完成  
3. 只有“确认版本”时，才同步到 GitHub 独立仓库

这个流程的核心是：**开发与发布解耦**。

---

## 2. 目录约定

- 日常开发目录：`01-Projects/06-Prax/`
- 版本快照目录：`01-Projects/06-Prax/releases/<version>/`
- 自动化脚本目录：`01-Projects/06-Prax/scripts/`

示例：

```text
01-Projects/06-Prax/
  README.md
  WORKFLOW.md
  docs/
  modules/
  scripts/
    release-prax.sh
    sync-prax-to-github.sh
  releases/
    v0.1.0/
```

---

## 3. 标准发布 SOP（Standard Operating Procedure）

### Step 1 - 在 Rora 中迭代

你和 AI 在 `01-Projects/06-Prax` 下持续修改，不直接推 GitHub 独立仓库。

### Step 2 - 冻结版本（Release Snapshot）

当你确认一个版本可发布时，执行：

```bash
bash "01-Projects/06-Prax/scripts/release-prax.sh" v0.1.0
```

这会把当前 Prax 目录（排除 `releases/`）快照到：

`01-Projects/06-Prax/releases/v0.1.0/`

### Step 3 - 同步到独立仓库

执行同步脚本（先同步文件，不自动推送）：

```bash
bash "01-Projects/06-Prax/scripts/sync-prax-to-github.sh" \
  --version v0.1.0 \
  --target "$HOME/Projects/prax"
```

如果你确认无误，再加 `--push`：

```bash
bash "01-Projects/06-Prax/scripts/sync-prax-to-github.sh" \
  --version v0.1.0 \
  --target "$HOME/Projects/prax" \
  --push
```

> 说明：`--push` 需要目标仓库已配置好 `origin`。

---

## 4. 分支与版本策略建议

- Rora 内开发：不强制 tag（你的主知识仓）
- Prax 独立仓库：使用语义化版本（SemVer, Semantic Versioning）
  - `v0.x.y`：早期快速迭代
  - `v1.0.0`：稳定公开版本

推荐规则：

- 文档调整：`PATCH`（例如 `v0.1.0 -> v0.1.1`）
- 新模块增加：`MINOR`（例如 `v0.1.1 -> v0.2.0`）
- 架构变更：`MAJOR`（例如 `v0.9.0 -> v1.0.0`）

---

## 5. 发布前检查清单

在同步 GitHub 前，建议至少检查：

1. `README.md` 是否可直接被外部用户理解
2. `docs/vision.md` 与 `docs/roadmap.md` 是否一致
3. 每个模块是否可按文档跑通
4. 是否误带 Rora 私有内容（路径、个人隐私、非 Prax 资产）
5. License 是否已明确（MIT 或 CC BY-NC-SA 4.0）

---

## 6. 风险与防护

### 风险 1：推错仓库

- 原因：目标目录或 `origin` 误配置
- 防护：`sync-prax-to-github.sh` 默认不推送；只有显式加 `--push` 才执行

### 风险 2：把 Rora 非 Prax 内容同步出去

- 原因：手工复制路径时范围过大
- 防护：只从 `01-Projects/06-Prax` 或 `releases/<version>` 同步

### 风险 3：版本不可复现

- 原因：发布时未冻结快照
- 防护：先 `release-prax.sh` 再同步，保证每个版本有本地可追溯快照

