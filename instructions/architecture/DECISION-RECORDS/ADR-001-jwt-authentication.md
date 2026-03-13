---
id: "ADR-001"
title: "采用JWT进行API鉴权"
version: "0.1.0"
status: "accepted"
created: "2025-03-13"
updated: "2025-03-13"
author: "Agent"
tags: ["adr", "authentication", "jwt"]
---

# ADR-001: 采用JWT进行API鉴权

## 状态

已采纳 (Accepted)

## 日期

{YYYY-MM-DD}

## 上下文

系统采用微服务架构，需要一种无状态、跨服务的身份认证方案。主要考量：多服务间需共享用户身份；网关层需要统一鉴权；高并发下不希望每次请求都查库/缓存验证。

## 备选方案

| 方案 | 优点 | 缺点 |
|------|------|------|
| Session + Redis | 可即时失效 | 每次请求需查 Redis，增加延迟 |
| JWT | 无状态、性能好、跨服务方便 | 无法即时失效（需黑名单机制） |
| OAuth2 + JWT | 标准化，支持第三方授权 | 复杂度高，当前无第三方授权需求 |

## 决策

采用 **JWT** 方案，配合 Redis Token 黑名单实现强制失效。

## 实现要点

- Access Token 有效期 2 小时；Refresh Token 有效期 7 天，存于 HttpOnly Cookie
- Token Payload 包含：userId, roles, permissions
- 登出或修改密码时，将当前 Token 的 jti 加入 Redis 黑名单
- Gateway 层统一校验签名与有效期，将 userId 注入请求头

## 后果

- 网关层可独立鉴权，无需调用用户服务
- 服务间内部调用可直接传递 userId
- Token 失效有短暂延迟（依赖黑名单）；Payload 不宜过大

## 关联

- [系统架构 - 横切关注点-鉴权方案](docs/instructions/architecture/SYSTEM-ARCHITECTURE.md)
- [业务约束](docs/instructions/product/CONSTRAINTS.md)
