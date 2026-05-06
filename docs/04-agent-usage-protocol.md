# Agent 使用协议（Agent Usage Protocol）

> 平台无关的 AnchorHub-wails Agent 协作协议。适用于 Claude CLI / Claude Code、Codex CLI / Codex App、Gemini CLI 等具备文件读写与命令执行能力的 Agent。

## 一、协议目标

AnchorHub-wails 是一套 Wails v2 桌面应用模板。Agent 的职责是帮助用户基于模板初始化新项目，并在后续业务开发中保持统一的工程结构、技术栈与设计规范。

所有平台入口都应该保持很薄：

- 公共规则以本文档为准。
- 设计规范以 `docs/01-design-system.md` 为准。
- 技术栈与版本策略以 `docs/02-tech-stack.md` 为准。
- 具体使用步骤以 `docs/03-usage-guide.md` 为准。
- 模板源以 `template/` 为准。

## 二、触发意图

当用户表达以下任一意图时，应启用本协议：

- 新建 Wails 项目。
- 用 AnchorHub / AnchorHub-wails 模板创建桌面工具。
- 初始化一个 Go + Vue 3 + Naive UI 的 Wails 桌面应用。
- 复用这套 Wails 模板生成项目骨架。
- 在已初始化项目中添加菜单、页面、后端业务、事件流或 Wails API。

如果用户只是询问概念、方案或对比，先讨论，不直接改代码。只有用户明确要求初始化、生成、修改或实现时，才执行文件写入。

## 三、执行原则

### 1. 先确认上下文

执行前至少读取：

- `README.md`
- `docs/01-design-system.md`
- `docs/02-tech-stack.md`
- `docs/03-usage-guide.md`
- `docs/04-agent-usage-protocol.md`

如平台入口文件已经加载本文档，仍应根据任务需要读取对应 repo 文档，不要只依赖入口摘要。

### 2. 保护用户工作区

- 不要修改用户已有代码，除非用户明确要求。
- 如果目标目录已存在且非空，必须先提醒风险并征得用户同意。
- 不要自动 `git init`、提交、推送或改远程。
- 不要使用会丢失未提交修改的回滚方式。
- 默认不要自动安装或升级依赖，避免改动锁文件或拉取大量依赖。

### 3. 依赖版本策略

遵循 `docs/02-tech-stack.md`：

- 模板中的版本号只是最低支持基线。
- 新项目初始化后建议用户手动升级到最新稳定版。
- 前端 `package.json` 使用 `"latest"`，首次 `npm install` 拉取最新稳定版。
- Go 端建议用户手动执行 `go get -u github.com/wailsapp/wails/v2@latest && go mod tidy`。

仅当用户明确要求“自动安装依赖”“开箱即用”“直接跑起来”时，才可以在初始化脚本中使用 `--upgrade`。

## 四、新项目初始化流程

### 第 1 步：收集参数

一次性收集必要参数，避免反复打断用户：

| 参数 | 要求 | 示例 |
|---|---|---|
| `APP_NAME` | PascalCase，无空格 | `PdfMerger` |
| `APP_TITLE` | 窗口标题，可含中文 | `PDF 合并工具` |
| `APP_DESCRIPTION` | 一句话简介 | `批量合并 PDF 的桌面工具` |
| 目标目录 | 绝对路径优先 | `/Users/curie/GoProject/PdfMerger` |
| 可选模块 | 多选 | 暗黑主题、本地日志、配置持久化、拖拽上传 |

可自动推断：

| 参数 | 默认规则 |
|---|---|
| `APP_NAME_LOWER` | `APP_NAME` 转小写 |
| `BUNDLE_ID` | `com.curie.{APP_NAME_LOWER}` |
| `COMPANY_NAME` | `Curie` |
| `AUTHOR_EMAIL` | 可空，用户未提供时留空 |
| `COPYRIGHT_YEAR` | 当前年份 |
| `WINDOW_WIDTH` | `1180` |
| `WINDOW_HEIGHT` | `900` |

### 第 2 步：复制模板

模板目录固定为：

```bash
/Users/curie/GoProject/AnchorHub-wails/template
```

复制到目标目录：

```bash
mkdir -p {目标目录}
cp -R /Users/curie/GoProject/AnchorHub-wails/template/. {目标目录}/
```

若目标目录非空，先停下来征求用户同意，不要覆盖。

### 第 3 步：执行初始化脚本

默认不自动升级依赖：

```bash
cd {目标目录}
APP_NAME={APP_NAME} \
APP_TITLE="{APP_TITLE}" \
APP_DESCRIPTION="{APP_DESCRIPTION}" \
COMPANY_NAME="{COMPANY_NAME}" \
AUTHOR_EMAIL="{AUTHOR_EMAIL}" \
BUNDLE_ID="{BUNDLE_ID}" \
WINDOW_WIDTH={WINDOW_WIDTH} \
WINDOW_HEIGHT={WINDOW_HEIGHT} \
COPYRIGHT_YEAR={COPYRIGHT_YEAR} \
bash /Users/curie/GoProject/AnchorHub-wails/scripts/init-project.sh --non-interactive
```

仅当用户明确要求自动安装或马上启动时，追加：

```bash
--upgrade
```

### 第 4 步：按需裁剪可选模块

按用户选择保留或裁剪模块：

| 模块 | 默认建议 | 未启用时处理 |
|---|---|---|
| 暗黑主题切换 | 按需 | 删除 `backend/app.go` 中 `SetDarkMode`，前端保持注释 |
| 本地日志持久化 | 按需 | 删除 `backend/logger/`，如仅日志使用 `github.com/google/uuid` 则移除依赖 |
| 配置持久化 | 按需 | 删除 `backend/config/` |
| 拖拽文件上传 | 推荐启用 | 如用户不要，删除 `main.go` 的 `DragAndDrop` 配置块 |
| 进度事件 | 推荐保留 | 长耗时任务优先用 events |

### 第 5 步：输出下一步指引

初始化完成后，给用户明确但不冗长的后续步骤：

```bash
cd {目标目录}

go get -u github.com/wailsapp/wails/v2@latest && go mod tidy
cd frontend && npm install && cd ..

# 准备 1024x1024 PNG，命名为 icon.png 放项目根
./set-icon.sh

wails dev
./build-all.sh
```

说明要点：

- `go.mod` 是基线，建议升级到最新稳定版。
- `frontend/package.json` 已使用 `"latest"`。
- 图标不自动生成，用户准备 `icon.png` 后手动执行。
- 不自动初始化 git。

## 五、后续业务开发规范

### 添加新菜单项或视图

1. 在 `frontend/src/views/{ViewName}.vue` 创建视图。
2. 在 `frontend/src/router/index.ts` 添加 Hash 路由。
3. 在 `frontend/src/App.vue` 的 `menuOptions` 添加菜单项。
4. 如有独立状态，在 `frontend/src/stores/{name}Store.ts` 创建 Pinia store。

### 添加后端业务

1. 在 `backend/{domain}/` 创建领域包。
2. 在 `backend/app.go` 的 `App` 结构体持有 manager 指针。
3. 在 `Startup` 中初始化 manager。
4. 在 `backend/app.go` 暴露首字母大写的 Wails API 方法。
5. 长耗时任务用 `events` 推进度，不要让前端长期等待同步返回。

### 前后端通信

- 前端统一通过 `frontend/src/services/wails.ts` 封装 Wails API。
- 禁止在组件中散落直接 import `wailsjs`。
- 事件命名使用 `<domain>:<action>:<state>`，例如 `convert:process:progress`。
- 前端错误统一用 `normalizeError()` 标准化。

## 六、设计与实现约束

业务开发必须遵守 `docs/01-design-system.md`，尤其是：

| 元素 | 规范 |
|---|---|
| 侧边栏宽度 | `200px` |
| 内容区背景 | `#f5f7fa` |
| 卡片圆角 | `20px` |
| 按钮圆角 | `8px` |
| 按钮高度 | `42px` |
| 卡片间距 | `n-space :size="16"` |
| 字体 | `-apple-system` 优先 |
| 滚动条 | `:native-scrollbar="false"` |

工程实现必须遵守 `docs/02-tech-stack.md`，尤其是：

- Wails v2 + Go + Vue 3 + TypeScript + Vite + Naive UI。
- Vue Router 使用 Hash 模式。
- Pinia 管理前端状态。
- 图标库使用 `@vicons/ionicons5`。
- 双平台目标为 macOS Universal 与 Windows amd64。

## 七、平台入口适配规则

不同 Agent 平台只负责加载并转述本协议，不要复制大量规则：

- Claude CLI / Claude Code：入口见 `adapters/claude/SKILL.md`。
- Codex CLI / Codex App：入口见 `adapters/codex/SKILL.md`。
- Gemini CLI：入口见 `adapters/gemini/GEMINI.md`。
- 通用 prompt：入口见 `adapters/common/anchorhub-wails.prompt.md`。

入口文件应包含：

- 适用平台。
- 触发意图。
- 必读文档清单。
- 执行时遵守本文档。
- 平台专属的最小注意事项。

入口文件不应包含：

- 大量重复初始化步骤。
- 重复完整设计系统。
- 重复完整技术栈说明。
- 与本文档冲突的平台私有流程。
