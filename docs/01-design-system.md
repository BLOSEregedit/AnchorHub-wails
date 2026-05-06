# 设计规范（Design System）

> 提炼自 TidyBilling、Invoice2OSS 两个 Wails 项目，精确到 px 的可复用设计规范。

## 一、设计哲学

- **苹果风格（Apple-inspired）**：克制、留白、圆润、系统色
- **侧边栏 + 内容区**：经典桌面工具布局（左导航 + 右内容）
- **浅色为主，可选暗黑**：默认浅色 `#f5f7fa` 背景，可启用暗黑切换

## 二、布局规范

### 整体结构
```
┌─────────────────────────────────────┐
│  NConfigProvider                    │
│  └── NMessageProvider               │
│      └── NDialogProvider            │
│          └── NNotificationProvider  │
│              └── NLayout has-sider  │
│                  ├── NLayoutSider   │ width=200
│                  └── NLayoutContent │ background=#f5f7fa
└─────────────────────────────────────┘
```

### 关键尺寸（必须严格遵守）

| 元素 | 数值 | 说明 |
|---|---|---|
| 侧边栏宽度 | `200px` | 固定，不折叠 |
| Logo 区 padding | `20px` | 上下左右一致 |
| Logo `<h2>` margin | `0` | 不留默认外边距 |
| 内容区背景 | `#f5f7fa` | 浅灰，区分侧边栏 |
| 滚动条 | `:native-scrollbar="false"` | 用 Naive 自定义滚动条 |
| 卡片圆角 | `20px` | 内容卡片 |
| 按钮圆角 | `8px` | 标准按钮 |
| 按钮高度 | `42px` | 主操作按钮 |
| 卡片内边距 | `padding: 20px 24px` | 内容区外层容器 |
| 卡片间距 | `n-space :size="16"` | 垂直堆叠 |

### 窗口尺寸（main.go）

| 类型 | 宽度 | 高度 | 备注 |
|---|---|---|---|
| 紧凑型 | 1100 | 900 | Invoice2OSS 风格 |
| 标准型 | 1180 | 980 | TidyBilling 风格 |
| 推荐 | **1180** | **900** | 兼容大多数工具 |

- `BackgroundColour: RGBA{255, 255, 255, 1}`
- `Mac.TitleBar: TitleBarDefault()`
- `WebviewIsTransparent: false`
- `WindowIsTranslucent: false`

## 三、色板（Apple-inspired）

### 主色系

| 用途 | 色值 | 备注 |
|---|---|---|
| 主色 Primary | `#007AFF` | Apple Blue（iOS 系统色） |
| 主色 Hover | `#005FD5` | |
| 主色 Pressed | `#004FB5` | |
| 成功 Success | `#34C759` | Apple Green |
| 警告 Warning | `#FF9500` | Apple Orange |
| 错误 Error | `#FF3B30` | Apple Red |
| 信息 Info | `#5AC8FA` | Apple Cyan |

### 中性色

| 用途 | 色值 |
|---|---|
| 内容区背景 | `#f5f7fa` |
| 卡片背景 | `#FFFFFF` |
| 文本（主） | `#1F2937` |
| 文本（次） | `#4B5563` |
| 文本（弱） | `#6B7280` |
| 边框（弱） | `rgba(0, 0, 0, 0.06)` |

### 暗黑模式（可选）

| 用途 | 色值 |
|---|---|
| 窗口背景 | `RGBA{34, 34, 34, 255}` |
| 卡片背景 | `#2C2C2C` |
| 边框 | `#4C4C4C` |

## 四、圆角规范

| 元素 | 圆角 | 说明 |
|---|---|---|
| 小按钮 / Tag | `6px` | |
| 标准按钮 / 输入框 | `8px` | |
| 大按钮 | `12px` | |
| 卡片（小） | `12px` | |
| 卡片（标准） | `16px` | |
| 卡片（大） | `20px` | TidyBilling 用 |
| Dialog | `16px` | |
| Progress 条 | `9999px` | 全圆 |

## 五、字体规范

### 字体栈
```css
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
  "Helvetica Neue", Arial, "Noto Sans", sans-serif,
  "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
```

### 字号

| 用途 | 字号 | 字重 |
|---|---|---|
| 卡片标题 | `18px` | 600 |
| 大卡片标题 | `20px` | 600 |
| 菜单项 | `15px` | 500 |
| 正文 | `14px` | 400 |
| 辅助说明 | `12px` | 400 |
| Logo（H2） | 默认 | 默认 |

### 字重
- 强调字重统一使用 `600`（Semi-bold，Apple 标准）
- 普通文本使用 `400`
- 菜单/导航使用 `500`

## 六、阴影规范

| 用途 | 阴影 |
|---|---|
| 卡片（标准） | `0 4px 12px rgba(0, 0, 0, 0.1)` |
| 浮动元素 | `0 4px 12px rgba(0, 0, 0, 0.15)` |
| Dialog | `0 8px 32px rgba(0, 0, 0, 0.18)` |
| 侧边栏 | `4px 0 24px rgba(0, 0, 0, 0.04)` |

## 七、图标系统

- **图标库**：`@vicons/ionicons5`（Ionicons 5）
- **使用方式**：通过 `<n-icon>` 包裹
- **菜单图标尺寸**：默认（约 18px）
- **大尺寸图标**：`size="36"` 用于上传区等空状态

### 常用图标参考
| 场景 | 图标名 |
|---|---|
| 文件上传 | `CloudUploadOutline` |
| 设置 | `SettingsOutline` |
| 日志 | `DocumentTextOutline` |
| 暗黑模式 | `MoonOutline` |
| 浅色模式 | `SunnyOutline` |

## 八、交互细节

### 拖拽上传
- 通过 Wails 的 `OnFileDrop` 接收原生拖拽
- 在 `main.go` 配置 `DragAndDrop.EnableFileDrop = true`
- 在 `DragAndDrop.DisableWebViewDrop = true` 阻止浏览器默认行为
- 在 CSS 中使用 `--wails-drop-target: drop` 标记目标区域

### 按钮交互
- 主操作按钮：`type="primary"` + 标准圆角 8px
- 次要操作：`ghost` 修饰
- 禁用状态：`:disabled="loading"`

### 进度反馈
- 后端通过 `runtime.EventsEmit` 发事件
- 前端通过 `EventsOn` 监听
- 事件命名规范：`<domain>:<action>:<state>`，如 `billing:process:progress`

## 九、参考文件

模板内的实现请见：
- `template/frontend/src/App.vue` —— 整体布局壳
- `template/frontend/src/config/theme.ts` —— Naive UI 主题覆盖（如启用）
- `template/main.go` —— 窗口配置
