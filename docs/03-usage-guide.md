# 使用指南（Usage Guide）

> 如何用 AnchorHub-wails 模板快速启动一个新的 Wails 桌面工具。

## 一、两种使用方式

### 方式 A：手动复制（最简单，推荐）

```bash
# 1. 创建新项目目录
mkdir ~/GoProject/MyNewApp
cd ~/GoProject/MyNewApp

# 2. 从模板复制文件
cp -R /path/to/AnchorHub-wails/template/. .

# 3. 全局替换占位符（见下文）
# 4. 安装依赖、初始化 git
```

### 方式 B：用 Claude Skill（推荐，AI 自动化）

在 Claude Code 中输入：

```
/skill wails-app
```

或直接对话：

> "用 AnchorHub-wails 模板创建一个新的 Wails 项目，名字叫 XxxTool，功能是 XXX"

Claude 会自动：
1. 询问关键参数（应用名、bundleId、可选模块）
2. 复制模板文件
3. 替换所有占位符
4. 提示下一步操作（安装依赖、生成图标等）

## 二、占位符清单

模板中使用了以下占位符，启动新项目时需全部替换：

| 占位符 | 含义 | 示例 |
|---|---|---|
| `{{APP_NAME}}` | 应用名（PascalCase，无空格） | `MyTool` |
| `{{APP_NAME_LOWER}}` | 应用名小写（用于路径） | `mytool` |
| `{{APP_TITLE}}` | 应用标题（可含中文/空格） | `我的工具` |
| `{{APP_DESCRIPTION}}` | 应用简介 | `处理 XX 文件的桌面工具` |
| `{{BUNDLE_ID}}` | macOS bundleId | `com.curie.mytool` |
| `{{COMPANY_NAME}}` | 公司/作者名 | `Curie` |
| `{{AUTHOR_EMAIL}}` | 作者邮箱（可空） | `you@example.com` |
| `{{COPYRIGHT_YEAR}}` | 版权年份 | `2026` |
| `{{WINDOW_WIDTH}}` | 窗口宽度 | `1180` |
| `{{WINDOW_HEIGHT}}` | 窗口高度 | `900` |

### 全局替换命令（macOS / Linux）

```bash
cd ~/GoProject/MyNewApp

# 用 sed 批量替换（注意 macOS 的 sed 需要 ''）
find . -type f \( -name "*.go" -o -name "*.json" -o -name "*.ts" -o -name "*.vue" -o -name "*.md" -o -name "*.sh" -o -name "*.html" \) \
  -not -path "./node_modules/*" -not -path "./.git/*" \
  -exec sed -i '' 's/{{APP_NAME}}/MyTool/g' {} \;

# 重复以上命令替换其他占位符
```

或用一键脚本（模板内 `scripts/init.sh`，按需创建）。

## 三、首次启动步骤

替换占位符后：

```bash
# 1. 初始化 Go 模块（如果模板里 go.mod 不能直接用）
go mod tidy

# 2. 安装前端依赖
cd frontend
npm install
cd ..

# 3. 准备应用图标（1024x1024 PNG，放项目根）
cp /path/to/your-icon.png ./icon.png

# 4. 生成图标（macOS 上需要 ImageMagick，brew install imagemagick）
chmod +x set-icon.sh
./set-icon.sh

# 5. 启动开发模式
wails dev

# 6. 双平台打包
chmod +x build-all.sh
./build-all.sh
```

## 四、按需启用可选模块

模板默认提供**最小骨架**，以下模块需手动启用：

### 1. 暗黑主题切换

参考 Invoice2OSS 的 `App.vue` + `backend/app.go` 中的 `SetDarkMode` 方法。

**前端**：
- 在 `App.vue` 中添加 `NSwitch` + `darkTheme` 切换
- 用 `provide('isDark', isDark)` 透传给子组件

**后端**：
- 在 `backend/app.go` 添加 `SetDarkMode(isDark bool)` 方法
- 调用 `runtime.WindowSetDarkTheme` / `runtime.WindowSetLightTheme`

### 2. 本地日志持久化

启用 `backend/logger/logger.go`（已在模板内）：
- 日志路径：`~/.{{APP_NAME_LOWER}}/logs/app.log`
- 提供 `Info / Warn / Error / GetLogs / Clear` 接口
- 在 `app.go` 的 `Startup` 中初始化

### 3. 配置持久化

参考 Invoice2OSS 的 `backend/config/manager.go` 模式：
- 配置路径：`~/.{{APP_NAME_LOWER}}/config.json`
- 提供 CRUD + 默认配置接口

### 4. 进度事件

模板已预置 `backend/events/types.go`：
- 定义事件常量（`<domain>:<action>:<state>`）
- 后端 `runtime.EventsEmit(ctx, eventName, payload)`
- 前端 `EventsOn(eventName, callback)` 监听

## 五、常见问题

### Q1：`wails dev` 报端口占用？
A：默认端口 34115，改 `frontend/vite.config.ts` 的 `server.port`。

### Q2：macOS 打包后图标显示默认 Wails Logo？
A：检查 `build/darwin/appicon.icns` 是否生成，重新跑 `./set-icon.sh`。

### Q3：Windows 打包没有 .ico？
A：安装 ImageMagick：`brew install imagemagick`（macOS）或下载 Windows 版。

### Q4：拖拽文件没反应？
A：检查 `main.go` 是否有 `DragAndDrop.EnableFileDrop = true`，并在 CSS 目标元素上加 `--wails-drop-target: drop`。

### Q5：前端调用后端方法报 undefined？
A：执行 `wails dev` 一次会自动生成 `frontend/wailsjs/`，确保 `frontend/.gitignore` 没把它列进去（运行时需要）。

## 六、开发流程建议

1. **先想清楚业务**：列出需要哪些后端方法（文件选择、处理、保存等）
2. **设计事件流**：长耗时操作走 Events 而不是同步返回
3. **后端按 domain 拆包**：`backend/<domain>/` 一个领域一个包
4. **前端按 view 拆**：每个菜单项一个 `views/Xxx.vue` + 对应 `stores/xxxStore.ts`
5. **API 走 services 层**：所有 wailsjs 调用集中到 `services/wails.ts`，不要散在组件里

## 七、参考实现

完整功能参考两个原始项目：
- **TidyBilling**：单页 + 进度事件 + 拖拽上传（最小子集）
- **Invoice2OSS**：多页 + 暗黑主题 + 日志 + 配置持久化（完整子集）
