---
id: "dependency-matrix"
title: "模块依赖矩阵"
version: "0.1.0"
status: "draft"
created: "2025-03-13"
updated: "2025-03-13"
author: "Agent"
tags: ["dependency", "impact"]
---

# 依赖矩阵

## 元信息

| 属性 | 值 |
|------|-----|
| 最后更新 | {YYYY-MM-DD} |
| 关联文档 | [集成关系图](docs/instructions/architecture/INTEGRATION-MAP.md), [系统架构](docs/instructions/architecture/SYSTEM-ARCHITECTURE.md) |

## 使用说明

> **AI Agent 必读**：当任何服务或模块发生变更时，必须查阅此矩阵确定影响范围。
> 矩阵中标注了依赖方向和依赖强度，用于变更影响分析。

## 服务依赖矩阵

**读法**: 行依赖列。例如 svc-order 行、svc-product 列 = svc-order 依赖 svc-product

| ↓依赖方 \ 被依赖方→ | svc-user | svc-product | svc-order | svc-payment | svc-inventory | svc-notification |
|---------------------|----------|-------------|-----------|-------------|---------------|------------------|
| **svc-user** | - | | | | | |
| **svc-product** | | - | | | | |
| **svc-order** | 🔵弱 | 🔴强 | - | 🔵弱(异步) | 🔴强 | 🟡中(异步) |
| **svc-payment** | | | 🔴强(异步) | - | | 🟡中(异步) |
| **svc-inventory** | | | 🔵弱(异步) | | - | 🟡中(异步) |
| **svc-notification** | | | | | | - |

**依赖强度说明**:
- 🔴 **强依赖**: 被依赖方不可用时，依赖方核心功能不可用
- 🟡 **中依赖**: 被依赖方不可用时，依赖方部分功能降级
- 🔵 **弱依赖**: 被依赖方不可用时，依赖方可降级或使用缓存

## 变更影响分析表

> 当某服务发生以下类型变更时，需要同步检查/修改的服务列表

| 变更服务 | 变更类型 | 影响服务 | 影响描述 | 必须操作 |
|---------|---------|---------|---------|---------|
| svc-product | API字段变更 | svc-order | 订单创建时获取商品信息 | 同步更新调用代码 |
| svc-product | 商品数据模型变更 | svc-order | 订单项快照结构 | 检查快照兼容性 |
| svc-inventory | 锁定接口变更 | svc-order | 下单库存锁定 | 同步更新调用代码 |
| svc-order | 订单事件格式变更 | svc-payment, svc-notification | 事件消费 | 发布新版本事件+保持向后兼容 |
| svc-payment | 支付事件格式变更 | svc-order, svc-inventory | 事件消费 | 发布新版本事件+保持向后兼容 |
| svc-user | 用户ID类型变更 | 全部服务 | 所有关联user_id的字段 | 全服务协调变更 |

## 数据库依赖

| 数据库 | 所属服务(读写) | 只读访问 | 说明 |
|--------|--------------|---------|------|
| user_db | svc-user | 无 | 其他服务通过API获取用户信息 |
| product_db | svc-product | 无 | 其他服务通过API获取商品信息 |
| order_db | svc-order | 无 | 严格隔离 |
| payment_db | svc-payment | 无 | 严格隔离 |
| inventory_db | svc-inventory | 无 | 严格隔离 |

## 第三方依赖

| 依赖 | 使用服务 | 版本约束 | 升级影响 | 替代方案 |
|------|---------|---------|---------|---------|
| Spring Boot | 全部 | 3.2.x | 全服务同步升级 | 无 |
| MySQL Driver | 全部 | 8.0.x | 跟随MySQL版本 | 无 |
| RabbitMQ Client | svc-order, svc-payment, svc-inventory, svc-notification | 5.x | 需兼容服务端版本 | 无 |
| WeChat Pay SDK | svc-payment | 0.4.x | 仅影响支付服务 | 直接HTTP调用 |
| Aliyun SMS SDK | svc-notification | 2.x | 仅影响通知服务 | 腾讯云SMS |
