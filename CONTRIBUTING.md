# 贡献指南

欢迎参与维护全局软件系统知识文档库。请遵循以下约定，以保持单一事实源与映射一致性。

---

## 一、业务知识 (knowledge)

知识库主体（宪法层与四视角）的新增、修改与治理约定。

### 1.1 业务视角 (business)

- 在对应 **业务域 / 子域 / 限界上下文** 目录下新增或修改 `_meta.yaml`，确保包含 `id`、`name`、`description` 等。
- 新增**聚合**时，在对应 BC 的 `aggregates/` 下创建 `{AGG-ID}.yaml`，并填写 `persisted_as_entity_ids` 指向 data 中的实体 ID。
- 限界上下文若由某应用实现，在 BC 的 `_meta.yaml` 中设置 `implemented_by_app_id`。

### 1.2 产品视角 (product)

- 在对应 **产品线 / 模块** 下新增或修改 `_meta.yaml`。
- 新增**功能点**时，在模块的 `features/` 下创建 `{FT-ID}.yaml`，填写 `invokes_api_ids`、`realizes_use_case_ids`（如有）；模块依赖的业务能力用 `relies_on_context_ids`（在模块 `_meta.yaml`）。

### 1.3 技术视角 (technical)

- 在对应**系统**目录下新增或修改应用文件 `{APP-ID}.yaml`，必须包含 `repo_url`、`docs_manifest_path`、`service_ids`。
- 应用级仓库应在 `/docs` 下维护 `manifest.yaml`，便于系统级 CI/CD 同步。

### 1.4 数据视角 (data)

- 在对应**数据存储**的 `schema/` 下新增或修改 `{ENT-ID}.yaml`，填写字段、敏感级别；与业务聚合的映射使用 `maps_to_aggregate_id`。
- 数据存储的 `_meta.yaml` 可填写 `app_id` 表示归属应用。

### 1.5 架构决策记录 (ADR)

- 涉及跨域、跨系统或影响深远的架构变更，请在 **knowledge/constitution/adr/** 下新增 ADR。
- 文件名：`ADR-{序号}-{短标题}.md`，例如 `ADR-002-api-versioning.md`。
- 内容结构参考 [knowledge/constitution/standards/adr-template.md](./knowledge/constitution/standards/adr-template.md)：状态、上下文、决策、后果（正面/负面）。

### 1.6 ID 引用规则

- 所有跨文件、跨视角的关联**只写 ID**，不重复写名称或描述。
- 引用的 ID 必须在对应视角中存在对应文件或 `_meta` 定义；后续将提供 CLI 校验。

### 1.7 提交与评审

- 提交前请确认：新增 YAML 可被正常解析；ID 无拼写错误；映射关系与 DESIGN.md 中的约定一致。
- 修改已有实体时，注意检查是否有其他文件通过 ID 引用该实体，避免断链。

---

## 二、解决方案 (solutions)

业务诉求的解决方案文档的新增与维护。

- 在 **solutions/**（与 knowledge 平级）下创建 `SOLUTION-{ID}.md`，ID 建议为 `{YYYYMMDD}-{SEQ}` 或项目约定编号。
- 参考模板 [.ai/rules/solution/solution-template.md](./.ai/rules/solution/solution-template.md)，阶段规范见 [.ai/skills/sdx-solution/SKILL.md](./.ai/skills/sdx-solution/SKILL.md)。
- 已完结或废弃的解决方案可移入 **solutions/archive/**。

---

## 三、需求分析 (analysis)

需求分析文档的新增与维护。

- 在 **analysis/**（与 knowledge 平级）下创建 `REQUIREMENT-{ID}.md`，文档 frontmatter 中 `parent` 指向对应的 SOLUTION。
- 参考模板 [.ai/rules/analysis/requirement-template.md](./.ai/rules/analysis/requirement-template.md)，阶段规范见 [.ai/skills/sdx-analysis/SKILL.md](./.ai/skills/sdx-analysis/SKILL.md)。

---

## 四、需求交付 (requirements)

需求交付文档的新增与维护。

- 在 **requirements/** 下以 `REQUIREMENT-{ID}/` 创建目录，每个需求一个目录。
- 目录下按阶段（如 `MVP-Phase-1/`）新建子目录，子目录内可包含 PRD.md、ADD.md、TDD.md 等交付文档。
- 各文档应遵循项目约定的模板，确保与分析、解决方案等环节一致。

---

## 五、需求规约 (specs)

需求/服务规格文档的新增与维护。

- 在 **specs/** 目录下，按服务或规约类型创建子目录（如 `example-service/`）。
- 子目录内可维护接口说明、契约、数据字典等，具体结构和命名根据实际项目约定。
- 需求分析与解决方案文档可引用此处的规格以避免重复定义。

---

更多设计约定见 [DESIGN.md](./DESIGN.md)，索引与示例见 [INDEX.md](./INDEX.md)。
