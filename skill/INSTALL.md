# AnchorHub-wails AI 接入说明

> 推荐用软链引用仓库内入口文件，避免 Claude、Codex、Gemini 各自维护一份漂移的规则。

## 一、入口选择

| 平台 | 推荐入口 |
|---|---|
| Claude Code / Claude CLI | `skill/SKILL.md` 或 `adapters/claude/SKILL.md` |
| Codex CLI | `adapters/codex/SKILL.md` |
| Codex App | `adapters/codex/SKILL.md` |
| Gemini CLI | `adapters/gemini/GEMINI.md` |
| 其他 Agent | `adapters/common/anchorhub-wails.prompt.md` |

所有入口都应回到同一份公共协议：

```text
/Users/curie/GoProject/AnchorHub-wails/docs/04-agent-usage-protocol.md
```

## 二、Claude Code / Claude CLI

兼容旧路径，推荐软链到 `skill/`：

```bash
mkdir -p ~/.claude/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/skill ~/.claude/skills/anchorhub-wails
```

如果想直接使用新的薄入口，也可以软链 `adapters/claude`：

```bash
mkdir -p ~/.claude/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/adapters/claude ~/.claude/skills/anchorhub-wails
```

使用示例：

```text
/skill anchorhub-wails
```

或自然语言：

```text
用 AnchorHub-wails 新建一个 Wails 桌面工具，叫 PdfMerger。
```

## 三、Codex CLI

推荐软链到 Codex skills 目录：

```bash
mkdir -p ~/.codex/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/adapters/codex ~/.codex/skills/anchorhub-wails
```

如果当前 Codex CLI 只支持显式引用文件，就让它读取：

```text
/Users/curie/GoProject/AnchorHub-wails/adapters/codex/SKILL.md
```

## 四、Codex App

推荐使用仓库内 `adapters/codex/SKILL.md` 作为本地 skill/说明入口。若 App 支持技能目录软链：

```bash
mkdir -p ~/.codex/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/adapters/codex ~/.codex/skills/anchorhub-wails
```

在 Codex App 中使用时，直接说：

```text
使用 AnchorHub-wails 创建一个新的 Wails 类程序。
```

## 五、Gemini CLI

如果 Gemini CLI 支持全局上下文文件，推荐引用：

```text
/Users/curie/GoProject/AnchorHub-wails/adapters/gemini/GEMINI.md
```

也可以软链到本地约定目录：

```bash
mkdir -p ~/.gemini/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/adapters/gemini ~/.gemini/skills/anchorhub-wails
```

如果 Gemini CLI 只能粘贴 prompt，使用：

```text
/Users/curie/GoProject/AnchorHub-wails/adapters/common/anchorhub-wails.prompt.md
```

## 六、一条命令创建项目

任何平台无法自动执行完整流程时，至少应给出这类命令让用户手动运行：

```bash
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh ~/GoProject/MyTool
```

非交互式示例：

```bash
TARGET_DIR=~/GoProject/MyTool \
APP_NAME=MyTool \
APP_TITLE="我的工具" \
BUNDLE_ID=com.curie.mytool \
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh --non-interactive
```

如用户明确要求自动安装依赖，追加 `--upgrade`。

## 七、维护原则

- 不要在四个平台里维护四份完整规则。
- 修改流程、设计约束或开发规范时，优先改 `docs/04-agent-usage-protocol.md` 和对应核心文档。
- 平台入口只负责触发、读取上下文和说明平台差异。
