module {{APP_NAME}}

go 1.25

// 注意：以下版本号只是基线占位，初始化项目后请执行：
//   go get -u github.com/wailsapp/wails/v2@latest
//   go mod tidy
// 来拉取最新稳定版本（init-project.sh 在 --upgrade 模式下会自动执行）。
require (
	github.com/wailsapp/wails/v2 v2.11.0
)
