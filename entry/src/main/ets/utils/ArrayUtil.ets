// 数组工具函数

// Fisher-Yates 洗牌算法
export function shuffleArray<T>(array: T[]): T[] {
  const arr = array.slice();
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
  return arr;
}

// 从数组中随机取 n 个元素
export function randomPick<T>(array: T[], n: number): T[] {
  if (n >= array.length) {
    return shuffleArray(array);
  }
  const shuffled = shuffleArray(array);
  return shuffled.slice(0, n);
}
