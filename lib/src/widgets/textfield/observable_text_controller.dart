import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals/signals.dart';

/// 适配 Signals 的文本控制器，实现 Signal 与 TextField 的自动双向绑定
class ObserverTextController extends TextEditingController {
  late final void Function() _disposeSignalSide;
  bool _isUpdatingFromSignal = false;

  ObserverTextController({
    required Signal<String> signal, // 直接传入信号对象
  }) : super(text: signal.value) {
    // 1. 监听信号变化 (Data -> UI)
    // subscribe 会立即执行一次当前值，并返回一个取消订阅的函数
    _disposeSignalSide = signal.subscribe((value) {
      if (text != value) {
        _isUpdatingFromSignal = true;

        // 更新文本并尝试保持光标位置
        // 注意：这里使用 value.length 是简单的做法，
        // 复杂场景下可以保留当前的 selection.extentOffset
        this.value = this.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );

        _isUpdatingFromSignal = false;
      }
    });

    // 2. 监听 UI 输入变化 (UI -> Data)
    addListener(() {
      if (!_isUpdatingFromSignal) {
        // 直接更新信号的值，Signals 会自动处理后续依赖
        if (signal.value != text) {
          signal.value = text;
        }
      }
    });
  }

  @override
  void dispose() {
    _disposeSignalSide(); // 取消信号订阅
    super.dispose();
  }
}

/// 对应调整后的自定义 Hook
ObserverTextController useObserverTextController({
  required Signal<String> signal,
  List<Object?> keys = const [],
}) {
  // 仅在 key 变化或首次加载时创建控制器
  final controller = useMemoized(
    () => ObserverTextController(signal: signal),
    keys,
  );

  // 利用 useEffect 确保 dispose 被调用
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
