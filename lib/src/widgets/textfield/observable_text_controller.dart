import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

/// 一个通用的 MobX 文本控制器，实现 Store 与 TextField 的双向绑定
class ObservableTextController extends TextEditingController {
  late ReactionDisposer _disposer;
  bool _isUpdatingFromStore = false;

  ObservableTextController({
    required String Function() getter, // 如何从 Store 获取值
    required void Function(String) setter, // 如何将值写入 Store
    String? debugLabel,
  }) {
    // 1. 监听 Store 的变化 (Reaction: Data -> UI)
    _disposer = reaction((_) => getter(), (String value) {
      print('当前数据为AAA:$value');
      if (text != value) {
        _isUpdatingFromStore = true;
        // 更新文本并保持光标位置
        this.value = this.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _isUpdatingFromStore = false;
      }
    }, name: debugLabel);

    // 2. 监听 UI 的变化 (Listener: UI -> Data)
    addListener(() {
      // 只有当变化来自于用户输入（非 Store 同步）时，才触发 setter
      if (!_isUpdatingFromStore) {
        setter(text);
      }
    });

    // 3. 手动同步初始值
    final initialValue = getter();
    if (text != initialValue) {
      _isUpdatingFromStore = true;
      this.value = this.value.copyWith(
        text: initialValue,
        selection: TextSelection.collapsed(offset: initialValue.length),
      );
      _isUpdatingFromStore = false;
    }
  }

  @override
  void dispose() {
    _disposer(); // 必须销毁 reaction 监听，否则会导致内存泄漏
    super.dispose();
  }
}

ObservableTextController useObservableTextController({
  required String Function() getter,
  required void Function(String) setter,
  String? debugLabel,
}) {
  return use(
    _ObservableTextControllerHook(
      getter: getter,
      setter: setter,
      debugLabel: debugLabel,
    ),
  );
}

class _ObservableTextControllerHook extends Hook<ObservableTextController> {
  final String Function() getter;
  final void Function(String) setter;
  final String? debugLabel;

  const _ObservableTextControllerHook({
    required this.getter,
    required this.setter,
    this.debugLabel,
  });

  @override
  HookState<ObservableTextController, Hook<ObservableTextController>>
  createState() => _ObservableTextControllerHookState();
}

class _ObservableTextControllerHookState
    extends HookState<ObservableTextController, _ObservableTextControllerHook> {
  late ObservableTextController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = _createController();
  }

  @override
  void didUpdateHook(_ObservableTextControllerHook oldHook) {
    super.didUpdateHook(oldHook);

    // 如果 getter / setter 实例变了（比如切换 Store）
    if (oldHook.getter != hook.getter || oldHook.setter != hook.setter) {
      _controller.dispose();
      _controller = _createController();
      setState(() {});
    }
  }

  ObservableTextController _createController() {
    return ObservableTextController(
      getter: hook.getter,
      setter: hook.setter,
      debugLabel: hook.debugLabel,
    );
  }

  @override
  ObservableTextController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String get debugLabel =>
      'useObservableTextController(${hook.debugLabel ?? ""})';
}
