---
name: sdd-test
description: >
  AI SDD 需求交付·测试设计阶段：基于产品需求与技术设计制定测试策略与测试计划，输出测试设计文档（TDD）。
  在用户执行 /sdd-test、编写测试设计/测试计划时使用。产出 docs/requirements/REQUIREMENT-{ID}/MVP-{N}/TDD-{ID}.md，模板见 .ai/rules/requirement/tdd-template.md。
---

# 测试设计阶段（sdd-test）

基于产品需求文档与技术设计文档，制定当前 MVP 的测试策略与测试计划，设计测试用例、测试数据与回归范围，输出测试设计文档（TDD），为后续开发与测试验证提供依据。

## 输入与输出

**输入**：产品需求（`docs/requirements/REQUIREMENT-{ID}/MVP-{N}/PRD-{ID}.md`）、架构设计（`.../ADD-{ID}.md`）、规约（`.../specs/`）  
**输出**：`docs/requirements/REQUIREMENT-{ID}/MVP-{N}/TDD-{ID}.md`（结构遵循 [.ai/rules/requirement/tdd-template.md](.ai/rules/requirement/tdd-template.md)）

## 工作流

### 步骤 1：测试策略与范围

- **角色**：quality-guardian / quality-engineer
- **任务**：确定测试层次（单元、集成、端到端）；确定测试范围与重点；确定测试环境要求；明确覆盖率目标（如单测行覆盖 ≥ 80%、接口覆盖 100%、核心场景 100%）。
- **产出**：测试策略与范围。

### 步骤 2：测试用例设计

- **角色**：quality-guardian / quality-engineer
- **任务**：基于用户故事的验收测试用例；基于 API 规约的接口测试用例；基于业务规则的规则测试用例；异常场景与边界条件测试用例；性能测试用例（如需）；基于影响面的回归测试用例清单。
- **产出**：测试用例清单。

### 步骤 3：测试数据与环境

- **角色**：quality-engineer
- **任务**：测试数据需求与准备方式（脚本生成/手工/生产脱敏）；测试环境要求（服务版本、数据库、中间件、外部依赖）。
- **产出**：测试数据与环境说明。

### 步骤 4：文档输出与评审

- **角色**：technical-writer + doc-updater
- **任务**：将步骤 1–3 整合为测试设计文档，严格采用 `.ai/rules/requirement/tdd-template.md` 的章节与格式；执行质量门禁自查。
- **产出**：`TDD-{ID}.md`。

## 质量门禁（test_design_quality_gate）

- **可追溯性**：测试用例可追溯到用户故事、API 规约与业务规则；回归范围可追溯到影响面。
- **完整性**：功能与非功能需求均有对应测试覆盖；进出标准明确。
- **一致性**：测试策略与产品需求、技术设计一致；用例与验收标准对齐。

## 参考

- 文档模板：`.ai/rules/requirement/tdd-template.md`
- 上游：PRD、ADD、specs/
