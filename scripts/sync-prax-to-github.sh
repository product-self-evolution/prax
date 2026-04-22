#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Prax sync script: Rora -> standalone -> optional GitHub push
#
# 目的：
# - 把 Rora 里的 Prax（或某个 release 快照）同步到独立仓库目录
# - 默认只同步文件，不自动 push，降低误操作风险
#
# 风险控制策略：
# - 必须显式传入 --push 才会执行 git push
# - 建议先在目标目录人工检查，再决定是否 push
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRAX_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VERSION=""
TARGET=""
PUSH="false"

usage() {
  cat <<EOF
用法:
  $0 --version <vX.Y.Z> --target <standalone_path> [--push]

示例:
  $0 --version v0.1.0 --target "\$HOME/Projects/prax"
  $0 --version v0.1.0 --target "\$HOME/Projects/prax" --push
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="${2:-}"
      shift 2
      ;;
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --push)
      PUSH="true"
      shift
      ;;
    *)
      echo "未知参数: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$VERSION" || -z "$TARGET" ]]; then
  usage
  exit 1
fi

if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "错误: version 必须符合 SemVer 格式，例如 v0.1.0"
  exit 1
fi

SOURCE_DIR="$PRAX_ROOT/releases/$VERSION"
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "错误: 版本快照不存在: $SOURCE_DIR"
  echo "请先执行: bash \"$PRAX_ROOT/scripts/release-prax.sh\" $VERSION"
  exit 1
fi

mkdir -p "$TARGET"

# 把指定版本快照同步到独立目录
rsync -a --delete \
  --exclude ".git/" \
  "$SOURCE_DIR/" "$TARGET/"

echo "✅ 已同步版本 $VERSION 到独立目录: $TARGET"

if [[ "$PUSH" == "true" ]]; then
  if [[ ! -d "$TARGET/.git" ]]; then
    echo "错误: 目标目录不是 git 仓库: $TARGET"
    echo "请先在目标目录执行 git init 并配置 origin。"
    exit 1
  fi

  (
    cd "$TARGET"

    # 使用单独 commit 消息，明确发布来源
    git add .
    if git diff --cached --quiet; then
      echo "ℹ️ 没有检测到可提交变更，跳过 commit/push。"
      exit 0
    fi

    git commit -m "release: $VERSION from Rora snapshot"

    # 仅当显式 --push 时执行推送
    git push
    echo "🚀 已推送到 GitHub（请确认远端和分支配置正确）。"
  )
else
  echo "ℹ️ 未执行 push（默认安全模式）。如需推送，请添加 --push。"
fi
