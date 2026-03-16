#!/usr/bin/env bash
# sdx-init bootstrap：在任意目录执行，从 Git 拉取 ai-sdd-docs 到临时目录并对当前目录执行 sdx-init
# 用法: curl -sL https://raw.githubusercontent.com/ORG/ai-sdd-docs/main/scripts/sdx-init-bootstrap.sh | bash -s -- [sdx-init 选项]
# 或: bash scripts/sdx-init-bootstrap.sh [选项]

set -euo pipefail

GIT_REPO_URL="${GIT_REPO_URL:-https://github.com/oleewen/ai-sdd-docs.git}"
GIT_REF="${GIT_REF:-HEAD}"
TMP_DIR="${TMPDIR:-/tmp}"
CLONE_DIR="$TMP_DIR/ai-sdd-docs-$$"
TARGET_DIR="$(pwd)"

# 可选：通过环境变量指定仓库，例如 GIT_REPO_URL=... GIT_REF=main bash bootstrap.sh
# 命令行参数全部传给 sdx-init（如 --dd=docs --skills=all）
EXTRA_ARGS=("$@")

echo "sdx-init bootstrap: 拉取仓库并初始化当前目录"
echo "  仓库: $GIT_REPO_URL (ref: $GIT_REF)"
echo "  目标: $TARGET_DIR"
echo ""

if [[ -d "$CLONE_DIR" ]]; then
  rm -rf "$CLONE_DIR"
fi

if [[ "$GIT_REF" == "HEAD" || -z "$GIT_REF" ]]; then
  git clone --depth 1 "$GIT_REPO_URL" "$CLONE_DIR" || {
    echo "错误: 无法克隆 $GIT_REPO_URL，请检查网络或设置 GIT_REPO_URL" >&2
    exit 1
  }
else
  git clone --depth 1 --single-branch -b "$GIT_REF" "$GIT_REPO_URL" "$CLONE_DIR" || {
    echo "错误: 无法克隆 $GIT_REPO_URL (ref: $GIT_REF)，请检查网络或 GIT_REPO_URL、GIT_REF" >&2
    exit 1
  }
fi

cleanup() {
  rm -rf "$CLONE_DIR"
}
trap cleanup EXIT

if [[ ! -f "$CLONE_DIR/scripts/sdx-init.sh" ]]; then
  echo "错误: 仓库中未找到 scripts/sdx-init.sh" >&2
  exit 1
fi

export REPO_ROOT="$CLONE_DIR"
export TARGET_DIR
bash "$CLONE_DIR/scripts/sdx-init.sh" "${EXTRA_ARGS[@]}"
