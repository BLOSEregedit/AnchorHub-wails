/**
 * Wails API 统一封装层
 *
 * 设计原则：
 * - 所有 wailsjs 调用集中在这里，组件不直接 import wailsjs
 * - 便于：1) 单元测试 mock；2) 类型增强；3) 后续替换实现
 *
 * 使用方式：
 *   import { SelectFile, OpenDirectory } from '@/services/wails'
 *
 * 注意：wailsjs/ 目录由 Wails 在 `wails dev` 或 `wails build` 时自动生成。
 * 首次启动时如报路径不存在，先执行 `wails dev` 一次。
 */

import * as App from '../../wailsjs/go/backend/App'
import { EventsOn, EventsOff } from '../../wailsjs/runtime/runtime'

// =========================== 通用 API ===========================

export const SelectFile = App.SelectFile
export const SelectFiles = App.SelectFiles
export const SelectDirectory = App.SelectDirectory
export const OpenDirectory = App.OpenDirectory

// =========================== 主题（可选） ===========================
// 如启用暗黑主题切换，取消注释：
// export const SetDarkMode = App.SetDarkMode

// =========================== 事件订阅 ===========================

/**
 * 监听后端事件
 * @param eventName 事件名（参考 backend/events/types.go）
 * @param callback 回调函数
 */
export function onEvent<T = unknown>(eventName: string, callback: (data: T) => void) {
  EventsOn(eventName, callback as (...args: unknown[]) => void)
}

/**
 * 取消事件订阅
 */
export function offEvent(eventName: string) {
  EventsOff(eventName)
}

// =========================== 错误处理 ===========================

/**
 * 标准化 Wails 错误（后端返回的 error 在前端表现不一致）
 */
export function normalizeError(error: unknown): string {
  if (error instanceof Error) return error.message
  if (typeof error === 'string') return error
  return '操作失败，请稍后重试'
}
