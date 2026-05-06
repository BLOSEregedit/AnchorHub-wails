/**
 * 后端事件相关类型定义
 * 与 backend/events/types.go 保持同步
 */

export interface ProcessProgressEvent {
  stage: string
  message: string
}

export interface FileStatusEvent {
  file_id: string
  status: 'pending' | 'processing' | 'success' | 'failed'
  error?: string
}

/**
 * 事件名常量（与后端保持一致）
 */
export const EventNames = {
  ProcessStart: 'process:start',
  ProcessProgress: 'process:progress',
  ProcessSuccess: 'process:success',
  ProcessError: 'process:error',
  FileStatusUpdate: 'file:status:update',
} as const
