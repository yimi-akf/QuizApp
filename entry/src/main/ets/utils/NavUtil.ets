import hilog from '@ohos.hilog';

// 安全返回上一页
export function popSafe(pageStack: NavPathStack): void {
  try {
    pageStack.pop();
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    hilog.warn(0x0001, 'NavUtil', 'pop failed: %{public}s', msg);
  }
}
