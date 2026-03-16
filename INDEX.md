# 全局软件系统知识文档库 — 索引

本索引按**业务知识、解决方案、需求分析**三大类组织。设计依据见 [DESIGN.md](./DESIGN.md)。

---

## 一、业务知识 (knowledge)

知识库主体，包含宪法层与四视角（业务、产品、技术、数据）。

### 1.1 宪法与治理层 (constitution)

| 入口 | 说明 |
|------|------|
| [knowledge/constitution/README.md](./knowledge/constitution/README.md) | 宪法层使命与核心组件 |
| [knowledge/constitution/adr/](./knowledge/constitution/adr/) | 架构决策记录 (ADR) |
| [knowledge/constitution/standards/](./knowledge/constitution/standards/) | 命名规范、ADR 模板等 |
| [knowledge/constitution/principles/](./knowledge/constitution/principles/) | 架构原则 |
| [knowledge/constitution/GLOSSARY.md](./knowledge/constitution/GLOSSARY.md) | 全局术语表 |

### 1.2 业务视角 (business)

| 入口 | 说明 |
|------|------|
| [knowledge/business/README.md](./knowledge/business/README.md) | 业务视角说明、层级与映射字段 |
| 层级 | 业务域 (BD) → 子域 (BSD) → 限界上下文 (BC) → 聚合 (AGG) |
| 示例 | [BD-ORDER](./knowledge/business/BD-ORDER/) → [BC-ORDER-MGMT](./knowledge/business/BD-ORDER/BSD-FULFILLMENT/BC-ORDER-MGMT/) → [AGG-ORDER](./knowledge/business/BD-ORDER/BSD-FULFILLMENT/BC-ORDER-MGMT/aggregates/AGG-ORDER.yaml) |

**关键映射字段**：限界上下文 → 技术 `implemented_by_app_id`；聚合 → 数据 `persisted_as_entity_ids`。

### 1.3 产品视角 (product)

| 入口 | 说明 |
|------|------|
| [knowledge/product/README.md](./knowledge/product/README.md) | 产品视角说明、层级与映射字段 |
| 层级 | 产品线 (PL) → 模块 (PM) → 功能 (FT) → 用例 (UC) |
| 示例 | [PL-ECOMMERCE](./knowledge/product/PL-ECOMMERCE/) → [PM-SHOPPING-CART](./knowledge/product/PL-ECOMMERCE/PM-SHOPPING-CART/) → [FT-ADD-TO-CART](./knowledge/product/PL-ECOMMERCE/PM-SHOPPING-CART/features/FT-ADD-TO-CART.yaml) |

**关键映射字段**：产品模块 → 业务 `relies_on_context_ids`；功能 → 技术 `invokes_api_ids`、`realizes_use_case_ids`。

### 1.4 技术视角 (technical)

| 入口 | 说明 |
|------|------|
| [knowledge/technical/README.md](./knowledge/technical/README.md) | 技术视角说明、层级与映射字段 |
| 层级 | 系统 (SYS) → 应用 (APP) → 微服务 (MS) |
| 示例 | [SYS-ECOMMERCE-BACKEND](./knowledge/technical/SYS-ECOMMERCE-BACKEND/) → [APP-ORDER-SERVICE](./knowledge/technical/SYS-ECOMMERCE-BACKEND/APP-ORDER/APP-ORDER-SERVICE.yaml) |

**关键映射字段**：应用 `repo_url`、`docs_manifest_path`、`service_ids`；限界上下文的 `implemented_by_app_id` 指向本层 APP。

### 1.5 数据视角 (data)

| 入口 | 说明 |
|------|------|
| [knowledge/data/README.md](./knowledge/data/README.md) | 数据视角说明、层级与映射字段 |
| 层级 | 数据存储 (DS) → 数据实体 (ENT) |
| 示例 | [DS-ORDER-MYSQL-PRIMARY](./knowledge/data/DS-ORDER-MYSQL-PRIMARY/) → [ENT-T_ORDER](./knowledge/data/DS-ORDER-MYSQL-PRIMARY/schema/ENT-T_ORDER.yaml) |

**关键映射字段**：数据实体 `maps_to_aggregate_id`；数据存储 `_meta.yaml` 中可写 `app_id`。

### 1.6 核心映射关系速查

| 关系方向 | 源 | 目标 | 关键字段/含义 |
|----------|-----|------|----------------|
| 落地实现 | 限界上下文 (BC) | 应用 (APP) | `implemented_by_app_id` |
| 需求支撑 | 产品模块 (PM) | 限界上下文 (BC) | `relies_on_context_ids` |
| 接口实现 | 功能 (FT) | API | `invokes_api_ids` |
| 数据持久化 | 聚合 (AGG) | 数据实体 (ENT) | `persisted_as_entity_ids` |
| 数据归属 | 数据实体 (ENT) | 微服务 (MS) | 通过 DS 的 app_id 或 ENT 的 owned_by |

### 1.7 贡献与规范

- [CONTRIBUTING.md](./CONTRIBUTING.md) — 如何新增/修改知识条目与 ADR  
- [DESIGN.md](./DESIGN.md) — 设计方案与演进路线  

---

## 二、解决方案 (solutions)

业务诉求的解决方案文档，对应 AI SDD 解决方案阶段产出。

| 入口 | 说明 |
|------|------|
| [solutions/README.md](./solutions/README.md) | 解决方案说明、命名与阶段规范 |
| 阶段规范 | [.ai/skills/sdd-solution/SKILL.md](./.ai/skills/sdd-solution/SKILL.md) |
| 文档模板 | [.ai/rules/solution/solution-template.md](./.ai/rules/solution/solution-template.md) |

- **输出**：`solutions/SOLUTION-{ID}.md`；可归档至 `solutions/archive/`。  
- **输入**：业务描述与知识库 (knowledge)。

---

## 三、需求分析 (analysis)

需求细化与 MVP 拆分文档，对应 AI SDD 需求分析阶段产出。

| 入口 | 说明 |
|------|------|
| [analysis/README.md](./analysis/README.md) | 需求分析说明、命名与阶段规范 |
| 阶段规范 | [.ai/skills/sdd-analysis/SKILL.md](./.ai/skills/sdd-analysis/SKILL.md) |
| 文档模板 | [.ai/rules/analysis/requirement-template.md](./.ai/rules/analysis/requirement-template.md) |

- **输出**：`analysis/REQUIREMENT-{ID}.md`；文档内 `parent` 指向对应 SOLUTION。  
- **输入**：解决方案 (solutions) 与知识库 (knowledge)。


---

## 四、需求交付 (requirements)

MVP 阶段化需求交付文档，对应 AI SDD 的需求落地与分阶段交付产出。

| 入口 | 说明 |
|------|------|
| [requirements/README.md](./requirements/README.md) | 需求交付阶段目标、结构说明 |
| 示例结构 | [requirements/REQUIREMENT-EXAMPLE/](./requirements/REQUIREMENT-EXAMPLE/) |
| 阶段规范 | [.ai/skills/sdd-prd/SKILL.md](./.ai/skills/sdd-prd/SKILL.md)、[sdd-design](./.ai/skills/sdd-design/SKILL.md)、[sdd-test](./.ai/skills/sdd-test/SKILL.md) |
| 文档模板 | [.ai/rules/requirement/](.ai/rules/requirement/) 下 prd-template、add-template、tdd-template |

- **输出**：`requirements/REQUIREMENT-{ID}/MVP-Phase-*/` 按阶段组织，含 `PRD.md`、`ADD.md`、`TDD.md` 等交付物。  
- **输入**：上游 analysis/REQUIREMENT-{ID}.md、solutions/SOLUTION-{ID}.md 及模板/规范。

> 详见 [requirements/README.md](./requirements/README.md) 获悉推荐目录结构和工作流。

---

## 五、需求规约 (specs)

服务/接口/数据等需求详细规约文档，供 solutions、analysis、requirements 阶段引用。

| 入口 | 说明 |
|------|------|
| [specs/](./specs/) | 规约目录入口（接口、数据、协议等） |
| 规范示例 | specs/ 下各类型子目录及 `README.md` |
| 推荐结构 | 参考 `knowledge/constitution/standards/` 相关规范 |

- **输出**：`specs/` 下按照接口、服务、实体等类型分目录组织的 `{xxx}.md` 或 `.yaml`。  
- **输入**：由需求分析、方案设计或需求交付阶段提出的规约需求。

> 需求规约有助于实现自动校验、映射追踪与下游交付标准化。
