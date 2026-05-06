// Package events 定义前后端通信的事件常量与 payload 类型
//
// 命名规范：<domain>:<action>:<state>
// 例如：file:upload:progress / billing:process:error
//
// 后端通过 runtime.EventsEmit 发事件，前端通过 EventsOn 监听。
package events

// ProcessProgressEvent 通用进度事件 payload
// 适用于大多数"长耗时任务"的进度推送
type ProcessProgressEvent struct {
	Stage   string `json:"stage"`   // 阶段标识，如 reading / processing / writing
	Message string `json:"message"` // 用户可见的中文提示
}

// FileStatusEvent 文件状态更新事件 payload
// 适用于批量文件处理场景（如批量上传、批量转换）
type FileStatusEvent struct {
	FileID string `json:"file_id"`
	Status string `json:"status"`         // pending / processing / success / failed
	Error  string `json:"error,omitempty"`
}

// =========================== 事件常量 ===========================
// 替换 process 为你的业务领域名，如 billing / upload / convert

const (
	EventProcessStart    = "process:start"
	EventProcessProgress = "process:progress"
	EventProcessSuccess  = "process:success"
	EventProcessError    = "process:error"

	// 批量文件处理事件
	EventFileStatusUpdate = "file:status:update"
)
