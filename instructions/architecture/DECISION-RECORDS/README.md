---
id: "adr-readme"
title: "架构决策记录目录"
version: "0.1.0"
status: "draft"
created: "2025-03-13"
updated: "2025-03-13"
author: "Agent"
tags: ["adr", "architecture"]
---

# 架构决策记录（ADR）

本目录存放架构决策记录，命名格式：`ADR-{NNN}-{title}.md`，例如 `ADR-001-选用事件总线.md`。

每份 ADR 建议包含：背景、决策、后果与替代方案简述。

**参考样例**：

```markdown
# ADR-001: 采用JWT进行API鉴权

## 状态
已采纳 (Accepted)

## 日期
{YYYY-MM-DD}

## 上下文
系统采用微服务架构，需要一种无状态、跨服务的身份认证方案。
主要考量因素：
1. 多服务间需共享用户身份信息
2. 网关层需要统一鉴权
3. 高并发场景下不希望每次请求都查询数据库/缓存验证

## 备选方案

| 方案 | 优点 | 缺点 |
|------|------|------|
| Session + Redis | 可即时失效 | 每次请求需查Redis，增加延迟 |
| JWT | 无状态，性能好，跨服务方便 | 无法即时失效（需黑名单机制） |
| OAuth2 + JWT | 标准化，支持第三方授权 | 复杂度高，当前无第三方授权需求 |

## 决策
采用 **JWT** 方案，配合 Redis Token黑名单实现强制失效。

## 实现要点
- Access Token 有效期 2小时
- Refresh Token 有效期 7天，存储于 HttpOnly Cookie
- Token Payload 包含：userId, roles, permissions
- 用户登出或修改密码时，将当前Token的jti加入Redis黑名单
- Gateway层统一校验Token签名和有效期，将userId注入请求头

## 后果
- ✅ 网关层可独立完成鉴权，无需调用用户服务
- ✅ 服务间内部调用可直接传递userId，无需重复鉴权
- ⚠️ Token失效有短暂延迟（依赖黑名单检查频率）
- ⚠️ Token Payload不宜过大，避免增加网络开销

## 关联
- 约束 [SC-003](docs/instructions/product/CONSTRAINTS.md)
- 系统架构 [横切关注点-鉴权方案](docs/instructions/architecture/SYSTEM-ARCHITECTURE.md)
```