package main

import (
	"context"
	"embed"
	"log"

	"{{APP_NAME}}/backend"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"github.com/wailsapp/wails/v2/pkg/options/mac"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
)

//go:embed all:frontend/dist
var assets embed.FS

func main() {
	app := backend.NewApp()

	err := wails.Run(&options.App{
		Title:     "{{APP_TITLE}}",
		Width:     {{WINDOW_WIDTH}},
		Height:    {{WINDOW_HEIGHT}},
		MinWidth:  {{WINDOW_WIDTH}},
		MinHeight: {{WINDOW_HEIGHT}},
		AssetServer: &assetserver.Options{
			Assets: assets,
		},
		BackgroundColour: &options.RGBA{R: 255, G: 255, B: 255, A: 1},
		OnStartup: func(ctx context.Context) {
			if err := app.Startup(ctx); err != nil {
				log.Fatalf("startup failed: %v", err)
			}
		},
		// 文件拖拽支持（如不需要可移除）
		DragAndDrop: &options.DragAndDrop{
			EnableFileDrop:     true,
			DisableWebViewDrop: true,
		},
		Bind: []interface{}{app},
		Mac: &mac.Options{
			TitleBar:             mac.TitleBarDefault(),
			WebviewIsTransparent: false,
			WindowIsTranslucent:  false,
		},
		Windows: &windows.Options{
			WebviewIsTransparent:              false,
			WindowIsTranslucent:               false,
			DisableWindowIcon:                 false,
			WebviewBrowserPath:                "",
			BackdropType:                      windows.None,
			DisableFramelessWindowDecorations: false,
		},
	})
	if err != nil {
		log.Fatal(err)
	}
}
