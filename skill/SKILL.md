---
name: anchorhub-wails
description: Claude 兼容入口。基于 AnchorHub-wails 模板初始化或扩展 Wails v2 桌面应用（Go + Vue 3 + Naive UI）；当用户说“新建 Wails 项目”“用 AnchorHub 模板创建桌面工具”“复用 AnchorHub-wails”或类似意图时使用。
---

# AnchorHub-wails Claude 兼容入口

此文件保留给 Claude Code / Claude CLI 的既有 `skill/` 安装路径。完整规则不在这里重复维护，执行时必须读取公共协议。

## 使用前读取

请先读取并遵守：

- `/Users/curie/GoProject/AnchorHub-wails/README.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/01-design-system.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/02-tech-stack.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/03-usage-guide.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/04-agent-usage-protocol.md`

## 执行方式

- 初始化新项目时，优先使用 `/Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh`。
- 扩展已有模板项目时，按 `docs/04-agent-usage-protocol.md` 的业务开发规范执行。
- UI、布局、色彩、圆角、字体等只以 `docs/01-design-system.md` 为准。
- 技术栈、版本策略、升级命令只以 `docs/02-tech-stack.md` 为准。
- 用户只讨论方案时，先讨论；用户明确要求初始化、生成、修改或实现时，再写文件或执行命令。

## 安全边界

- 目标目录存在且非空时，先提示风险并征得用户同意。
- 默认不要自动安装依赖、升级依赖、生成图标或初始化 git。
- 只有用户明确要求“自动安装依赖”“开箱即用”“直接跑起来”时，才使用 `--upgrade`。
- 不要复制公共协议到多个入口文件中；如有冲突，以 `docs/04-agent-usage-protocol.md` 为准。
