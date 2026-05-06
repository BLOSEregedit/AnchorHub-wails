package backend

import (
	"context"
	"fmt"
	"os/exec"
	"path/filepath"
	"runtime"

	"{{APP_NAME}}/backend/events"

	wruntime "github.com/wailsapp/wails/v2/pkg/runtime"
)

// App 应用结构体，所有暴露给前端的方法都挂在这里
type App struct {
	ctx context.Context
	// 在这里持有业务 manager 指针，例如：
	// configManager *config.Manager
	// logger        *logger.Logger
}

// NewApp 创建 App 实例
func NewApp() *App {
	return &App{}
}

// Startup 在应用启动时调用
// 在这里初始化 manager、加载配置、写启动日志等
func (a *App) Startup(ctx context.Context) error {
	a.ctx = ctx

	// 示例：初始化 logger
	// l, err := logger.NewLogger()
	// if err != nil {
	//     return fmt.Errorf("failed to init logger: %w", err)
	// }
	// a.logger = l

	return nil
}

// =========================== 通用 API ===========================

// SelectFile 打开单文件选择对话框
func (a *App) SelectFile(title string, displayName string, pattern string) (string, error) {
	if a.ctx == nil {
		return "", nil
	}
	return wruntime.OpenFileDialog(a.ctx, wruntime.OpenDialogOptions{
		Title: title,
		Filters: []wruntime.FileFilter{
			{DisplayName: displayName, Pattern: pattern},
		},
	})
}

// SelectFiles 打开多文件选择对话框
func (a *App) SelectFiles(title string, displayName string, pattern string) ([]string, error) {
	if a.ctx == nil {
		return nil, nil
	}
	return wruntime.OpenMultipleFilesDialog(a.ctx, wruntime.OpenDialogOptions{
		Title: title,
		Filters: []wruntime.FileFilter{
			{DisplayName: displayName, Pattern: pattern},
		},
	})
}

// SelectDirectory 打开目录选择对话框
func (a *App) SelectDirectory(title string, defaultDir string) (string, error) {
	if a.ctx == nil {
		return "", nil
	}
	return wruntime.OpenDirectoryDialog(a.ctx, wruntime.OpenDialogOptions{
		Title:            title,
		DefaultDirectory: defaultDir,
	})
}

// OpenDirectory 在系统文件管理器中打开目录或定位文件
// path 可以是目录或文件路径
func (a *App) OpenDirectory(path string) error {
	target := filepath.Clean(path)

	var cmd *exec.Cmd
	switch runtime.GOOS {
	case "darwin":
		if filepath.Ext(target) != "" {
			cmd = exec.Command("open", "-R", target)
		} else {
			cmd = exec.Command("open", target)
		}
	case "windows":
		if filepath.Ext(target) != "" {
			cmd = exec.Command("explorer", "/select,"+target)
		} else {
			cmd = exec.Command("explorer", target)
		}
	default:
		if filepath.Ext(target) != "" {
			cmd = exec.Command("xdg-open", filepath.Dir(target))
		} else {
			cmd = exec.Command("xdg-open", target)
		}
	}

	if err := cmd.Start(); err != nil {
		return fmt.Errorf("打开目录失败: %w", err)
	}
	return nil
}

// =========================== 事件辅助 ===========================

// emitProgress 发送进度事件给前端
// stage: 阶段标识（如 reading_file / processing / writing）
// message: 用户可见的中文提示
func (a *App) emitProgress(eventName, stage, message string) {
	if a.ctx == nil {
		return
	}
	wruntime.EventsEmit(a.ctx, eventName, events.ProcessProgressEvent{
		Stage:   stage,
		Message: message,
	})
}

// emitError 发送错误事件
func (a *App) emitError(message string) {
	if a.ctx == nil {
		return
	}
	wruntime.EventsEmit(a.ctx, events.EventProcessError, events.ProcessProgressEvent{
		Stage:   "error",
		Message: message,
	})
}

// emitSuccess 发送成功事件
func (a *App) emitSuccess(payload interface{}) {
	if a.ctx == nil {
		return
	}
	wruntime.EventsEmit(a.ctx, events.EventProcessSuccess, payload)
}

// =========================== 主题管理（可选） ===========================
// 如果不需要暗黑模式切换，删除以下方法

// SetDarkMode 设置窗口暗黑模式
// 在 macOS 上会同步更新标题栏外观
func (a *App) SetDarkMode(isDark bool) {
	if a.ctx == nil {
		return
	}
	if isDark {
		wruntime.WindowSetBackgroundColour(a.ctx, 34, 34, 34, 255)
		wruntime.WindowSetDarkTheme(a.ctx)
	} else {
		wruntime.WindowSetBackgroundColour(a.ctx, 255, 255, 255, 255)
		wruntime.WindowSetLightTheme(a.ctx)
	}
}
