# sdd-init：SDD 开发环境初始化

在任意目录执行 `sdd-init`，可从本仓库（ai-sdd-docs）拉取内容并对**当前目录**完成 SDD 开发初始化，无需先克隆整个仓库到本地。

## 功能概述

1. **文档与知识库**：默认仅将仓库内 **knowledge** 目录拷贝到执行目录的 **docs**（即 `docs/` 下只包含 `knowledge/`）。可选 `--ds=full` 拷贝除 `.ai`、`.cursor`、`.git`、`scripts` 外的全部内容。
2. **AI 配置**：将仓库的 **.ai** 目录拷贝到执行目录的 **.ai**。默认**不**包含 `.ai/rules` 下的 **solution**、**analysis** 模板；可选 `--as=full` 包含全部 rules。
3. **Agent 的 command 与 skill**：从仓库的 **.ai/skills** 按选择安装到执行目录的 **.ai/skills**；并为选定的 **Agent**（Cursor、Trea 等）生成或拷贝配置：
   - **Cursor**：在 `.cursor` 下生成 Slash 命令说明（README），指向 .ai/skills。
   - **Trea**：若仓库存在 `.trea`，整目录拷贝到目标 `.trea`。
   - 其他 Agent：若仓库存在 `.<agent>`，同样整目录拷贝。通过 `--agents=cursor,trea` 或 `--agents=all` 选择要初始化的 Agent。

## 使用方式

### 方式一：从 Git 拉取并初始化（任意目录）

1、进入需要初始化的项目目录

```bash
cd /path/to/your-project
```

2、执行命令

```bash
curl -sL "https://raw.githubusercontent.com/oleewen/ai-sdd-docs/main/scripts/sdd-init-bootstrap.sh" | bash -s -- [sdd-init 选项]
```

- 脚本会先将仓库克隆到临时目录，再对**当前目录**执行初始化，完成后删除临时克隆。
- 若仓库地址不同，可设置环境变量后再执行：
  ```bash
  export GIT_REPO_URL=https://github.com/oleewen/ai-sdd-docs.git
  export GIT_REF=main   # 可选，默认使用默认分支
  curl -sL "..." | bash -s -- [选项]
  ```

### 方式二：已克隆本仓库时

在**目标项目目录**下执行（由你指定仓库根与目标）：

```bash
cd /path/to/your-project
REPO_ROOT=/path/to/ai-sdd-docs /path/to/ai-sdd-docs/scripts/sdd-init.sh [选项]
# 或指定目标目录
/path/to/ai-sdd-docs/scripts/sdd-init.sh [选项] /path/to/your-project
```

1、进入需要初始化的项目目录

```bash
cd ai-sdd-docs
```

2、执行命令

```bash
./scripts/sdd-init.sh [选项] project-path
```

## 选项说明

| 选项 | 说明 | 默认 |
|------|------|------|
| `--dd=DIR` | 文档根目录（相对目标目录） | `docs` |
| `--ds=SCOPE` | docs 范围：`knowledge-only`（仅 knowledge）\| `full`（仓库内除 .ai/.cursor/.git/scripts 外全部） | `knowledge-only` |
| `--ad=DIR` | .ai 配置目录（相对目标目录） | `.ai` |
| `--as=SCOPE` | .ai/rules 范围：`no-solution-analysis`（不含 solution、analysis）\| `full` | `no-solution-analysis` |
| `--agents=LIST` | 要初始化的 Agent：`cursor`、`trea` 或 `all`（默认: cursor） | `cursor` |
| `--cursor-dir=DIR` | Cursor 配置目录（相对目标目录） | `.cursor` |
| `--trea-dir=DIR` | Trea 配置目录（相对目标目录） | `.trea` |
| `--skills=LIST` | 要安装的 skills（写入 .ai/skills）：`all` 或逗号分隔，如 `sdd-solution,sdd-analysis,sdd-prd` | `all` |
| `--dry-run` | 仅打印将要执行的操作，不实际拷贝 | - |
| `-h`, `--help` | 显示帮助 | - |

可用的 skill 名称：`knowledge-build`, `sdd-solution`, `sdd-analysis`, `sdd-prd`, `sdd-design`, `sdd-test`。

## 示例

```bash
# 默认：仅 knowledge 到 docs，.ai 不含 solution/analysis rules，全部 skills
curl -sL "https://raw.githubusercontent.com/oleewen/ai-sdd-docs/main/scripts/sdd-init-bootstrap.sh" | bash -s

# 同时初始化 Cursor 与 Trea
curl -sL "..." | bash -s -- --agents=cursor,trea

# 文档范围改为完整；.ai 包含 solution、analysis 模板
curl -sL "..." | bash -s -- --ds=full --as=full

# 文档放到 content/，只安装部分 skills
curl -sL "..." | bash -s -- --dd=content --skills=sdd-solution,sdd-analysis,sdd-prd

# 先预览再执行
curl -sL "..." | bash -s -- --dry-run
```

## 初始化后的目录结构（目标目录，默认）

- `docs/`：仅 **knowledge/**（知识库）。使用 `--ds=full` 时与仓库除 .ai/各 Agent 目录外一致。
- `.ai/`：规则、模板、agents、workflows、context 等；默认**不**包含 `rules/solution`、`rules/analysis`。**skills** 在 `.ai/skills/<name>/SKILL.md`，按 `--skills` 安装。
- `.cursor/`：生成的 `README.md`（Slash 命令索引，指向 .ai/skills）。仅当 `--agents` 包含 cursor 时生成。
- `.trea/`：从仓库拷贝的 Trea Agent 配置（仅当 `--agents` 包含 trea 且仓库存在 `.trea` 时）。

Cursor 中可通过 `/命令名` 或 `@技能名` 使用已安装的 skills；Trea 等 Agent 使用各自目录下的配置。
