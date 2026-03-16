---
name: sdd-prd
description: >
  产品需求说明：将需求分析中当前 MVP 的需求转化为详细产品方案与功能设计（业务流程、用户故事、用例、功能模块、交互与业务规则）。
  在用户执行 /sdd-prd、编写 PRD 文档时使用。产出 docs/requirements/REQUIREMENT-{ID}/MVP-{N}/PRD-{ID}.md，模板见 .ai/rules/requirement/prd-template.md。
---

# 产品需求阶段（sdd-prd）

将需求分析中当前 MVP 阶段的需求转化为详细的产品方案和功能设计，包括完整的业务流程、用户故事、用例、功能模块划分、用户交互设计和业务规则定义。

## 输入与输出

**输入**：需求分析文档中当前 MVP 章节（`analysis/REQUIREMENT-{ID}.md`）、产品文档（`knowledge/product/`）  
**输出**：`docs/requirements/REQUIREMENT-{ID}/MVP-{N}/PRD-{ID}.md`（结构遵循 [.ai/rules/requirement/prd-template.md](.ai/rules/requirement/prd-template.md)）

## 工作流（五步）

### 步骤 1：业务流程设计

- **角色**：product_designer / ux-designer
- **任务**：绘制主流程与分支/异常流程；标注参与角色、输入输出、业务规则；跨系统交互与异步回调；使用 Mermaid 可视化。
- **产出**：业务流程设计。

### 步骤 2：用户故事与场景

- **角色**：product_designer
- **任务**：按 INVEST 编写用户故事（作为…我希望…以便…），含验收标准（Given-When-Then）；详述正常/备选/异常/边界场景；标注优先级与故事点。
- **产出**：用户故事与场景清单。

### 步骤 3：用例建模

- **角色**：product_designer
- **任务**：用 Mermaid 绘制用例图；编写用例描述（参与者、前后置条件、主成功场景、扩展场景、业务规则引用）。
- **产出**：用例模型。

### 步骤 4：功能模块与交互设计

- **角色**：product_designer
- **任务**：功能模块划分与模块间关系；用户交互设计（信息架构、操作流程、校验与反馈）；业务规则汇总（触发条件、执行逻辑、异常与优先级）。
- **产出**：功能模块与交互设计。

### 步骤 5：文档输出与评审

- **角色**：technical-writer + doc-updater
- **任务**：将步骤 1–4 整合为 PRD 文档，严格采用 `.ai/rules/requirement/prd-template.md` 的章节与格式；执行质量门禁自查。
- **产出**：`docs/requirements/REQUIREMENT-{ID}/MVP-{N}/PRD-{ID}.md`。

## 质量门禁（product_quality_gate）

- **可追溯性**：每个用户故事可追溯到需求分析中的功能需求，每个业务规则可追溯到需求分析中的规则定义。
- **完整性**：所有功能需求已转化为用户故事，核心业务流程与异常/边界场景已覆盖，验收标准明确可测。
- **一致性**：业务流程、业务规则、用户角色与需求分析及解决方案文档一致。

## 参考

- 文档模板：`.ai/rules/requirement/prd-template.md`
- 上游：`analysis/REQUIREMENT-{ID}.md`；产品视角：`knowledge/product/`
