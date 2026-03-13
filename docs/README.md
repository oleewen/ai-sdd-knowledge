# 文档库使用指南

## 设计目的

本知识库专为 AI Agent（如 Cursor、Copilot Workspace、Claude Code 等）设计，
旨在为 AI 提供充足的项目上下文，使其能够：

1. **理解业务**：通过产品文档了解系统做什么、为谁做
2. **理解领域**：通过领域模型了解核心概念和业务规则
3. **理解架构**：通过架构文档了解系统如何构建
4. **评估影响**：通过依赖矩阵了解变更的波及范围

## 文档导航

### 我要理解一个业务需求

1. 先看 [GLOSSARY.md](docs/instructions/GLOSSARY.md) 理解术语
2. 再看 [BUSINESS-RULES.md](docs/instructions/product/BUSINESS-RULES.md) 理解规则
3. 查看 [CONSTRAINTS.md](docs/instructions/product/CONSTRAINTS.md) 了解约束

### 我要开发一个新功能

1. 确认功能属于哪个上下文 → [DOMAIN-MODEL.md](docs/instructions/domain/DOMAIN-MODEL.md)
2. 了解涉及的服务 → [SYSTEM-ARCHITECTURE.md](docs/instructions/architecture/SYSTEM-ARCHITECTURE.md)
3. 检查依赖关系 → [DEPENDENCY-MATRIX.md](docs/instructions/dependency/DEPENDENCY-MATRIX.md)
4. 查看集成方式 → [INTEGRATION-MAP.md](docs/instructions/architecture/INTEGRATION-MAP.md)

### 我要修改一个已有接口

1. 查看谁在调用此接口 → [INTEGRATION-MAP.md](docs/instructions/architecture/INTEGRATION-MAP.md)
2. 确认影响范围 → [DEPENDENCY-MATRIX.md](docs/instructions/dependency/DEPENDENCY-MATRIX.md)
3. 检查是否违反约束 → [CONSTRAINTS.md](docs/instructions/product/CONSTRAINTS.md)

### 我要做架构决策

1. 查看已有决策 → [DECISION-RECORDS/](docs/instructions/architecture/DECISION-RECORDS/)
2. 参考架构约束 → [CONSTRAINTS.md](docs/instructions/product/CONSTRAINTS.md) 性能/安全约束部分
3. 使用ADR模板记录新决策

## 文档总体结构

```text
project-root/
├── docs/                                    # 文档根目录
│   ├── solutions/                           # 解决方案目录
│   │   ├── SOLUTION-{ID}-{title}.md         # 解决方案文档
│   │   └── archive/                         # 历史版本归档
│   │
│   ├── analysis/                            # 需求分析目录
│   │   ├── REQUIREMENT-{ID}-{title}.md      # 需求分析文档
│   │   └── archive/                         # 历史版本归档
│   │
│   ├── requirements/                        # 需求交付目录
│   │   └── REQUIREMENT-{ID}/                # 按需求编号组织
│   │       ├── README.md                    # 需求概述和MVP规划
│   │       ├── MVP-Phase-1/                 # MVP阶段1
│   │       │   ├── PRD-{ID}.md              # 产品需求文档
│   │       │   ├── ADD-{ID}.md              # 架构设计文档
│   │       │   ├── TDD-{ID}.md              # 测试设计文档
│   │       │   ├── SPEC-{ID}.md             # 开发规约文档
│   │       │   └── DEV-{ID}.md              # 开发交付记录
│   │       ├── MVP-Phase-2/                 # MVP阶段2
│   │       └── MVP-Phase-N/                 # MVP阶段N
│   │
│   ├── instructions/
│   │   ├── INDEX.md                         # 说明索引
│   │   ├── GLOSSARY.md                      # 统一术语表
│   │   ├── CHANGELOG.md                     # 文档变更日志
│   │   │
│   │   ├── product/                         # 产品文档
│   │   │   ├── PRODUCT-OVERVIEW.md          # 产品概览
│   │   │   ├── FEATURE-MAP.md               # 功能地图
│   │   │   ├── USER-JOURNEY.md              # 用户旅程地图
│   │   │   ├── USER-STORIES.md              # 用户故事
│   │   │   ├── BUSINESS-RULES.md            # 业务规则清单
│   │   │   ├── CONSTRAINTS.md               # 业务约束与不变量
│   │   │   └── USER-GUIDE.md                # 用户指南
│   │   │
│   │   ├── architecture/                    # 架构文档
│   │   │   ├── SYSTEM-ARCHITECTURE.md       # 系统架构
│   │   │   ├── DATA-ARCHITECTURE.md         # 数据架构
│   │   │   ├── DEPLOYMENT-ARCHITECTURE.md   # 部署架构
│   │   │   ├── INTEGRATION-MAP.md           # 集成关系图
│   │   │   └── DECISION-RECORDS/            # 架构决策记录
│   │   │       └── ADR-{NNN}-{title}.md
│   │   │
│   │   ├── domain/                          # 领域模型
│   │   │   ├── DOMAIN-OVERVIEW.md           # 领域模型总览
│   │   │   ├── BOUNDED-CONTEXTS.md          # 限界上下文
│   │   │   ├── DOMAIN-MODEL.md              # 领域模型
│   │   │   ├── DOMAIN-EVENTS.md             # 领域事件目录
│   │   │   └── CONTEXT-MAPPING.md           # 上下文映射关系
│   │   │
│   │   ├── api/                             # API文档
│   │   │   ├── API-OVERVIEW.md              # API总览
│   │   │   ├── API-CONVENTIONS.md           # API设计约定
│   │   │   └── services/
│   │   │       └── {service-name}/
│   │   │           ├── API-SPEC.md          # 服务API规约
│   │   │           └── SERVICE-CONTRACT.md  # 服务契约
│   │   │
│   │   ├── dependency/                      # 依赖与影响面
│   │   │   ├── DEPENDENCY-MATRIX.md         # 模块依赖矩阵
│   │   │   ├── IMPACT-ANALYSIS-GUIDE.md     # 影响面分析指南
│   │   │   └── CHANGE-RISK-MAP.md           # 变更风险地图
│   │   │
│   │   └── test/                            # 测试文档
│   │       ├── TEST-STRATEGY.md             # 测试策略
│   │       ├── TEST-COVERAGE.md             # 测试覆盖报告
│   │       └── TEST-SCENARIOS/              # 功能域测试场景
│   │           └── {domain-name}/
│   │               └── TEST-CASES.md
│   │
│   └── changelogs/                          # 变更记录
│       ├── CHANGELOG.md                     # 变更日志总览
│       └── changes/                         # 变更明细
│           └── CHANGE-{ID}-{date}.md        # 单次变更记录
│
├── specs/                                   # Spec 规约
│   ├── {service-name}/
│   │   ├── service.yaml                     # 服务元信息
│   │   ├── api/                             # API 规约
│   │   ├── domain/                          # 领域规约
│   │   ├── data/                            # 数据规约
│   │   └── integration/                     # 集成规约
│   └── ...
│
├── src/                                     # 源代码
│
├── .ai/                                     # AI Agent 配置
│   ├── agents.yaml                          # Agent 注册与配置
│   ├── workflows.yaml                       # 工作流定义
│   ├── prompts/                             # Prompt 模板库
│   │   ├── solutions/
│   │   ├── requirements/
│   │   ├── product/
│   │   ├── design/
│   │   ├── development/
│   │   └── archive/
│   └── context/                             # 上下文管理
│       ├── project-context.yaml             # 项目上下文
│       └── session/                         # 会话上下文
└── AGENTS.md
```

## 编码引用规范

**文档编码规范**：

| 文档类型 | 编号格式                      | 示例                               |
| -------- | ----------------------------- | ---------------------------------- |
| 解决方案 | SOLUTION-{YYYYMMDD}-{SEQ}     | SOLUTION-20250101-001              |
| 需求分析 | REQUIREMENT-{YYYYMMDD}-{SEQ}  | REQUIREMENT-20250101-001           |
| 产品需求 | PRD-{REQUIREMENT-ID}-MVP{N}   | PRD-REQUIREMENT-20250101001-MVP1    |
| 架构设计 | ADD-{REQUIREMENT-ID}-MVP{N}   | ADD-REQUIREMENT-20250101001-MVP1    |
| 技术设计 | TDD-{REQUIREMENT-ID}-MVP{N}   | TDD-REQUIREMENT-20250101001-MVP1    |
| 开发交付 | DEV-{REQUIREMENT-ID}-MVP{N}   | DEV-REQUIREMENT-20250101001-MVP1    |
| 变更记录 | CHANGE-{YYYYMMDD}-{SEQ}       | CHANGE-20250101-001                |

**文档引用规范**：

```yaml
reference_rules:
  cross_reference:
    - "使用相对路径引用同项目文档"
    - "使用文档ID引用（如 PRD-001、TDD-001）"
    - "引用时注明版本号"
  
  traceability:
    - "PRD 引用 需求来源"
    - "ADD 引用 PRD"
    - "TDD 引用 PRD 和 TDD"
    - "代码注释引用 TDD 中的设计章节"
    - "测试代码引用 TPD 中的测试用例编号"
    - "规约文件引用对应的设计文档"
```

## 文档版本管理

每份文档头部必须包含标准元数据块：

```yaml
---
id: "{文档编号}"
title: "{文档标题}"
version: "{主版本}.{次版本}.{修订号}"
status: "draft | review | approved | archived"
created: "{YYYY-MM-DD}"
updated: "{YYYY-MM-DD}"
author: "{作者/Agent}"
reviewers: ["{审阅者列表}"]
parent: "{父文档编号，如有}"
dependencies: ["{依赖文档编号列表}"]
tags: ["{标签列表}"]
---
```

## 文档维护规范

### 何时更新知识库

| 触发事件 | 需更新的文档 |
|---------|------------|
| 新增业务规则 | BUSINESS-RULES.md |
| 新增/修改领域概念 | GLOSSARY.md, DOMAIN-MODEL.md |
| 新增服务 | SYSTEM-ARCHITECTURE.md, DEPENDENCY-MATRIX.md, INTEGRATION-MAP.md |
| 新增服务间调用 | INTEGRATION-MAP.md, DEPENDENCY-MATRIX.md |
| 架构决策 | DECISION-RECORDS/ 新增ADR |
| 数据表结构变更 | DATA-ARCHITECTURE.md |
| 任何文档变更 | CHANGELOG.md |

## 质量门禁检查

```text
┌─────────────────────────────────────────────────────────────────────┐
│                        质量门禁检查点                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  需求分析 ──▶ [门禁1] ──▶ 方案设计 ──▶ [门禁2] ──▶ 需求开发 ──▶ [门禁3]  │
│                                                                     │
│  [门禁1] 需求质量门禁                                                 │
│  ├── 需求完整性检查                                                   │
│  ├── 需求一致性检查                                                   │
│  ├── 用户故事可验证性检查                                              │
│  └── MVP划分合理性检查                                                │
│                                                                     │
│  [门禁2] 设计质量门禁                                                 │
│  ├── 设计与需求的可追溯性                                              │
│  ├── 设计完整性检查                                                   │
│  ├── 架构一致性检查                                                   │
│  ├── 规约文件完整性检查                                               │
│  └── 测试计划覆盖度检查                                               │
│                                                                    │
│  [门禁3] 交付质量门禁                                                 │
│  ├── 代码质量检查（linter + 审查）                                     │
│  ├── 测试覆盖率检查                                                   │
│  ├── 测试通过率检查                                                   │
│  ├── 缺陷清零检查（P0/P1）                                            │
│  └── 文档同步检查                                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## AI Agent行为准则

### 必须做的

- ✅ 每次生成代码前，先查阅相关领域模型和业务规则
- ✅ 涉及状态变更时，对照状态机(INV-002)验证合法性
- ✅ 涉及金额计算时，遵循金额精度约束(DC-001)
- ✅ 修改接口时，检查依赖矩阵确认影响范围
- ✅ 新增领域概念时，先更新术语表

### 禁止做的

- ❌ 不可跳过业务规则验证直接实现功能
- ❌ 不可在服务间直接访问数据库（违反ADR-002）
- ❌ 不可使用浮点数存储金额
- ❌ 不可硬编码业务规则中的阈值参数
- ❌ 不可忽略幂等性设计（尤其是事件消费和支付回调）
