# Cursor 项目配置

## Slash 命令（Skills）

| 命令 | 说明 |
|------|------|
| `/knowledge-build` | 知识库构建 / 逆向工程知识库：项目探索 → 生成 AGENTS.md/README → 按 knowledge 目录结构构建知识库 → 质量验证。 |
| `/sdx-solution` | 解决方案阶段：需求提取与结构化 → 影响面评估 → 冲突识别与化解 → 方案制定与评估 → 文档输出与评审；产出 `solutions/SOLUTION-{ID}.md`，模板见 `.ai/rules/solution/solution-template.md`。 |
| `/sdx-analysis` | 需求分析阶段：深度研究与探索 → 需求细化与建模 → MVP 拆分与规划 → 依赖分析与风险评估 → 文档输出与评审；产出 `analysis/REQUIREMENT-{ID}.md`，模板见 `.ai/rules/analysis/requirement-template.md`。 |
| `/sdx-prd` | 需求交付·产品需求阶段：业务流程 → 用户故事与场景 → 用例建模 → 功能模块与交互设计 → 文档输出与评审；产出 `docs/requirements/.../PRD-{ID}.md`，模板见 `.ai/rules/requirement/prd-template.md`。 |
| `/sdx-design` | 需求交付·方案设计阶段：架构设计 → 详细设计 → 规约生成 → 文档输出与评审；产出 ADD、specs，模板见 `.ai/rules/requirement/add-template.md`。 |
| `/sdx-test` | 需求交付·测试设计阶段：测试策略与范围 → 测试用例设计 → 测试数据与环境 → 文档输出与评审；产出 TDD-{ID}.md，模板见 `.ai/rules/requirement/tdd-template.md`。 |

在 Chat 中输入 `/` 后选择对应命令即可调用；或使用 `@技能名`（如 `@sdx-solution`、`@sdx-analysis`、`@sdx-prd`、`@sdx-design`、`@sdx-test`）将 Skill 作为上下文附加。
