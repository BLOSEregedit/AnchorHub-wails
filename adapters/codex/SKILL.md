---
name: anchorhub-wails
description: 基于 AnchorHub-wails 模板初始化或扩展 Wails v2 桌面应用（Go + Vue 3 + Naive UI）。适用于 Codex CLI / Codex App，当用户要求新建 Wails 项目、使用 AnchorHub 模板或扩展模板项目时使用。
---

# AnchorHub-wails Codex 入口

此文件是 Codex CLI / Codex App 的薄入口。完整业务协议在公共文档中维护。

## 使用前读取

请先读取：

- `/Users/curie/GoProject/AnchorHub-wails/README.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/01-design-system.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/02-tech-stack.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/03-usage-guide.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/04-agent-usage-protocol.md`

## 执行规则

- 以 `docs/04-agent-usage-protocol.md` 作为唯一公共执行协议。
- 以 `docs/01-design-system.md` 作为 UI 和交互规范。
- 以 `docs/02-tech-stack.md` 作为技术栈和版本策略。
- 以 `docs/03-usage-guide.md` 作为使用步骤和常见问题参考。
- 执行代码修改前，确认用户已经明确要求生成、初始化或修改。

## Codex 平台注意事项

- 在已有仓库中工作时，先查看相关文件和工作区状态，避免覆盖他人并行改动。
- 不要使用 `git reset`、`git restore`、`git checkout` 等方式回滚未提交工作区代码。
- 文件编辑应保持最小范围；不要顺手改 README、模板或脚本，除非用户明确要求。
- 完成后简要列出修改文件、设计要点和未执行的验证项。
