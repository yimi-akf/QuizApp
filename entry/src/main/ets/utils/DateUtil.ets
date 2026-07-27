// 日期工具函数

const pad = (n: number): string => (n < 10 ? '0' + n : String(n));

// 格式化为 yyyy-MM-dd HH:mm
export function formatDateTime(date: Date): string {
  const datePart = `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
  const timePart = `${pad(date.getHours())}:${pad(date.getMinutes())}`;
  return `${datePart} ${timePart}`;
}

// 格式化为 yyyy-MM-dd
export function formatDate(date: Date): string {
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
}

// 获取今天的日期字符串
export function todayString(): string {
  return formatDate(new Date());
}
