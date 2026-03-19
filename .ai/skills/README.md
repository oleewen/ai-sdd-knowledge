# Cursor 项目配置

## Slash 命令（Skills）

| 命令 | 说明 |
|------|------|
| `/document-indexing` | 文档索引：为代码库/文档库生成面向下游 AI 的 Index Guide（拓扑/结构/精读三模式，七段标准输出，零幻觉路径精确）。 |
| `/agent-guide` | 生成/更新根目录 `AGENTS.md` 与 `README.md`；① document-indexing 产出 Index → ② agent-guide 产出 AGENTS/README |
| `/knowledge-build` | 知识库构建：① document-indexing 产出 Index → ② agent-guide 产出 AGENTS/README → ③ 按 Index 选择性阅读并写入 knowledge → ④ 验证。 |
| `/knowledge-upgrade` | 应用级知识库增量升级：① 应用内 document-indexing → ③ 按 applications/INDEX 与应用 knowledge 格式选择性阅读并回写 → ④ 验证（无 AGENTS/README 第二阶段）。 |
| `/knowledge-archive` | 归档 applications/ 知识库变更；将应用侧有效信息按 system/knowledge 与 CONTRIBUTING 规范上行补充系统库（联邦 SSOT、仅 ID 引用）。 |

在 Chat 中输入 `/` 后选择对应命令即可调用（如 `/agent-guide`）；或使用 `@技能名`（如 `@agent-guide`、`@sdx-solution`）将 Skill 作为上下文附加。

**说明**：斜杠命令由 `.cursor/skills/<技能名>/SKILL.md` 提供，文件夹名即命令名（如 `skills/agent-guide` → `/agent-guide`）。
