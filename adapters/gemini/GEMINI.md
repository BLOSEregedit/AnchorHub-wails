# AnchorHub-wails Gemini CLI 入口

此文件是 Gemini CLI 的薄入口。完整规则由公共协议维护，不在入口中重复。

## 适用场景

当用户要求以下任务时启用：

- 新建 Wails v2 桌面应用。
- 使用 AnchorHub-wails 模板创建桌面工具。
- 初始化 Go + Vue 3 + Naive UI 项目骨架。
- 在 AnchorHub-wails 模板项目中添加菜单、视图、后端业务或事件流。

## 使用前读取

请先读取：

- `/Users/curie/GoProject/AnchorHub-wails/README.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/01-design-system.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/02-tech-stack.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/03-usage-guide.md`
- `/Users/curie/GoProject/AnchorHub-wails/docs/04-agent-usage-protocol.md`

## 执行规则

- 平台无关初始化和开发流程以 `docs/04-agent-usage-protocol.md` 为准。
- 不重复维护完整流程，不与公共协议写冲突规则。
- 目标目录非空时，先提示覆盖风险并征得用户同意。
- 默认不安装依赖、不升级依赖、不生成图标、不初始化 git。
- 用户只要求讨论时，先讨论方案，不直接写代码。

## Gemini CLI 注意事项

- 命令执行前说明意图，执行后总结关键结果。
- 修改文件前确认任务属于用户明确授权的写入范围。
- 如果工具能力有限，至少输出可执行步骤，并明确哪些步骤没有实际执行。
