---
name: sdx-solution
description: >
  解决方案制定：从业务描述提取结构化需求，评估影响面，识别并化解冲突，制定解决方案并输出解决方案文档。
  在用户执行 /sdx-solution、编写解决方案文档、或进行需求→方案分析时使用。输出至 solutions/SOLUTION-{ID}.md，模板见 .ai/rules/solution/solution-template.md。
---

# 解决方案阶段（sdx-solution）

从海量、模糊甚至矛盾的业务描述中提取结构化需求，结合现存系统状态，评估业务影响面，识别潜在冲突，确立业务目标和解决思路，输出高质量的解决方案文档。

## 输入与输出

**输入**：业务需求描述（邮件、会议纪要、工单等）、`knowledge/`、`specs/`、可选 `solutions/archive/`  
**输出**：`solutions/SOLUTION-{ID}.md`（结构遵循 [.ai/rules/solution/solution-template.md](.ai/rules/solution/solution-template.md)）

## 工作流（五步）

按顺序执行以下步骤，每步产出作为下一步输入；最终文档需通过质量门禁。

### 步骤 1：需求提取与结构化

- **角色**：solution-analyst 或 requirements-analyst
- **任务**：从业务描述中萃取——业务背景与动机、业务目标与期望价值、核心业务场景、用户角色、关键约束、时间与优先级；标注歧义与待澄清项；区分功能/非功能、新增/变更/修复、业务/技术需求。
- **产出**：结构化需求提取报告。

### 步骤 2：影响面评估与分析

- **角色**：solution-analyst/requirements-analyst + quality-guardian/quality-engineer
- **任务**：列出受影响功能及影响程度（高/中/低），标注影响传播路径（直接→间接）。
- **产出**：影响面评估报告。

### 步骤 3：冲突识别与化解

- **角色**：solution-analyst 或 requirements-analyst
- **任务**：识别业务冲突（与现有规则、进行中需求、上下游流程）与系统冲突（模型、契约、资源竞争）；对每项冲突给出化解方案及成本/风险评估。
- **产出**：冲突分析报告。

### 步骤 4：方案制定与评估

- **角色**：solution-analyst 或 requirements-analyst
- **任务**：明确可度量业务目标与价值；阐述整体解决思路、关键决策与备选对比；评估技术/资源可行性及风险；界定范围边界与 MVP-Phase 拆分建议。
- **产出**：解决方案核心内容。

### 步骤 5：文档输出与评审

- **角色**：technical-writer + doc-updater
- **任务**：将步骤 1–4 的产出整合为解决方案文档，严格采用 `.ai/rules/solution/solution-template.md` 的章节与格式；执行质量门禁自查。
- **产出**：`solutions/SOLUTION-{ID}.md`。

## 质量门禁（solution_quality_gate）

提交前必须满足：

- **完整性**：业务背景与动机清晰，目标可度量，影响面覆盖所有受影响服务，冲突分析完整，解决思路明确，范围边界清晰。
- **一致性**：需求与现有系统文档无矛盾，影响面与架构文档一致。
- **可行性**：技术方案在现有架构下可实现，资源估算合理。
- **可追溯性**：每个业务目标可追溯到原始需求，每个影响点可追溯到具体服务/模块。

## 参考

- 文档模板：`.ai/rules/solution/solution-template.md`
- 现存知识库：`knowledge/`；规约：`specs/`；历史方案：`solutions/archive/`
