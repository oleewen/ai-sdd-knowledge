#!/usr/bin/env bash
# knowledge-init：将 applications/app-APPNAME 初始化到目标工程文档目录
# 运行要求：Bash 5+

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$SCRIPT_DIR/sdx-config.sh" ]]; then
  printf '错误: 缺少配置文件 %s\n' "$SCRIPT_DIR/sdx-config.sh" >&2
  exit 1
fi

# shellcheck disable=SC1091
source "$SCRIPT_DIR/sdx-config.sh"
sdx_require_bash5

log() { printf '%s\n' "$*" >&2; }
error() { log "错误: $*"; exit 1; }
warn() { log "警告: $*"; }
info() { log "信息: $*"; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

expand_user_path() {
  local p="$1"
  case "$p" in
    "~") echo "$HOME" ;;
    "~/"*) echo "$HOME/${p#~/}" ;;
    *) echo "$p" ;;
  esac
}

abs_path() {
  local p
  p="$(expand_user_path "$1")"
  if [[ "$p" != /* ]]; then
    p="$(pwd)/$p"
  fi
  if [[ -d "$p" ]]; then
    (cd "$p" && pwd)
  else
    echo "$p"
  fi
}

strip_trailing_slash() {
  local p="$1"
  while [[ "$p" != "/" && "$p" == */ ]]; do
    p="${p%/}"
  done
  echo "$p"
}

ensure_dir() {
  if [[ "${DRY_RUN:-0}" == "0" ]]; then
    mkdir -p "$1"
  fi
}

copy_dir() {
  local src="$1" dst="$2"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log "[dry-run] 拷贝目录: $src -> $dst"
    return 0
  fi

  if [[ -e "$dst" ]]; then
    rm -rf "$dst"
  fi
  ensure_dir "$(dirname "$dst")"
  if have_cmd rsync; then
    rsync -a "$src"/ "$dst"/
  else
    mkdir -p "$dst"
    cp -R "$src"/. "$dst"/
  fi
}

sanitize_app_id() {
  # 从目录名推导 APP ID：大写，非字母数字转 -
  local raw="$1"
  raw="${raw##*/}"
  raw="$(echo "$raw" | tr '[:lower:]' '[:upper:]')"
  raw="$(echo "$raw" | sed -E 's/[^A-Z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
  if [[ -z "$raw" ]]; then
    echo "APP-APPNAME"
  else
    echo "APP-$raw"
  fi
}

detect_git_repo_ref_or_empty() {
  local target="$1"
  if ! have_cmd git; then
    echo ""
    return 0
  fi
  if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # 优先使用远端仓库地址（更符合 repo_url 语义）；缺失时退回到本地仓库根目录
    local remote_url git_root
    remote_url="$(git -C "$target" config --get remote.origin.url 2>/dev/null || true)"
    if [[ -n "$remote_url" ]]; then
      echo "$remote_url"
      return 0
    fi

    git_root="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null || true)"
    if [[ -n "$git_root" ]]; then
      echo "$(abs_path "$git_root")"
      return 0
    fi

    echo ""
    return 0
  fi
  echo ""
}

detect_git_root_path_or_empty() {
  local target="$1"
  if ! have_cmd git; then
    echo ""
    return 0
  fi
  if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local git_root
    git_root="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null || true)"
    if [[ -n "$git_root" ]]; then
      echo "$(abs_path "$git_root")"
      return 0
    fi
  fi
  echo ""
}

docs_path_relative_to_git_root_or_abs() {
  local git_root="$1"
  local docs_abs="$2"

  if [[ -z "$git_root" ]]; then
    echo "$docs_abs"
    return 0
  fi

  git_root="$(strip_trailing_slash "$git_root")"
  docs_abs="$(strip_trailing_slash "$docs_abs")"

  case "$docs_abs" in
    "$git_root")
      echo "/"
      return 0
      ;;
    "$git_root"/*)
      local rel="${docs_abs#"$git_root"}"
      # rel 以 "/" 开头，符合现有 docs_manifest_path 约定（如 /docs/manifest.yaml）
      echo "$rel"
      return 0
      ;;
    *)
      echo "$docs_abs"
      return 0
      ;;
  esac
}

usage() {
  cat <<'EOF'
用法: knowledge-init [选项] <目标工程文档目录>

说明:
  将本仓库 applications/app-APPNAME 目录下所有目录和文件，拷贝到目标工程的文档目录下。

  参数 <目标工程文档目录> 示例:
    ~/workspace/test/docs
  其中：
    - 目标工程为 ~/workspace/test
    - 文档目录为 docs（即目标工程下的 docs 目录）

  两种模式:
  - standalone（默认）：仅对目标工程做拷贝
  - central：在本仓库 system/INDEX.md 记录目标工程路径与文档目录，并在 system/knowledge/technical/SYS-ECOMMERCE-BACKEND/ 下新建 APP-<工程名>/ 模板

选项:
  --mode=MODE         模式：standalone（默认）| central（也支持缩写：s | c）
  --app-id=APP-ID     中央模式下写入技术视角的 APP ID（默认由工程目录推导）
  --agents=LIST      Agent 列表（支持多选）：cursor|trea|all，且可用逗号分隔如 cursor,trea（默认: cursor）
  --force             若目标目录已存在则覆盖（默认覆盖；此开关仅用于显式表达）
  --dry-run           预览模式（不落盘）
  -h, --help          显示帮助

环境变量:
  REPO_ROOT           本仓库根目录（默认自动探测）
EOF
}

REPO_ROOT="${REPO_ROOT:-}"
MODE="${MODE:-standalone}"
DOCS_ABS=""
TARGET_DIR=""
APP_ID_OPT="${APP_ID_OPT:-}"
AGENTS_OPT="${AGENTS_OPT:-cursor}"
DRY_RUN="${DRY_RUN:-0}"
FORCE="${FORCE:-0}"

parse_args() {
  while (( $# > 0 )); do
    case "$1" in
      --mode=*)
        MODE="${1#*=}"
        shift
        ;;
      --mode)
        shift
        MODE="${1:-}"
        shift
        ;;
      --app-id=*)
        APP_ID_OPT="${1#*=}"
        shift
        ;;
      --app-id)
        shift
        APP_ID_OPT="${1:-}"
        shift
        ;;
      --agents=*)
        AGENTS_OPT="${1#*=}"
        shift
        ;;
      --agents)
        shift
        local parts=()
        while (( $# > 0 )); do
          case "$1" in
            -*) break ;;
            *) parts+=("$1"); shift ;;
          esac
        done
        if (( ${#parts[@]} == 0 )); then
          error "缺少 --agents 值（如 cursor,trea 或 cursor trea）"
        fi
        AGENTS_OPT="$(IFS=','; echo "${parts[*]}")"
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --force)
        FORCE=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      -*)
        error "未知选项: $1"
        ;;
      *)
        DOCS_ABS="$1"
        shift
        ;;
    esac
  done
}

declare -a enabled_agents=()

parse_agents() {
  if [[ "$AGENTS_OPT" == "all" ]]; then
    enabled_agents=("${SDX_SUPPORTED_AGENTS[@]}")
    return 0
  fi

  IFS=',' read -ra enabled_agents <<< "$AGENTS_OPT"
  local a
  for a in "${enabled_agents[@]}"; do
    [[ "$a" == "cursor" || "$a" == "trea" ]] || error "无效 agent: $a（只支持 cursor、trea、all）"
  done
}

init_repo_root() {
  if [[ -z "$REPO_ROOT" ]]; then
    REPO_ROOT="$(abs_path "$SCRIPT_DIR/..")"
  fi
  [[ -d "$REPO_ROOT/applications/app-APPNAME" ]] || error "未找到模板目录: $REPO_ROOT/applications/app-APPNAME"
  [[ -d "$REPO_ROOT/system" ]] || error "未找到 system 目录: $REPO_ROOT/system"
}

validate() {
  [[ -n "$DOCS_ABS" ]] || { usage; exit 2; }

  DOCS_ABS="$(strip_trailing_slash "$(abs_path "$DOCS_ABS")")"
  TARGET_DIR="$(abs_path "$(dirname "$DOCS_ABS")")"
  if [[ ! -d "$TARGET_DIR" ]]; then
    info "目标工程目录不存在，将创建: $TARGET_DIR"
    ensure_dir "$TARGET_DIR"
  fi

  case "$MODE" in
    standalone|s) MODE="standalone" ;;
    central|c) MODE="central" ;;
    *) error "无效模式: $MODE（必须是 standalone/central 或 s/c）" ;;
  esac
}

copy_file() {
  local src="$1" dst="$2"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log "[dry-run] 拷贝文件: $src -> $dst"
    return 0
  fi
  ensure_dir "$(dirname "$dst")"
  cp "$src" "$dst"
}

install_agent_skills_and_rules() {
  local agent agent_dir
  for agent in "${enabled_agents[@]}"; do
    case "$agent" in
      cursor) agent_dir="$TARGET_DIR/.cursor" ;;
      trea)   agent_dir="$TARGET_DIR/.trea" ;;
      *) error "未知 agent: $agent" ;;
    esac

    info ">>> 安装 ${agent} Agent 的 skills 与 rules..."
    info "  agent 目录: $agent_dir"

    ensure_dir "$agent_dir"
    ensure_dir "$agent_dir/skills"
    ensure_dir "$agent_dir/rules"

    # skills：只安装 agent-* / document-* / knowledge-*，默认不安装 sdx-*
    shopt -s nullglob
    local -a skill_dirs=()
    skill_dirs+=("$REPO_ROOT/.ai/skills"/agent-*)
    skill_dirs+=("$REPO_ROOT/.ai/skills"/document-*)
    skill_dirs+=("$REPO_ROOT/.ai/skills"/knowledge-*)
    if [[ "${#skill_dirs[@]}" -eq 0 ]]; then
      warn "未找到匹配的 skills（agent-*/document-*/knowledge-*）"
    else
      local sd
      for sd in "${skill_dirs[@]}"; do
        local skill
        skill="$(basename "$sd")"
        copy_dir "$sd" "$agent_dir/skills/$skill"
      done
    fi

    # 将 skills 的说明文件拷贝到 agent 的 skills 根目录
    if [[ -f "$REPO_ROOT/.ai/skills/README.md" ]]; then
      copy_file "$REPO_ROOT/.ai/skills/README.md" "$agent_dir/skills/README.md"
    fi
    # rules：按用户要求同时拷贝到 agent/rules，便于就近查阅
    sync_rules_filtered "$REPO_ROOT/.ai/rules" "$agent_dir/rules"
  done
}

sync_dir_contents() {
  local src="$1" dst="$2"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log "[dry-run] 同步目录内容: $src/ -> $dst/"
    return 0
  fi
  ensure_dir "$dst"
  if have_cmd rsync; then
    rsync -a "$src"/ "$dst"/
  else
    cp -R "$src"/. "$dst"/
  fi
}

sync_rules_filtered() {
  # 同步 rules，过滤掉 solution/analysis 两个目录
  local src_rules="$1"
  local dst_rules="$2"

  [[ -d "$src_rules" ]] || return 0

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log "[dry-run] 同步规则（过滤 solution/analysis）：$src_rules/ -> $dst_rules/"
    local item base
    shopt -s nullglob
    for item in "$src_rules"/*; do
      base="$(basename "$item")"
      if [[ "$base" == "solution" || "$base" == "analysis" ]]; then
        continue
      fi
      if [[ -d "$item" ]]; then
        log "[dry-run] 拷贝目录: $item -> $dst_rules/$base"
      else
        log "[dry-run] 拷贝文件: $item -> $dst_rules/$base"
      fi
    done
    return 0
  fi

  # 覆盖目标 rules，确保过滤生效（避免历史残留 solution/analysis）
  rm -rf "$dst_rules"
  ensure_dir "$dst_rules"

  local item base
  shopt -s nullglob
  for item in "$src_rules"/*; do
    base="$(basename "$item")"
    if [[ "$base" == "solution" || "$base" == "analysis" ]]; then
      continue
    fi
    if [[ -d "$item" ]]; then
      copy_dir "$item" "$dst_rules/$base"
    else
      copy_file "$item" "$dst_rules/$base"
    fi
  done
}

copy_app_template() {
  info ">>> 初始化应用知识库到目标工程..."
  info "  目标工程: $TARGET_DIR"
  info "  文档目录: $DOCS_ABS"

  ensure_dir "$DOCS_ABS"
  sync_dir_contents "$REPO_ROOT/applications/app-APPNAME" "$DOCS_ABS"
  info "  拷贝完成"
}

ensure_central_app_template() {
  local project_name app_id app_dir app_yaml docs_abs repo_or_path repo_ref git_root docs_manifest_path
  project_name="$(basename "$TARGET_DIR")"
  if [[ -n "$APP_ID_OPT" ]]; then
    app_id="$APP_ID_OPT"
  else
    app_id="$(sanitize_app_id "$project_name")"
  fi

  app_dir="$REPO_ROOT/system/knowledge/technical/SYS-ECOMMERCE-BACKEND/${app_id}"
  app_yaml="$app_dir/${app_id}.yaml"
  docs_abs="$DOCS_ABS"

  repo_ref="$(detect_git_repo_ref_or_empty "$TARGET_DIR")"
  git_root="$(detect_git_root_path_or_empty "$TARGET_DIR")"
  if [[ -n "$repo_ref" ]]; then
    repo_or_path="$repo_ref"
  else
    repo_or_path="$TARGET_DIR"
  fi
  docs_manifest_path="$(docs_path_relative_to_git_root_or_abs "$git_root" "$docs_abs")"

  info ">>> 中央知识库模式：登记并生成技术视角模板..."
  info "  APP ID: $app_id"
  info "  工程记录: $repo_or_path"
  info "  文档目录: $docs_abs"

  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] 创建目录: $app_dir"
    log "[dry-run] 写入文件: $app_yaml"
  else
    mkdir -p "$app_dir"
    # 始终写入（模板应反映最新接入信息）
    cat > "$app_yaml" <<EOF
# ${app_id} 应用注册信息
id: "${app_id}"
name: "${project_name}"
description: "由 knowledge-init 生成的应用注册模板"
repo_url: "${repo_or_path}"
docs_manifest_path: "${docs_manifest_path}"
service_ids: []
EOF
  fi

  upsert_system_index_record "$app_id" "$repo_or_path" "$docs_abs"
  info "  中央模式处理完成"
}

upsert_system_index_record() {
  local app_id="$1" repo_or_path="$2" docs_abs="$3"
  local idx="$REPO_ROOT/system/INDEX.md"
  [[ -f "$idx" ]] || error "未找到 system/INDEX.md: $idx"

  local marker_start="## 六、中央知识库接入工程"
  local marker_table_header="| APP ID | 工程路径（Git 或绝对路径） | 文档目录 |"
  local marker_table_sep="|--------|---------------------------|----------|"
  local row="| ${app_id} | ${repo_or_path} | ${docs_abs} |"

  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] 更新索引登记: $idx"
    log "[dry-run] 追加/替换行: $row"
    return 0
  fi

  if ! grep -qF "$marker_start" "$idx"; then
    {
      printf '\n'
      printf '%s\n\n' "$marker_start"
      printf '%s\n' "本节用于在本仓库（中央知识库）登记各目标工程的接入信息，便于追溯与映射。"
      printf '\n'
      printf '%s\n' "$marker_table_header"
      printf '%s\n' "$marker_table_sep"
      printf '%s\n' "$row"
      printf '\n'
    } >> "$idx"
    return 0
  fi

  if grep -qF "| ${app_id} |" "$idx"; then
    local tmp="${idx}.tmp"
    awk -v app="| ${app_id} |" -v newline="$row" '
      index($0, app)==1 { print newline; next }
      { print }
    ' "$idx" > "$tmp"
    mv "$tmp" "$idx"
    return 0
  fi

  local tmp="${idx}.tmp"
  awk -v header="$marker_table_header" -v sep="$marker_table_sep" -v newline="$row" '
    { print }
    $0==sep { print newline }
  ' "$idx" > "$tmp"
  mv "$tmp" "$idx"
}

main() {
  parse_args "$@"
  init_repo_root
  validate

  copy_app_template
  if [[ "$MODE" == "central" ]]; then
    ensure_central_app_template
  fi

  parse_agents
  install_agent_skills_and_rules

  info "完成：knowledge-init"
}

main "$@"

