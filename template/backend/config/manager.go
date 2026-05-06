// Package config 提供应用配置的本地持久化能力
//
// 可选模块：如果应用不需要保存用户偏好/凭证，可删除整个 config 目录。
//
// 配置文件路径：~/.{{APP_NAME_LOWER}}/config.json
//
// 此模板提供单文件配置（适合保存全局偏好），
// 如需"多条配置项管理"（如多个 OSS 凭证），参考 Invoice2OSS 的 config.Manager 自行扩展。
package config

import (
	"encoding/json"
	"os"
	"path/filepath"
	"sync"
)

// AppConfig 应用配置结构
// 在这里添加你的配置字段
type AppConfig struct {
	// 示例字段，按需修改/删除
	LastInputDir  string `json:"lastInputDir,omitempty"`
	LastOutputDir string `json:"lastOutputDir,omitempty"`
	Theme         string `json:"theme,omitempty"` // "light" | "dark"
}

// Manager 配置管理器
type Manager struct {
	configFile string
	config     AppConfig
	mu         sync.RWMutex
}

// NewManager 创建配置管理器
func NewManager() (*Manager, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}

	configDir := filepath.Join(homeDir, ".{{APP_NAME_LOWER}}")
	configFile := filepath.Join(configDir, "config.json")

	if err := os.MkdirAll(configDir, 0700); err != nil {
		return nil, err
	}

	m := &Manager{
		configFile: configFile,
	}

	if err := m.load(); err != nil && !os.IsNotExist(err) {
		return nil, err
	}

	return m, nil
}

func (m *Manager) load() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	data, err := os.ReadFile(m.configFile)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, &m.config)
}

func (m *Manager) save() error {
	data, err := json.MarshalIndent(m.config, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(m.configFile, data, 0600)
}

// Get 获取当前配置（值拷贝，避免外部修改内部状态）
func (m *Manager) Get() AppConfig {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.config
}

// Update 更新配置
func (m *Manager) Update(cfg AppConfig) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.config = cfg
	return m.save()
}
