# 技术栈选型（Tech Stack）

> 选型理由 + 版本策略：始终使用各依赖的**最新稳定版**。

## 一、整体架构

```
┌──────────────────────────────────────────┐
│  桌面应用（双平台：macOS Universal + Windows amd64）  │
├──────────────────────────────────────────┤
│  Wails v2 运行时（WebView2 / WKWebView）             │
├──────────────────────┬──────────────────┤
│  前端（Vue 3 + Vite） │  后端（Go）        │
└──────────────────────┴──────────────────┘
```

## 二、版本策略：始终用最新稳定版

> ❗ **重要**：模板里写的版本号只是"基线"。每次新建项目时，请用下面的命令把所有依赖刷到最新稳定版。
> 这样可以避免"模板写于半年前，初始化出来的项目就已经过时"的问题。

### Go 后端：初始化后执行

```bash
# 升级 Wails 到最新稳定版
go get -u github.com/wailsapp/wails/v2@latest
go mod tidy

# 同步升级 Wails CLI（可选，但建议保持一致）
go install github.com/wailsapp/wails/v2/cmd/wails@latest
```

### 前端：初始化后执行

模板的 `package.json` 已把所有依赖标为 `"latest"`，首次 `npm install` 会自动拉到最新稳定版。

如需后续再次升级到最新：

```bash
cd frontend
npm run upgrade-latest   # 模板已内置该 script
# 或直接：
npm update
```

### 各依赖最低支持版本（兼容性兜底）

> 用于约束"至少要这个版本"，避免初始化时拉到过老的不兼容版本。
> 模板会跟随主流升级，建议每季度同步一次。

| 依赖 | 最低支持版本 | 角色 |
|---|---|---|
| `go` | `1.25` | Go 语言 |
| `github.com/wailsapp/wails/v2` | `v2.11+` | Wails 运行时 |
| `vue` | `3.5+` | 前端框架（Composition API） |
| `vue-router` | `4.5+` | 路由（Hash 模式） |
| `pinia` | `2.1+` | 状态管理 |
| `naive-ui` | `2.39+` | UI 组件库 |
| `@vicons/ionicons5` | `0.12+` | 图标库 |
| `typescript` | `5.7+` | strict 模式 |
| `vite` | `6+` | 构建工具 |
| `@vitejs/plugin-vue` | `5+` | Vue 插件 |
| `vue-tsc` | `2.2+` | 类型检查 |
| Node.js | `18+` | 前端运行时 |

> 这只是"地板"。实际版本永远以 `npm install` / `go mod tidy` 拉到的最新稳定版为准。

## 三、选型理由

### 为什么用 Wails v2 而不是 Tauri / Electron？
- **Wails**：Go 后端 + 系统 WebView，无 Chromium 内置（包体小，10MB 级）
- **打包简单**：`wails build` 一行命令出双平台产物
- **拖拽友好**：原生 `OnFileDrop` API，避免浏览器拖拽限制
- **学习成本低**：Go + Vue 都是熟悉的栈

### 为什么用 Vue 3 + Naive UI？
- **Naive UI**：尤雨溪推荐的 Vue 3 组件库，TypeScript 友好，零依赖，支持主题深度定制
- **组件齐全**：Layout / Menu / Dialog / Message / Notification 一站式
- **和 Wails 适配好**：纯前端组件库，不依赖路由/SSR

### 为什么用 Pinia 而不是 Vuex？
- Vue 3 官方推荐
- 类型推导更好
- API 更简洁（无 mutations）

### 为什么用 Hash 路由？
- Wails 把前端打包到 Go 二进制后，无 HTTP 服务器解析路径
- Hash 模式不依赖服务端配置，零适配成本

## 四、可选模块决策矩阵

模板提供以下"按需启用"的模块，根据项目特性选择：

| 模块 | 启用条件 | 文件位置 | 默认 |
|---|---|---|---|
| **暗黑主题切换** | 工具型应用、长时间使用 | `App.vue` 主题切换 + `backend/app.go` `SetDarkMode` | ❌ |
| **本地日志持久化** | 需要审计、需要回查操作历史 | `backend/logger/logger.go` | ❌ |
| **配置持久化** | 用户需保存偏好（如 OSS 凭证） | `backend/config/manager.go` | ❌ |
| **进度事件** | 长耗时任务（>2 秒） | `backend/events/types.go` | ✅ 推荐 |
| **拖拽上传** | 文件处理类工具 | `main.go` `DragAndDrop` | ✅ 推荐 |
| **多窗口尺寸** | 不同分辨率适配 | `main.go` `MinWidth/MinHeight` | ✅ 推荐 |

## 五、目录约定

```
project/
├── main.go                    # Wails 入口（窗口配置 + Bind）
├── go.mod / go.sum            # Go 依赖
├── wails.json                 # Wails 配置（应用名、bundleId、图标）
├── backend/
│   ├── app.go                 # App 结构体，对外暴露的所有方法
│   ├── events/                # 事件常量与 payload 类型
│   ├── logger/                # （可选）日志模块
│   ├── config/                # （可选）配置持久化
│   └── <domain>/              # 业务子包（按领域划分）
│       └── <domain>.go
├── frontend/
│   ├── package.json
│   ├── vite.config.ts         # 路径别名 @ -> ./src
│   ├── tsconfig.json
│   ├── index.html
│   ├── wailsjs/               # Wails 自动生成（gitignore）
│   └── src/
│       ├── main.ts            # createApp + pinia + router
│       ├── App.vue            # NConfigProvider + NLayout
│       ├── router/index.ts    # vue-router Hash 模式
│       ├── stores/            # Pinia stores
│       ├── views/             # 页面组件（路由对应）
│       ├── components/        # 复用组件
│       ├── services/wails.ts  # Wails API 统一封装
│       ├── utils/             # 工具函数
│       └── types/             # 类型定义
├── build/
│   ├── appicon.png            # 1024x1024 源图
│   ├── darwin/appicon.icns    # macOS 图标
│   └── windows/icon.ico       # Windows 图标
├── application/               # 自定义打包产物输出（gitignore）
├── icon.png                   # 项目根 1024x1024 源图
├── set-icon.sh                # 图标自动生成脚本
├── build-all.sh               # 双平台一键构建
├── .gitignore
└── README.md
```

## 六、构建产物

### 开发模式
```bash
wails dev
```
- 自动启动 Vite dev server（端口 34115）
- 热重载前端
- 后端改动需重启

### 生产构建
```bash
./build-all.sh
```
- 生成 macOS Universal Binary：`application/<AppName>.app`
- 生成 Windows amd64：`application/<AppName>.exe`
- 自动重新生成图标

## 七、版本升级日常运维

### 新建项目时

`init-project.sh` 完成占位符替换后，**手动**执行：

```bash
# Go
go get -u github.com/wailsapp/wails/v2@latest && go mod tidy

# 前端（package.json 已经写 "latest"，install 自动拉到最新）
cd frontend && npm install && cd ..
```

### 已有项目升级时

```bash
# Go
go get -u ./...
go mod tidy

# 前端
cd frontend
npm run upgrade-latest    # 模板内置脚本
# 或：npm update
```

### 升级后必须验证

1. `wails dev` 是否能正常启动
2. `wails build` 是否能正常打包双平台
3. 拖拽事件 `OnFileDrop` 是否正常
4. 主题切换是否同步 macOS 标题栏（如启用）
5. 已有业务方法签名是否仍兼容

### 重大版本（major）变更前先看 CHANGELOG

- Wails v2 → v3：API 有破坏性变更，参考官方迁移指南
- Vue 3 → 4：（暂未发布）
- Naive UI 2 → 3：（暂未发布）

> AnchorHub-wails 模板会在 `CHANGELOG.md` 记录每次模板侧的版本基线变化。
