# requirements - 需求交付

本文档描述需求交付阶段的目标、输入输出、产物目录结构及工作流程。

## 1. 阶段目标

将需求分析阶段（`analysis/`）输出的高层次需求，按照交付节奏和价值最小化可行产品（MVP）进行拆分与落地。每个需求子包（`REQUIREMENT-{ID}/`）以清晰的结构沉淀为一组交付物，支撑后续详细设计（SPEC）、开发（DEV）、测试（TDD）等流程的顺畅衔接。

## 2. 输入与输出

**输入：**
- 需求分析文档（`analysis/REQUIREMENT-{ID}.md`）
- 解决方案文档（`solutions/SOLUTION-{ID}.md`）
- 相关规范/约定（如 PRD/ADD/TDD 模板等）

**输出：**
- 标准化组织的需求交付目录（`REQUIREMENT-{ID}/`），每阶段一个子目录，内含阶段 PRD、ADD、TDD 等核心文档

## 3. 产物目录结构

```text
requirements/
├── REQUIREMENT-{ID}/                # 单个需求交付包
│   ├── MVP-Phase-1/                 # 阶段（如 MVP、Beta 等）可多级嵌套
│   │   ├── PRD.md                   # 产品需求文档
│   │   ├── ADD.md                   # 架构决策文档（可选）
│   │   └── TDD.md                   # 测试设计文档
│   ├── MVP-Phase-2/
│   └── ...（如需更多阶段）
│
├── REQUIREMENT-EXAMPLE/             # 示例参考（见本目录下README）
│   ├── MVP-Phase-1/
│   │   ├── PRD.md
│   │   └── ...
│   └── README.md
└── README.md                        # 本说明文档
```

## 4. 推荐工作流

1. **建立需求目录**  
   - 按 `REQUIREMENT-{ID}/` 命名新建需求子目录。
   - 复制 `REQUIREMENT-EXAMPLE/` 作为参考。

2. **MVP 拆分与分阶段组织**  
   - 将需求分析文档中 MVP 拆分，与实际交付节奏对应，按阶段新建子目录（如 `MVP-Phase-1/`）。

3. **撰写阶段交付文档**  
   - 每一阶段填写相应的 PRD、ADD、TDD 等文档。
   - 可按需补充 API Spec、开发任务分解等支持交付的文档。

4. **联动分析与解决方案**  
   - 交付包应与 `analysis/REQUIREMENT-{ID}.md` 和 `solutions/SOLUTION-{ID}.md` 通过 ID 紧密关联，便于追溯和知识映射。

## 5. 示例参考

具体结构和范例请参考本目录下 [REQUIREMENT-EXAMPLE/README.md](./REQUIREMENT-EXAMPLE/README.md)。

## 6. 相关模板与规范

- PRD/ADD/TDD 等文档模板统一位于 `.ai/rules/requirement/`（prd-template.md、add-template.md、tdd-template.md）；阶段规范见 `.cursor/skills/sdd-prd/`、`sdd-design/`、`sdd-test/`。
- 目录与命名示例可参见 `docs/README.md` 体系。

> 阶段命令：`/sdd-prd`、`/sdd-design`、`/sdd-test`；详见 `.cursor/README.md`。
