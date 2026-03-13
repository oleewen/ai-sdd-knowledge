---
id: "product-user-stories"
title: "用户故事"
version: "0.1.0"
status: "draft"
created: "2025-03-13"
updated: "2025-03-13"
author: "Agent"
parent: "product-overview"
tags: ["product", "user-stories"]
---

# 用户故事

## 元信息

| 属性 | 值 |
| ------ | ----- |
| 最后更新 | {YYYY-MM-DD} |
| 关联文档 | [产品概览](docs/instructions/product/PRODUCT-OVERVIEW.md)、[功能地图](docs/instructions/product/FEATURE-MAP.md)、[用户旅程](docs/instructions/product/USER-JOURNEY.md)、[业务规则](docs/instructions/product/BUSINESS-RULES.md)、[领域模型](docs/instructions/domain/DOMAIN-MODEL.md) |

## 使用说明

> 本文件记录系统的核心用户故事，按 Epic 分组。
> 以「作为…我希望…以便…」格式维护用户故事，便于需求追溯与验收。
> 每个故事包含验收标准，AI Agent 可据此理解功能预期行为。

| 编号 | 分组 | 作为…我希望…以便… | 优先级 | 状态 | 验收标准 | 关联规则 | 涉及服务 |
|------|------|-------------------|--------|------|----------|----------|----------|
| US-101 | 用户 | 作为 一个新用户，我希望 能够通过手机号注册账号，以便 我可以使用平台的购物功能 | P0 | 待开发 | 1. 手机号获取短信验证码 2. 验证码+密码完成注册 3. 验证码5分钟内有效，每号每日最多10次 4. 注册成功自动登录并返回 JWT 5. 已注册手机号不可重复，提示「该手机号已注册」 | 无特定规则（通用注册流程） | svc-user, svc-notification |
