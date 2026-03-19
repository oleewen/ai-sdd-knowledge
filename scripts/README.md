# sdx-init：SDD 开发环境初始化

运行要求：`Bash 5+`。

在任意目录执行 `sdx-init`，可从本仓库（ai-sdd-knowledge）拉取内容并对**当前目录**完成 SDD 开发初始化，无需先克隆整个仓库到本地。

## 功能概述

1. **文档与知识库**：支持两种模式（`--mode=standalone` | `federation`，默认 **standalone**）。
   - **独立模式**：仓库 **system** 拷贝到 **docs/system**；应用知识库为 **docs/application**（单目录，无 `app-APPNAME`）。
   - **联邦模式**：**system** 拷贝到 **docs/system**；**applications** 拷贝到 **docs/applications**，并在其下新建 `app-<工程目录名>`；在目标 **.gitignore** 中忽略文档根目录（如 `docs`），并将当前仓库 **.git** 拷贝至文档根。
2. **AI 配置**：将仓库的 **.ai** 目录拷贝到执行目录的 **.ai**。默认**不**包含 `.ai/rules` 下的 **solution**、**analysis** 模板；可选 `--as=full` 包含全部 rules。
3. **Agent 的 command 与 skill**：从仓库的 **.ai/skills** 按选择安装到各 Agent 目录的 skills；并为选定的 **Agent**（Cursor、Trea 等）生成或拷贝配置：
   - **Cursor**：在 `.cursor` 下生成 Slash 命令说明（README）及 skills。
   - **Trea**：若仓库存在 `.trea`，整目录拷贝到目标 `.trea` 并安装 skills。
   - 其他 Agent：若仓库存在 `.<agent>`，同样整目录拷贝。通过 `--agents=cursor,trea` 或 `--agents=all` 选择要初始化的 Agent。

若目标路径（如 `docs/system`、`docs/applications`、`.ai`、`.cursor`、`.trea`）已存在，**默认会警告并退出**；使用 `--force` 会提示确认后覆盖。

## 使用方式

### 方式一：从 Git 拉取并初始化（任意目录）

1、进入需要初始化的项目目录

```bash
cd /path/to/your-project
```

2、执行命令

```bash
curl -sL "https://raw.githubusercontent.com/oleewen/ai-sdd-knowledge/main/scripts/sdx-init-bootstrap.sh" | bash -s -- [sdx-init 选项]
```

- 脚本会先将仓库克隆到临时目录，再对**当前目录**执行初始化，完成后删除临时克隆。
- 若仓库地址不同，可设置环境变量后再执行：
  ```bash
  export GIT_REPO_URL=https://github.com/oleewen/ai-sdd-knowledge.git
  export GIT_REF=main   # 可选，默认使用默认分支
  curl -sL "..." | bash -s -- [选项]
  ```

### 方式二：已克隆本仓库时

在**目标项目目录**下执行（由你指定仓库根与目标）：

```bash
cd /path/to/your-project
REPO_ROOT=/path/to/ai-sdd-knowledge /path/to/ai-sdd-knowledge/scripts/sdx-init.sh [选项]
# 或指定目标目录
/path/to/ai-sdd-knowledge/scripts/sdx-init.sh [选项] /path/to/your-project
```

1、进入需要初始化的项目目录

```bash
cd ai-sdd-knowledge
```

2、执行命令

```bash
./scripts/sdx-init.sh [选项] project-path
```

## 选项说明

| 选项 | 说明 | 默认 |
|------|------|------|
| `--mode=MODE` | 初始化模式：`standalone`（独立，应用目录为 docs/application）\| `federation`（联邦，为 docs/applications + app-APPNAME，并写 .gitignore、拷贝 .git） | `standalone` |
| `--dd=DIR` | system 文档目录（相对目标目录）；应用目录为同级的 `application` 或 `applications`（由 mode 决定） | `docs/system` |
| `--ds=SCOPE` | docs 范围：`knowledge` \| `full`（均拷贝仓库 system 目录内容） | `knowledge` |
| `--ad=DIR` | .ai 配置目录（相对目标目录） | `.ai` |
| `--as=SCOPE` | .ai/rules 范围：`no-solution-analysis`（不含 solution、analysis）\| `full` | `no-solution-analysis` |
| `--agents=LIST` | 要初始化的 Agent：`cursor`、`trea` 或 `all`（默认: cursor） | `cursor` |
| `--cursor-dir=DIR` | Cursor 配置目录（相对目标目录） | `.cursor` |
| `--trea-dir=DIR` | Trea 配置目录（相对目标目录） | `.trea` |
| `--skills=LIST` | 要安装的 skills（写入 Agent 目录的 skills/）：`all` 或逗号分隔。未指定时仅安装 agent/knowledge 相关（`knowledge-*`、`agent-*`），默认排除 sdx-*；`all` 安装全部 | 仅 agent/knowledge |
| `--force` | 若目标路径（docs、.ai、.cursor、.trea 等）已存在，则提示确认后覆盖；未指定时若已存在则警告并退出 | - |
| `--dry-run` | 仅打印将要执行的操作，不实际拷贝 | - |
| `-h`, `--help` | 显示帮助 | - |


## 示例

```bash
# 默认（独立模式）：仓库 system 到 docs/system、application 到 docs/application，.ai 不含 solution/analysis rules
curl -sL "https://raw.githubusercontent.com/oleewen/ai-sdd-knowledge/main/scripts/sdx-init-bootstrap.sh" | bash -s

# 联邦模式：docs/applications + app-<工程名>，并忽略文档根、拷贝 .git
curl -sL "..." | bash -s -- --mode=federation

# 同时初始化 Cursor 与 Trea
curl -sL "..." | bash -s -- --agents=cursor,trea

# 文档范围改为完整；.ai 包含 solution、analysis 模板
curl -sL "..." | bash -s -- --ds=full --as=full

# 文档放到 content/，只安装部分 skills
curl -sL "..." | bash -s -- --dd=content --skills=sdx-solution,sdx-analysis,sdx-prd

# 目标目录已有 docs/system、.ai 等时强制覆盖（会提示确认）
curl -sL "..." | bash -s -- --force

# 先预览再执行
curl -sL "..." | bash -s -- --dry-run
```

---

# knowledge-init：初始化应用知识库模板

运行要求：`Bash 5+`。

将本仓库 `applications/app-APPNAME` 目录下所有目录和文件，拷贝到**目标工程**的文档目录下。

目标工程与文档目录用一个参数表示，例如 `~/workspace/test/docs`：
- 目标工程：`~/workspace/test`
- 文档目录：`docs`

## 使用方式

```bash
# 拷贝到 <目标工程>/<文档目录>/（示例：/path/to/your-project/docs）
./scripts/knowledge-init.sh /path/to/your-project/docs

# 中央知识库模式：额外在本仓库 system/INDEX.md 登记工程接入信息，
# 并在 system/knowledge/technical/SYS-ECOMMERCE-BACKEND/ 下生成 APP-<工程名>/ 模板
./scripts/knowledge-init.sh --mode=central /path/to/your-project/docs

# 模式缩写（等价于 --mode=standalone / --mode=central）
./scripts/knowledge-init.sh --mode=s /path/to/your-project/docs
./scripts/knowledge-init.sh --mode=c /path/to/your-project/docs

# 预览模式（不落盘）
./scripts/knowledge-init.sh --dry-run --mode=central /path/to/your-project/docs
```

## 选项说明

| 选项 | 说明 | 默认 |
|------|------|------|
| `--mode=MODE` | `standalone`（仅拷贝）\| `central`（登记到 system 并生成技术视角模板）；也支持缩写 `s` \| `c` | `standalone` |
| `--app-id=APP-ID` | 中央模式下写入技术视角的 APP ID（不传则由工程目录推导） | - |
| `--agents=LIST` | 要安装的 Agent（支持多选）：`cursor` \| `trea` \| `all`；可用逗号分隔如 `cursor,trea`（也支持 `--agents cursor trea`） | `cursor` |
| `--dry-run` | 仅打印将要执行的操作，不实际拷贝/写入 | - |

## 初始化后的目录结构（目标工程）

- 在 `<目标工程>/<文档目录>/` 下同步 `applications/app-APPNAME/` 的目录和文件（作为应用知识库根）。
- 若选择 `--agents=cursor`：在 `<目标工程>/.cursor/` 下安装 `skills/` 与 `rules/`（skills 仅安装 `agent-*`/`document-*`/`knowledge-*`），并拷贝 `.cursor/README.md`（如存在）。
- 若选择 `--agents=trea`：在 `<目标工程>/.trea/` 下安装 `skills/` 与 `rules/`（skills 仅安装 `agent-*`/`document-*`/`knowledge-*`），并拷贝 `.trea/README.md`（如存在）。

说明：rules 会过滤掉 `.ai/rules/solution/` 与 `.ai/rules/analysis/` 两个目录。

中央模式（`--mode=central`）额外会更新本仓库 `system/INDEX.md`，并在 `system/knowledge/technical/SYS-ECOMMERCE-BACKEND/` 下生成 `APP-<工程名>/` 注册模板。
