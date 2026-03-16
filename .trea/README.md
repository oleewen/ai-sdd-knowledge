# Trea Agent 配置

本目录为 **Trea Agent** 的 SDD 项目配置。执行 `sdx-init --agents=trea` 或 `--agents=all` 时，会将此处内容拷贝到目标项目的 `.trea/`。

## 使用方式

- 在 sdx-init 时指定包含 trea：`--agents=cursor,trea` 或 `--agents=all`。
- 目标目录下将生成或更新 `.trea/`，Trea 可从此目录读取技能与命令配置。

## 扩展

可在本目录下增加 Trea 所需的配置文件或 `skills` 子目录，与 `.ai/skills` 保持约定一致时便于多 Agent 共用同一套技能定义。
