import hilog from '@ohos.hilog';

// 安全返回上一页
export function popSafe(pageStack: NavPathStack): void {
  try {
    pageStack.pop();
  } catch (e) {
    hilog.warn(0x0000, 'NavUtil', 'pop failed: %{public}s', JSON.stringify(e));
  }
}
