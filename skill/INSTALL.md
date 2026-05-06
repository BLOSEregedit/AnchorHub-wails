# AnchorHub-wails Skill 安装说明

> 把这个 Skill 安装到 Claude Code，让 AI 自动帮你初始化新的 Wails 项目。

## 一、安装方式

### 方式 A：全局安装（推荐，所有项目可用）

```bash
mkdir -p ~/.claude/skills/anchorhub-wails
cp /Users/curie/GoProject/AnchorHub-wails/skill/SKILL.md ~/.claude/skills/anchorhub-wails/
```

### 方式 B：项目级安装（仅当前项目可用）

```bash
mkdir -p .claude/skills/anchorhub-wails
cp /path/to/AnchorHub-wails/skill/SKILL.md .claude/skills/anchorhub-wails/
```

### 方式 C：用软链（保持同步更新）

```bash
mkdir -p ~/.claude/skills
ln -s /Users/curie/GoProject/AnchorHub-wails/skill ~/.claude/skills/anchorhub-wails
```

## 二、使用方式

### 显式调用

在 Claude Code 中输入：

```
/skill anchorhub-wails
```

### 自然语言触发

直接对话即可（Claude 会根据 description 自动识别）：

- "用 AnchorHub 模板新建一个 Wails 项目"
- "帮我创建一个 Wails 桌面工具，叫 PdfMerger"
- "复用我那套 Wails 模板，做一个截图工具"

## 三、Skill 会做什么

1. **询问关键参数**：应用名、标题、目标目录、可选模块
2. **复制模板**：从 `template/` 复制完整骨架到目标目录
3. **替换占位符**：调用 `scripts/init-project.sh --non-interactive`
4. **裁剪可选模块**：根据用户选择删除不需要的代码
5. **输出下一步指引**：但**不会自动**执行 `npm install` / `wails dev` / `git init`

## 四、Skill 不会做什么

为了避免破坏用户环境，Skill 故意**不会**：

- ❌ 自动安装 Go / npm 依赖（避免锁文件冲突）
- ❌ 自动生成图标（用户得先准备 `icon.png`）
- ❌ 自动 `git init` 或 commit
- ❌ 修改已存在的文件（如目标目录非空会警告）

这些操作请用户手动执行，更安全可控。

## 五、更新 Skill

模板有变更时，重新复制即可（用方式 C 软链则自动同步）：

```bash
cp /Users/curie/GoProject/AnchorHub-wails/skill/SKILL.md ~/.claude/skills/anchorhub-wails/
```

## 六、卸载 Skill

```bash
rm -rf ~/.claude/skills/anchorhub-wails
```
