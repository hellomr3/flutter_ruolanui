#!/bin/bash
export PATH="$HOME/fvm/versions/3.35.7/bin:$PATH"
cd "$(dirname "$0")/example"

# 获取安卓设备 ID (按 • 分隔取第2列)
ANDROID_DEVICE=$(flutter devices 2>/dev/null | grep android | head -1 | awk -F' • ' '{print $2}')

if [ -z "$ANDROID_DEVICE" ]; then
    echo "[run_example] ❌ 没有找到安卓设备"
    flutter devices
    exit 1
fi

echo "[run_example] 使用设备: $ANDROID_DEVICE"
flutter run -d "$ANDROID_DEVICE" --debug
