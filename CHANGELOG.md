# CHANGELOG

> AnchorHub-wails 模板的迭代记录。基于此模板创建的项目可参考此文件手动同步关键改动。

格式参考：[Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [Unreleased]

### 新增

- 新增 `scripts/create-project.sh`
  - 支持一条命令从 `template/` 复制模板到目标目录，并自动调用 `scripts/init-project.sh`
  - 支持交互式与环境变量驱动的 `--non-interactive` 模式
  - 目标目录非空时默认拒绝，避免误覆盖现有内容
  - 支持透传 `--upgrade`，初始化后自动安装最新稳定版依赖
- `scripts/init-project.sh` 补充 `--help` 与未知参数校验

### 文档

- `README.md` 快速使用改为优先推荐 `scripts/create-project.sh`
- 补充一键创建与非交互式初始化示例

## [0.2.0] - 版本策略改为「最新稳定版」

### 变更

- **版本策略**：从"锁定具体版本"改为"始终拉取最新稳定版"
  - 原因：之前从生产项目里照搬版本号，等模板用到下个项目时可能已经过时
  - 实现：
    - `template/frontend/package.json` 所有依赖改为 `"latest"`
    - `template/go.mod` 仅留基线，注释中提示用 `go get -u ...@latest`
    - 新增 `npm run upgrade-latest` 脚本（前端一键升级到最新稳定版）
    - `scripts/init-project.sh` 新增 `--upgrade` 参数，初始化后自动 `go get -u` + `npm install`
- 所有文档（`docs/02-tech-stack.md`、`README.md`、`template/README.md`、`skill/SKILL.md`）同步更新版本表述
- 文档中保留"最低支持版本"作为兼容性兜底

### 备注

老项目已经依赖锁定的具体版本号也无需改动，按需 `go get -u` / `npm update` 即可。

## [0.1.0] - 初始版本

### 新增

- 完整的 Wails v2 + Vue 3 + Naive UI 模板骨架
- 设计规范文档（`docs/01-design-system.md`）：精确到 px 的布局、色板、圆角、阴影
- 技术栈文档（`docs/02-tech-stack.md`）：版本锁定与选型理由
- 使用指南（`docs/03-usage-guide.md`）：从零启动新项目的完整步骤
- 双平台构建脚本（`build-all.sh`）：macOS Universal + Windows amd64
- 图标自动生成脚本（`set-icon.sh`）：从 1024x1024 PNG 生成 .icns + .ico
- 占位符替换脚本（`scripts/init-project.sh`）：交互式初始化新项目
- Claude Skill 定义（`skill/SKILL.md`）：AI 辅助初始化新项目

### 模板内容

#### 后端
- `main.go`：Wails 入口，含窗口配置、双平台选项、拖拽配置
- `backend/app.go`：App 结构体 + 通用方法（文件选择、目录打开、事件辅助、主题切换）
- `backend/events/types.go`：事件常量与 payload 类型
- `backend/logger/logger.go`：（可选）本地 JSON 日志持久化
- `backend/config/manager.go`：（可选）配置持久化

#### 前端
- `frontend/src/main.ts`：createApp + Pinia + Router
- `frontend/src/App.vue`：NConfigProvider 布局壳，侧边栏 200px，内容区 #f5f7fa
- `frontend/src/router/index.ts`：vue-router Hash 模式
- `frontend/src/views/Home.vue`：示例首页
- `frontend/src/services/wails.ts`：Wails API 统一封装层
- `frontend/src/utils/format.ts`：格式化工具（文件大小、时间戳、路径截断）
- `frontend/src/types/events.ts`：事件类型定义

### 提炼来源
- TidyBilling：单页 + 进度事件 + 拖拽上传
- Invoice2OSS：多页 + 暗黑主题 + 日志 + 配置持久化
