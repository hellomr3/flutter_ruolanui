#!/bin/bash
export PATH="$HOME/fvm/versions/3.35.7/bin:$PATH"
cd "$(dirname "$0")/example"

# 用于跨次执行追踪正在运行的 flutter run 进程
PID_FILE="/tmp/flutter_run_example.pid"
FIFO_FILE="/tmp/flutter_run_example.fifo"

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null
}

# 如果已有实例在运行，则发送热重载指令并退出
if is_running && [ -p "$FIFO_FILE" ]; then
    echo "[run_example] ✅ 检测到正在运行的实例 (PID $(cat "$PID_FILE"))，触发热重载..."
    # 'r' = hot reload；如需热重启可改为 'R'
    printf 'r' > "$FIFO_FILE"
    exit 0
fi

# 清理可能残留的脏状态
rm -f "$PID_FILE" "$FIFO_FILE"

# 获取安卓设备 ID (按 • 分隔取第2列)
ANDROID_DEVICE=$(flutter devices 2>/dev/null | grep android | head -1 | awk -F' • ' '{print $2}')

if [ -z "$ANDROID_DEVICE" ]; then
    echo "[run_example] ❌ 没有找到安卓设备"
    flutter devices
    exit 1
fi

echo "[run_example] 使用设备: $ANDROID_DEVICE"

# 创建 FIFO 作为 flutter run 的 stdin，以便后续脚本调用可以写入控制字符
mkfifo "$FIFO_FILE"
# 以读写方式占用 FIFO，避免无写入端时被 EOF 关闭
exec 3<> "$FIFO_FILE"

cleanup() {
    rm -f "$PID_FILE" "$FIFO_FILE"
    exec 3>&- 2>/dev/null || true
}
trap cleanup EXIT INT TERM

# 后台启动 flutter run，stdin 接到 FIFO；输出仍然走当前终端
flutter run -d "$ANDROID_DEVICE" --debug <&3 &
FLUTTER_PID=$!
echo "$FLUTTER_PID" > "$PID_FILE"

echo "[run_example] 💡 再次运行本脚本会自动触发热重载 (r)"
echo "[run_example] 💡 也可手动: printf 'R' > $FIFO_FILE  # 热重启"
echo "[run_example] 💡 也可手动: printf 'q' > $FIFO_FILE  # 退出"

# 阻塞等待，便于 Ctrl+C 直接终止
wait "$FLUTTER_PID"
