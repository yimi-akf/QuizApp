#!/bin/bash
# QuizApp 一键构建并安装到手机
# 用法: bash build-and-install.sh
#
# 前置条件:
#   1. 手机已开启开发者模式 + USB 调试，并通过 USB 连接电脑
#   2. DevEco Studio 已安装（提供 JBR、hvigor、SDK）
#   3. hdc 能识别设备（hdc list targets 显示设备 ID）

set -e

# ===== 路径配置（按实际环境修改）=====
DEVECO_HOME="C:/Program Files/Huawei/DevEco Studio"
JAVA_HOME="$DEVECO_HOME/jbr"
DEVECO_SDK_HOME="C:/Users/11236/sdk/default"
NODE_EXE="$DEVECO_HOME/tools/node/node.exe"
HVIGORW_JS="$DEVECO_HOME/tools/hvigor/bin/hvigorw.js"
HDC="$DEVECO_SDK_HOME/HarmonyOS NEXT2/openharmony/toolchains/hdc.exe"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ===== 环境变量 =====
unset NODE_OPTIONS
export JAVA_HOME
export DEVECO_SDK_HOME
export PATH="$JAVA_HOME/bin:$PATH"

cd "$PROJECT_DIR"

# ===== 1. 检查设备连接 =====
echo "==> [1/4] 检查设备连接..."
DEVICES=$("$HDC" list targets 2>/dev/null)
if [ -z "$DEVICES" ] || echo "$DEVICES" | grep -qi "empty\|no"; then
  echo "    ✗ 未检测到设备，请确认手机已连接并开启 USB 调试"
  exit 1
fi
echo "    ✓ 已连接设备: $DEVICES"

# ===== 2. 构建 HAP =====
echo "==> [2/4] 构建 HAP (hvigor assembleHap)..."
"$NODE_EXE" "$HVIGORW_JS" --mode module -p product=default -p module=entry@default assembleHap --no-daemon 2>&1 | tail -5
HAP="$PROJECT_DIR/entry/build/default/outputs/default/entry-default-signed.hap"
if [ ! -f "$HAP" ]; then
  echo "    ✗ 构建失败，未找到签名 HAP"
  exit 1
fi
echo "    ✓ 构建成功: $(basename "$HAP") ($(du -h "$HAP" | cut -f1))"

# ===== 3. 安装到手机 =====
echo "==> [3/4] 安装到手机..."
"$HDC" install "$HAP" 2>&1
echo "    ✓ 安装完成"

# ===== 4. 启动应用 =====
echo "==> [4/4] 启动应用..."
"$HDC" shell aa start -a EntryAbility -b com.gaorun.quiz 2>&1
echo "    ✓ 应用已启动"

echo ""
echo "========================================"
echo "  部署完成！应用已在手机上运行"
echo "  查看实时日志: $HDC shell hilog | grep QuizApp"
echo "========================================"
