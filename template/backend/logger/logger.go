// Package logger 提供本地日志持久化能力
//
// 可选模块：如果应用不需要操作日志记录，可删除整个 logger 目录。
//
// 日志文件路径：~/.{{APP_NAME_LOWER}}/logs/app.log（JSON 数组）
// 提供 Info / Warn / Error 三个级别，每条日志带 ID / Timestamp / Action / Message / Detail。
package logger

import (
	"encoding/json"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/google/uuid"
)

// LogLevel 日志级别
type LogLevel string

const (
	LevelInfo  LogLevel = "INFO"
	LevelWarn  LogLevel = "WARN"
	LevelError LogLevel = "ERROR"
)

// LogEntry 日志条目
type LogEntry struct {
	ID        string    `json:"id"`
	Timestamp time.Time `json:"timestamp"`
	Level     LogLevel  `json:"level"`
	Action    string    `json:"action"`
	Message   string    `json:"message"`
	Detail    string    `json:"detail,omitempty"`
}

// Logger 日志管理器
type Logger struct {
	logFile string
	logs    []LogEntry
	mu      sync.RWMutex
}

// NewLogger 创建日志管理器
// 日志目录：~/.{{APP_NAME_LOWER}}/logs/
func NewLogger() (*Logger, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}

	logDir := filepath.Join(homeDir, ".{{APP_NAME_LOWER}}", "logs")
	logFile := filepath.Join(logDir, "app.log")

	if err := os.MkdirAll(logDir, 0700); err != nil {
		return nil, err
	}

	l := &Logger{
		logFile: logFile,
		logs:    []LogEntry{},
	}

	if err := l.load(); err != nil && !os.IsNotExist(err) {
		return nil, err
	}

	return l, nil
}

func (l *Logger) load() error {
	l.mu.Lock()
	defer l.mu.Unlock()

	data, err := os.ReadFile(l.logFile)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, &l.logs)
}

func (l *Logger) save() error {
	data, err := json.MarshalIndent(l.logs, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(l.logFile, data, 0600)
}

// Log 写入一条日志
func (l *Logger) Log(level LogLevel, action, message, detail string) error {
	l.mu.Lock()
	defer l.mu.Unlock()

	entry := LogEntry{
		ID:        uuid.New().String(),
		Timestamp: time.Now(),
		Level:     level,
		Action:    action,
		Message:   message,
		Detail:    detail,
	}

	l.logs = append(l.logs, entry)
	return l.save()
}

// Info 记录 INFO 级别日志
func (l *Logger) Info(action, message string) error {
	return l.Log(LevelInfo, action, message, "")
}

// InfoWithDetail 记录 INFO 级别日志（带详情）
func (l *Logger) InfoWithDetail(action, message, detail string) error {
	return l.Log(LevelInfo, action, message, detail)
}

// Warn 记录 WARN 级别日志
func (l *Logger) Warn(action, message string) error {
	return l.Log(LevelWarn, action, message, "")
}

// WarnWithDetail 记录 WARN 级别日志（带详情）
func (l *Logger) WarnWithDetail(action, message, detail string) error {
	return l.Log(LevelWarn, action, message, detail)
}

// Error 记录 ERROR 级别日志
func (l *Logger) Error(action, message string) error {
	return l.Log(LevelError, action, message, "")
}

// ErrorWithDetail 记录 ERROR 级别日志（带详情）
func (l *Logger) ErrorWithDetail(action, message, detail string) error {
	return l.Log(LevelError, action, message, detail)
}

// GetLogs 获取最近 limit 条日志（倒序，最新在前）
// limit <= 0 或大于总数时返回全部
func (l *Logger) GetLogs(limit int) []LogEntry {
	l.mu.RLock()
	defer l.mu.RUnlock()

	if limit <= 0 || limit > len(l.logs) {
		limit = len(l.logs)
	}

	start := len(l.logs) - limit
	result := make([]LogEntry, limit)
	for i := 0; i < limit; i++ {
		result[limit-1-i] = l.logs[start+i]
	}
	return result
}

// Clear 清空所有日志
func (l *Logger) Clear() error {
	l.mu.Lock()
	defer l.mu.Unlock()

	l.logs = []LogEntry{}
	return l.save()
}
