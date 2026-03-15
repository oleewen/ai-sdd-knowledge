---
name: sdd-analysis
description: >
  AI SDD 需求分析阶段：基于解决方案文档与知识库进行深度研究、需求细化、MVP 拆分与依赖/风险评估，输出需求分析文档。
  在用户执行 /sdd-analysis、编写需求分析文档、或进行方案→需求分析时使用。输出至 analysis/REQUIREMENT-{ID}.md，模板见 .ai/rules/analysis/requirement-template.md。
---

# 需求分析阶段（sdd-analysis）

基于解决方案文档和系统说明文档进行深度研究与探索，将高层解决方案细化为具体的、可执行的需求分析，合理拆分为多个 MVP 阶段，确保每个 MVP 具备独立交付价值。

## 输入与输出

**输入**：解决方案文档（`solutions/`）、知识库（`knowledge/`）、规约（`specs/`）  
**输出**：`analysis/REQUIREMENT-{ID}.md`（结构遵循 [.ai/rules/analysis/requirement-template.md](.ai/rules/analysis/requirement-template.md)）

## 工作流（五步）

按顺序执行以下步骤，每步产出作为下一步输入；最终文档需通过质量门禁。

### 步骤 1：深度研究与探索

- **角色**：requirements-analyst
- **任务**：业务领域研究（领域边界、核心概念与规则、跨领域交互）；现有实现探索（可复用组件、技术债务）；行业实践参考；边界场景探索（高并发、一致性、幂等性等）。
- **产出**：深度研究报告。

### 步骤 2：需求细化与建模

- **角色**：requirements-analyst
- **任务**：功能需求细化（输入/处理/输出、优先级 P0–P3）；非功能需求明确（性能、可用性、安全、可观测性、兼容性）；业务规则提取；数据需求分析（实体、生命周期、一致性）。
- **产出**：细化需求清单。

### 步骤 3：MVP 拆分与规划

- **角色**：requirements-analyst
- **任务**：按独立业务价值、可独立部署、依赖单向原则拆分 MVP；为每个 MVP 定义范围、功能清单、验收标准与工作量；按业务价值、技术依赖与风险排序。
- **产出**：MVP 拆分方案。

### 步骤 4：依赖分析与风险评估

- **角色**：requirements-analyst + quality-guardian/quality-engineer
- **任务**：分析 MVP 间功能/数据/接口及外部依赖；评估技术/业务/进度/质量风险；为高风险项制定应对与监控策略。
- **产出**：依赖与风险评估报告。

### 步骤 5：文档输出与评审

- **角色**：technical-writer + doc-updater
- **任务**：将步骤 1–4 的产出整合为需求分析文档，严格采用 `.ai/rules/analysis/requirement-template.md` 的章节与格式；执行质量门禁自查。
- **产出**：`analysis/REQUIREMENT-{ID}.md`。

## 质量门禁（requirement_quality_gate）

提交前必须满足：

- **可追溯性**：每个功能需求可追溯到解决方案中的业务目标，每个 MVP 范围可追溯到功能需求清单。
- **完整性**：功能需求覆盖解决方案中所有业务场景，非功能需求完整定义，每个 MVP 有明确验收标准。
- **可行性**：MVP 拆分粒度合理、可独立交付，依赖关系清晰可管理，工作量估算合理。
- **一致性**：需求描述与解决方案文档、现有系统文档一致且无矛盾。

## 参考

- 文档模板：`.ai/rules/analysis/requirement-template.md`
- 上游方案：`solutions/`；知识库：`knowledge/`；规约：`specs/`
