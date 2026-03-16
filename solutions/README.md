# solutions — 解决方案文档

本目录用于记录**业务诉求的解决方案文档**，对应 AI SDD 解决方案阶段产出。从业务描述中提取结构化需求、评估影响面、识别冲突并形成解决方案，输出以 `SOLUTION-{ID}.md` 命名的文档。

## 定位与用途

- **输入**：业务需求描述（邮件、会议纪要、工单等）、知识库（`knowledge/`）、规约（`specs/`）。
- **输出**：解决方案文档 `SOLUTION-{ID}.md`，作为需求分析阶段的输入。
- **归档**：已完结或 superseded 的解决方案可移入 [archive/](./archive/) 便于检索历史。

## 方案索引表

| 解决方案编号         | 标题               | 关联需求                | 状态     | 更新时间      |
|---------------------|--------------------|------------------------|----------|--------------|
| SOLUTION-20240601-01 | 示例方案标题（可替换） | REQUIREMENT-20240525-01 | 草稿     | 2024-06-01   |

> 注：如有新增解决方案，请在此表中登记，便于查阅与追溯。

## 命名与ID

- **文件名**：`SOLUTION-{ID}.md`，其中 `{ID}` 建议为 `{YYYYMMDD}-{SEQ}` 或项目约定的唯一编号。
- **文档内**：frontmatter 中 `id` 与文件名一致，可含 `parent`、`dependencies` 等关联字段。

## 规范与模板

- **阶段目标与工作流**：见 [.ai/skills/sdd-solution/SKILL.md](../.ai/skills/sdd-solution/SKILL.md)（需求提取 → 影响面评估 → 冲突识别 → 方案制定 → 文档输出与评审）。
- **文档模板**：见 [.ai/rules/solution/solution-template.md](../.ai/rules/solution/solution-template.md)。

## 集成关系

- 解决方案会引用或影响 **knowledge/** 下 business、product、technical、data 中的实体；影响面评估需与知识库保持一致。
- 需求分析文档（`analysis/REQUIREMENT-{ID}.md`）通过 `parent` 关联到本目录下的 SOLUTION。

