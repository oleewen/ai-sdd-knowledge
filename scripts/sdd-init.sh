#!/usr/bin/env bash
# sdd-init：从 ai-sdd-docs 仓库初始化当前目录的 SDD 开发环境
# 用法（在仓库内）：REPO_ROOT=/path/to/ai-sdd-docs ./scripts/sdd-init.sh [选项] [目标目录]
# 用法（bootstrap）：由 scripts/sdd-init-bootstrap.sh 拉取仓库后调用，目标目录默认为当前目录

set -euo pipefail

# 默认值
REPO_ROOT="${REPO_ROOT:-}"
TARGET_DIR="${TARGET_DIR:-$(pwd)}"
DOCS_DIR="${DOCS_DIR:-docs}"
AI_DIR="${AI_DIR:-.ai}"
CURSOR_DIR="${CURSOR_DIR:-.cursor}"
TREA_DIR="${TREA_DIR:-.trea}"
SKILLS_OPT="${SKILLS_OPT:-all}"
DRY_RUN="${DRY_RUN:-0}"
# 要初始化的 Agent 列表：cursor,trea 或 all（仓库中存在的均初始化）
AGENTS_OPT="${AGENTS_OPT:-cursor}"
# 默认仅初始化知识库（docs 下只有 knowledge）；设为 full 则拷贝仓库内除 .ai/各 Agent 目录/.git/scripts 外全部
DOCS_SCOPE="${DOCS_SCOPE:-knowledge-only}"
# 默认不包含 .ai/rules 下的 solution、analysis 模板
AI_RULES_SCOPE="${AI_RULES_SCOPE:-no-solution-analysis}"
GIT_REPO_URL="${GIT_REPO_URL:-https://github.com/oleewen/ai-sdd-docs.git}"

# 支持的 Agent：目录名与仓库内 .<name> 对应
SUPPORTED_AGENTS=(cursor trea)
# 已知的 Skill 列表（与 .ai/skills 下目录名一致）
CURSOR_SKILLS=(knowledge-build sdd-solution sdd-analysis sdd-prd sdd-design sdd-test)

usage() {
  cat <<'USAGE'
用法: sdd-init [选项] [目标目录]

从 ai-sdd-docs 仓库初始化当前（或指定）目录的 SDD 开发环境：
  1) 将仓库内知识库拷贝到目标目录的 docs（默认仅 knowledge 目录）
  2) 将 .ai 目录拷贝到目标目录的 {ai-dir}（默认不包含 rules 下的 solution、analysis）
  3) 将选定的 skills 安装到 {ai-dir}/skills，并为选定的 Agent（Cursor、Trea 等）生成/拷贝配置

选项:
  --dd=DIR            文档根目录，相对目标目录（默认: docs）
  --ds=SCOPE          docs 范围：knowledge-only（默认）| full
  --ad=DIR            .ai 配置目录（默认: .ai）
  --as=SCOPE          .ai/rules 范围：no-solution-analysis（默认）| full
  --agents=LIST       要初始化的 Agent，逗号分隔或 all（默认: cursor）
                      可选: cursor, trea（仓库中存在的才会处理）
  --cursor-dir=DIR    Cursor 配置目录（默认: .cursor）
  --trea-dir=DIR      Trea 配置目录（默认: .trea）
  --skills=LIST       要安装的 skills，逗号分隔或 all（默认: all）
  --dry-run           仅打印将要执行的操作，不实际拷贝
  -h, --help          显示此帮助

环境变量（供 bootstrap 使用）:
  REPO_ROOT           仓库根目录（克隆后的路径），必须设置
  TARGET_DIR          目标目录，未传参时也可由此指定
  DRY_RUN=1           与 --dry-run 等价
USAGE
}

cp_safe() {
  local src="$1" dst="$2"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] 拷贝: $src -> $dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
}

# 解析参数
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dd=*)           DOCS_DIR="${1#*=}"; shift ;;
    --ds=*)           DOCS_SCOPE="${1#*=}"; shift ;;
    --ad=*)           AI_DIR="${1#*=}"; shift ;;
    --as=*)           AI_RULES_SCOPE="${1#*=}"; shift ;;
    --agents=*)       AGENTS_OPT="${1#*=}"; shift ;;
    --cursor-dir=*)   CURSOR_DIR="${1#*=}"; shift ;;
    --trea-dir=*)     TREA_DIR="${1#*=}"; shift ;;
    --skills=*)       SKILLS_OPT="${1#*=}"; shift ;;
    --dry-run)        DRY_RUN=1; shift ;;
    -h|--help)        usage; exit 0 ;;
    -*)
      echo "未知选项: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

# 若由 bootstrap 调用，REPO_ROOT 已设置；否则尝试用脚本所在目录推断仓库根
if [[ -z "$REPO_ROOT" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  if [[ ! -d "$REPO_ROOT/.ai" ]]; then
    echo "错误: 未设置 REPO_ROOT 且当前推断的仓库根目录不存在 .ai: $REPO_ROOT" >&2
    echo "请通过 bootstrap 方式运行，或设置 REPO_ROOT 后重试。" >&2
    exit 1
  fi
fi

if [[ ! -d "$REPO_ROOT" ]]; then
  echo "错误: 仓库根目录不存在: $REPO_ROOT" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
DOCS_ABS="$TARGET_DIR/$DOCS_DIR"
AI_ABS="$TARGET_DIR/$AI_DIR"
CURSOR_ABS="$TARGET_DIR/$CURSOR_DIR"
TREA_ABS="$TARGET_DIR/$TREA_DIR"

# 解析要启用的 Agent 列表
declare -a ENABLED_AGENTS
if [[ "$AGENTS_OPT" == "all" ]]; then
  for a in "${SUPPORTED_AGENTS[@]}"; do
    if [[ "$a" == "cursor" ]]; then
      ENABLED_AGENTS+=("cursor")
    else
      [[ -d "$REPO_ROOT/.$a" ]] && ENABLED_AGENTS+=("$a")
    fi
  done
else
  IFS=',' read -ra ENABLED_AGENTS <<< "$AGENTS_OPT"
fi

echo "sdd-init 配置:"
echo "  仓库根: $REPO_ROOT"
echo "  目标目录: $TARGET_DIR"
echo "  文档目录: $DOCS_DIR -> $DOCS_ABS (范围: $DOCS_SCOPE)"
echo "  .ai 目录: $AI_DIR -> $AI_ABS (rules: $AI_RULES_SCOPE)"
echo "  Agents: ${ENABLED_AGENTS[*]} (Cursor: $CURSOR_DIR, Trea: $TREA_DIR)"
echo "  Skills: $SKILLS_OPT"
[[ "$DRY_RUN" == "1" ]] && echo "  [dry-run 模式]"
echo ""

# 1) 拷贝到 docs：默认仅 knowledge，可选 full
echo ">>> 1/3 拷贝文档与知识库到 $DOCS_DIR ..."
if [[ "$DOCS_SCOPE" == "full" ]]; then
  # 排除 .ai、各 Agent 目录、.git、scripts
  for item in "$REPO_ROOT"/*; do
    [[ -e "$item" ]] || continue
    name="$(basename "$item")"
    case "$name" in
      .ai|.cursor|.trea|.git|scripts) continue ;;
      *) cp_safe "$item" "$DOCS_ABS/$name" ;;
    esac
  done
  for item in "$REPO_ROOT"/.*; do
    [[ -e "$item" ]] || continue
    name="$(basename "$item")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    case "$name" in
      .ai|.cursor|.trea|.git) continue ;;
      *) cp_safe "$item" "$DOCS_ABS/$name" ;;
    esac
  done
else
  # 默认：仅 knowledge
  if [[ -d "$REPO_ROOT/knowledge" ]]; then
    cp_safe "$REPO_ROOT/knowledge" "$DOCS_ABS/knowledge"
  else
    echo "  警告: 仓库内无 knowledge 目录，跳过." >&2
  fi
fi
echo "  完成."
echo ""

# 2) 拷贝 .ai 到目标 .ai；默认排除 rules/solution、rules/analysis；不拷贝 skills（由步骤 3 按 --skills 安装）
echo ">>> 2/3 拷贝 .ai 配置到 $AI_DIR ..."
if [[ "$DRY_RUN" != "1" ]]; then
  for item in "$REPO_ROOT/.ai"/*; do
    [[ -e "$item" ]] || continue
    name="$(basename "$item")"
    [[ "$name" == "skills" ]] && continue
    cp_safe "$item" "$AI_ABS/$name"
  done
  for item in "$REPO_ROOT/.ai"/.*; do
    [[ -e "$item" ]] || continue
    name="$(basename "$item")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    cp_safe "$item" "$AI_ABS/$name"
  done
else
  for item in "$REPO_ROOT/.ai"/*; do
    [[ -e "$item" ]] || continue
    name="$(basename "$item")"
    [[ "$name" == "skills" ]] && continue
    echo "  [dry-run] 拷贝: $item -> $AI_ABS/$name"
  done
  echo "  [dry-run] 实际执行时将排除 .ai/skills（由步骤 3 按 --skills 安装）"
fi
if [[ "$AI_RULES_SCOPE" == "no-solution-analysis" ]] && [[ "$DRY_RUN" != "1" ]]; then
  [[ -d "$AI_ABS/rules/solution" ]] && rm -rf "$AI_ABS/rules/solution"
  [[ -d "$AI_ABS/rules/analysis" ]] && rm -rf "$AI_ABS/rules/analysis"
  echo "  已排除 .ai/rules/solution 与 .ai/rules/analysis"
elif [[ "$AI_RULES_SCOPE" == "no-solution-analysis" ]] && [[ "$DRY_RUN" == "1" ]]; then
  echo "  [dry-run] 将排除 .ai/rules/solution 与 .ai/rules/analysis"
fi
echo "  完成."
echo ""

# 3) 安装 skills 到 .ai/skills，并为各 Agent 生成/拷贝配置
echo ">>> 3/3 安装 skills 并为 Agent（Cursor、Trea 等）生成/拷贝配置 ..."
if [[ "$DRY_RUN" != "1" ]]; then
  mkdir -p "$AI_ABS/skills"
fi

# 3a) 从仓库 .ai/skills 按 --skills 安装到目标 .ai/skills
declare -a INSTALL_SKILLS
if [[ "$SKILLS_OPT" == "all" ]]; then
  INSTALL_SKILLS=("${CURSOR_SKILLS[@]}")
else
  IFS=',' read -ra INSTALL_SKILLS <<< "$SKILLS_OPT"
fi

for skill in "${INSTALL_SKILLS[@]}"; do
  skill="${skill// /}"
  [[ -z "$skill" ]] && continue
  src_skill="$REPO_ROOT/.ai/skills/$skill"
  if [[ ! -d "$src_skill" ]]; then
    echo "  跳过不存在的 skill: $skill"
    continue
  fi
  cp_safe "$src_skill" "$AI_ABS/skills/$skill"
  echo "  已安装 skill: $skill"
done

# 3b) 按 Agent 分别处理
for agent in "${ENABLED_AGENTS[@]}"; do
  agent="${agent// /}"
  [[ -z "$agent" ]] && continue
  case "$agent" in
    cursor)
      # 生成 .cursor/README.md（Slash 命令索引，指向 .ai/skills）
      CURSOR_README="$CURSOR_ABS/README.md"
      if [[ "$DRY_RUN" != "1" ]]; then
        mkdir -p "$CURSOR_ABS"
        cat > "$CURSOR_README" <<'HEADER'
# Cursor 项目配置

## Slash 命令（Skills，位于 .ai/skills）

| 命令 | 说明 |
|------|------|
HEADER
        for skill in "${INSTALL_SKILLS[@]}"; do
          skill="${skill// /}"
          [[ -z "$skill" ]] && continue
          skill_file="$AI_ABS/skills/$skill/SKILL.md"
          if [[ -f "$skill_file" ]]; then
            desc=$(awk '/^description:/{getline; gsub(/^[ \t]+|[ \t]+$/,""); print; exit}' "$skill_file" 2>/dev/null)
            [[ -z "$desc" ]] && desc="见 .ai/skills/$skill/SKILL.md"
            echo "| \`/$skill\` | $desc |" >> "$CURSOR_README"
          fi
        done
        cat >> "$CURSOR_README" <<'FOOTER'

在 Chat 中输入 `/` 后选择对应命令即可调用；或使用 `@技能名` 将 Skill 作为上下文附加。
FOOTER
        echo "  Cursor: 已生成 $CURSOR_DIR/README.md"
      else
        echo "  [dry-run] Cursor: 将生成 $CURSOR_DIR/README.md"
      fi
      ;;
    trea)
      # 若仓库存在 .trea，整目录拷贝到目标
      if [[ -d "$REPO_ROOT/.trea" ]]; then
        cp_safe "$REPO_ROOT/.trea" "$TREA_ABS"
        echo "  Trea: 已拷贝 .trea -> $TREA_DIR"
      elif [[ "$DRY_RUN" == "1" ]]; then
        echo "  [dry-run] Trea: 仓库无 .trea，跳过"
      else
        echo "  Trea: 仓库无 .trea，跳过"
      fi
      ;;
    *)
      # 其他 Agent：若仓库有 .<agent> 则整目录拷贝
      if [[ -d "$REPO_ROOT/.$agent" ]]; then
        dst_agent_abs="$TARGET_DIR/.$agent"
        cp_safe "$REPO_ROOT/.$agent" "$dst_agent_abs"
        echo "  $agent: 已拷贝 .$agent -> .$agent"
      else
        echo "  $agent: 仓库无 .$agent，跳过"
      fi
      ;;
  esac
done
echo "  完成."
echo ""

echo "sdd-init 已完成。"
echo "  - 文档与知识库: $DOCS_ABS"
echo "  - AI 配置: $AI_ABS"
echo "  - Skills: $AI_ABS/skills/"
echo "  - Agents: ${ENABLED_AGENTS[*]}"
