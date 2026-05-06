/**
 * 格式化文件大小
 * @param bytes 字节数
 * @returns 格式化后的字符串（B / KB / MB / GB）
 */
export function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(2)} KB`
  if (bytes < 1024 * 1024 * 1024) return `${(bytes / (1024 * 1024)).toFixed(2)} MB`
  return `${(bytes / (1024 * 1024 * 1024)).toFixed(2)} GB`
}

/**
 * 格式化时间戳为本地时间字符串
 * @param timestamp ISO 格式或 Date 对象
 */
export function formatTimestamp(timestamp: string | Date): string {
  const date = typeof timestamp === 'string' ? new Date(timestamp) : timestamp
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  })
}

/**
 * 截断长路径（保留首尾，中间省略）
 * @param path 完整路径
 * @param maxLength 最大长度
 */
export function truncatePath(path: string, maxLength = 60): string {
  if (path.length <= maxLength) return path
  const head = path.slice(0, Math.floor(maxLength / 2) - 2)
  const tail = path.slice(-Math.floor(maxLength / 2) + 1)
  return `${head}...${tail}`
}
