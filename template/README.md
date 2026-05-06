# {{APP_NAME}}

> {{APP_DESCRIPTION}}

## 技术栈

> 模板策略：**始终用各依赖最新稳定版**。下面的版本号只是"最低支持基线"，
> 首次 `npm install` / `go mod tidy` 后实际拉到的就是当下的最新稳定版。

- **后端**：Go (1.25+) / Wails v2 (latest)
- **前端**：Vue 3 + TypeScript 5 + Vite (latest)
- **UI 库**：Naive UI (latest)
- **状态管理**：Pinia (latest)
- **路由**：vue-router (latest，Hash 模式)
- **图标**：@vicons/ionicons5 (latest)

## 项目结构

```
{{APP_NAME}}/
├── main.go                 # Wails 入口（窗口配置 + Bind）
├── go.mod / wails.json     # Go 依赖 / Wails 配置
├── backend/
│   ├── app.go              # App 结构体，对外暴露的所有方法
│   ├── events/             # 事件常量与 payload
│   ├── logger/             # 本地日志（可选）
│   └── config/             # 配置持久化（可选）
├── frontend/
│   ├── src/
│   │   ├── main.ts         # 应用入口
│   │   ├── App.vue         # 整体布局壳
│   │   ├── router/         # 路由
│   │   ├── stores/         # Pinia stores
│   │   ├── views/          # 页面组件
│   │   ├── components/     # 复用组件
│   │   ├── services/       # Wails API 封装
│   │   ├── utils/          # 工具函数
│   │   └── types/          # 类型定义
│   └── wailsjs/            # Wails 自动生成（gitignore）
├── build/
│   ├── appicon.png
│   ├── darwin/appicon.icns
│   └── windows/icon.ico
├── application/            # 双平台打包产物（gitignore）
├── icon.png                # 1024x1024 应用图标源图
├── set-icon.sh             # 图标自动生成脚本
└── build-all.sh            # 双平台一键构建
```

## 快速开始

### 1. 准备环境

```bash
# Go 1.25+
go version

# Node.js 18+
node -v

# Wails CLI（最新稳定版）
go install github.com/wailsapp/wails/v2/cmd/wails@latest

# ImageMagick（用于生成 Windows .ico）
brew install imagemagick
```

### 2. 安装依赖（自动拉取最新稳定版）

```bash
# Go：模板里的版本号只是基线，建议先升级到最新稳定版
go get -u github.com/wailsapp/wails/v2@latest
go mod tidy

# 前端：package.json 已写 "latest"，install 自动拉到最新稳定版
cd frontend && npm install && cd ..
```

### 3. 准备图标

```bash
# 把 1024x1024 PNG 命名为 icon.png 放到项目根
chmod +x set-icon.sh
./set-icon.sh
```

### 4. 开发模式

```bash
wails dev
```

### 5. 双平台打包

```bash
chmod +x build-all.sh
./build-all.sh
```

打包产物：
- macOS Universal：`application/{{APP_NAME}}.app`
- Windows amd64：`application/{{APP_NAME}}.exe`

## 设计规范

本项目遵循 [AnchorHub-wails 设计规范](https://github.com/YourName/AnchorHub-wails/blob/main/docs/01-design-system.md)：

- 侧边栏宽度固定 `200px`
- 内容区背景 `#f5f7fa`
- 主色（如启用主题覆盖）：Apple Blue `#007AFF`
- 卡片圆角 `20px`，按钮圆角 `8px`
- 字体：`-apple-system` 优先

## 可选模块

| 模块 | 启用方式 |
|---|---|
| 暗黑主题切换 | `App.vue` 取消注释 + `backend/app.go` 启用 `SetDarkMode` |
| 本地日志 | 在 `backend/app.go` 的 `Startup` 中初始化 `logger.NewLogger()` |
| 配置持久化 | 在 `backend/app.go` 的 `Startup` 中初始化 `config.NewManager()` |
| 拖拽上传 | `main.go` 已默认启用 `DragAndDrop` |

## License

MIT © {{COPYRIGHT_YEAR}} {{COMPANY_NAME}}
