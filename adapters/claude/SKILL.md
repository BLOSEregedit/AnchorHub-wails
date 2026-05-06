---
name: anchorhub-wails
description: 基于 AnchorHub-wails 模板初始化或扩展 Wails v2 桌面应用（Go + Vue 3 + Naive UI）。当用户说“新建 Wails 项目”“用 AnchorHub 模板创建桌面工具”“初始化桌面应用”或类似意图时使用。
---

# AnchorHub-wails Claude 入口

此文件是 Claude CLI / Claude Code 的薄入口。完整规则不要写在这里，必须引用公共协议。

## 使用前读取

请先读取：

- `/Users/curie/GoProject/AnchorHub-wails/README.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/01-design-system.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/02-tech-stack.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/03-usage-guide.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/04-agent-usage-protocol.md`

## 执行规则

- 初始化新项目、裁剪可选模块、添加业务功能时，按 `docs/04-agent-usage-protocol.md` 执行。
- 设计细节只以 `docs/01-design-system.md` 为准。
- 依赖版本、升级命令与技术选型只以 `docs/02-tech-stack.md` 为准。
- 用户只讨论方案时，先讨论，不直接写文件。
- 用户要求执行时，可以调用文件与命令工具完成任务，但目标目录非空时必须先询问。

## Claude 平台注意事项

- 如 Claude 环境支持交互式提问工具，初始化参数应一次性问全。
- 如果没有专用提问工具，用简短清单向用户确认必要参数。
- 不要把公共协议复制到回答里；只在需要时总结关键决策和下一步。
