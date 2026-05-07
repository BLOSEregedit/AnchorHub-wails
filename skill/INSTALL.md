# AnchorHub-wails Skill 安装说明

> Skill 名称统一为 `anchorhub-wails`。安装前请先确保本地已有 AnchorHub-wails 仓库。

## 一、准备模板仓库

如果本地还没有模板仓库，先克隆：

```bash
cd ~/GoProject
git clone <你的 AnchorHub-wails GitHub 地址> AnchorHub-wails
```

如果本地已经有：

```text
/Users/curie/GoProject/AnchorHub-wails
```

可以直接进入下面的平台安装。

## 二、Claude Code / Claude CLI

安装：

```bash
mkdir -p ~/.claude/skills
ln -sfn /Users/curie/GoProject/AnchorHub-wails/adapters/claude ~/.claude/skills/anchorhub-wails
```

卸载：

```bash
rm -f ~/.claude/skills/anchorhub-wails
```

使用：

```text
/skill anchorhub-wails
```

或直接说：

```text
用 AnchorHub-wails 新建一个 Wails 桌面工具，叫 PdfMerger。
```

## 三、Codex CLI / Codex App

安装：

```bash
mkdir -p ~/.codex/skills
ln -sfn /Users/curie/GoProject/AnchorHub-wails/adapters/codex ~/.codex/skills/anchorhub-wails
```

卸载：

```bash
rm -f ~/.codex/skills/anchorhub-wails
```

使用：

```text
用 AnchorHub-wails 创建一个新的 Wails 桌面程序，名字叫 ShenNong，放到 ~/GoProject/ShenNong。
```

## 四、Gemini CLI

安装：

```bash
mkdir -p ~/.gemini/skills
ln -sfn /Users/curie/GoProject/AnchorHub-wails/adapters/gemini ~/.gemini/skills/anchorhub-wails
```

卸载：

```bash
rm -f ~/.gemini/skills/anchorhub-wails
```

使用：

```text
使用 AnchorHub-wails 模板创建一个新的 Wails 桌面工具，名字叫 PdfMerger。
```

## 五、手动创建项目

不通过 Skill，也可以直接执行脚本：

```bash
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh ~/GoProject/MyTool
```

非交互式：

```bash
TARGET_DIR=~/GoProject/MyTool \
APP_NAME=MyTool \
APP_TITLE="我的工具" \
BUNDLE_ID=com.curie.mytool \
bash /Users/curie/GoProject/AnchorHub-wails/scripts/create-project.sh --non-interactive
```

如果要自动安装依赖，追加 `--upgrade`。

## 六、更新 Skill

因为安装方式是软链，更新模板仓库即可同步 Skill：

```bash
git -C /Users/curie/GoProject/AnchorHub-wails pull --ff-only
```
