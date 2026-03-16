---
name: sdx-design
description: >
  技术方案设计：基于产品需求与架构/领域文档进行技术方案设计，输出 ADD 与规约文件。
  在用户执行 /sdx-design、编写 ADD 与规约时使用。产出见 .ai/rules/requirement/add-template.md；测试设计见 /sdx-test。
---

# 方案设计阶段（sdx-design）

基于产品需求文档，结合系统架构与领域模型，进行技术方案设计，输出架构设计文档（ADD）和规约文件（Spec），为后续测试设计与开发阶段提供技术蓝图。

## 输入与输出

**输入**：需求分析当前 MVP 章节（`analysis/REQUIREMENT-{ID}.md`）、产品需求（`docs/requirements/REQUIREMENT-{ID}/MVP-{N}/PRD-{ID}.md`）、系统架构与 ADR（`knowledge/technical/`、`knowledge/constitution/adr/`）、领域模型（`knowledge/business/`）、现有规约（`specs/`）  
**输出**：ADD `docs/requirements/REQUIREMENT-{ID}/MVP-{N}/ADD-{ID}.md`、规约 `.../specs/`

## 工作流（四步）

### 步骤 1：架构设计

- **角色**：architect + system-architect
- **任务**：系统/服务架构与调用关系、接口与事件设计、领域模型与领域事件、数据架构与迁移、发布与回滚方案；Mermaid 架构图。
- **产出**：架构设计要点。

### 步骤 2：详细设计

- **角色**：backend-architect
- **任务**：集成与容器架构、API 签名与容错/幂等、核心类图与状态机、逻辑伪代码/流程图、事务与并发；库表 DDL、索引与分页、缓存策略；安全与可观测性。
- **产出**：详细设计文档。

### 步骤 3：规约生成

- **角色**：technical-writer + doc-updater
- **任务**：按服务生成 API/领域/数据/集成规约（YAML），路径规范 `docs/requirements/REQUIREMENT-{ID}/MVP-{N}/specs/{service-name}/`。
- **产出**：规约文件。

### 步骤 4：文档输出与评审

- **角色**：technical-writer + doc-updater
- **任务**：将步骤 1–3 整合为 ADD 文档，采用 `.ai/rules/requirement/add-template.md`；执行质量门禁。
- **产出**：ADD-{ID}.md、specs/。

## 质量门禁（design_quality_gate）

- **可追溯性**：API/数据变更可追溯到产品需求与功能需求；规约可追溯到技术设计。
- **完整性**：用户故事均有实现方案，API 有完整规约，数据有 DDL/迁移。
- **一致性**：与现有架构、领域模型、API 规范及规约格式一致。
- **可行性**：方案在现有基础设施上可实现，性能与安全满足非功能需求。

## 参考

- ADD 模板：`.ai/rules/requirement/add-template.md`
- 上游：PRD、`analysis/`、`knowledge/`、`specs/`
