---
name: ruolanui-patterns
description: ruolanui 核心模式。包括事件驱动模式（UiEventBus + EventListen Widget）、Result 类型、AutoDisposeMixin、MVVM 页面模板。使用 ruolanui 开发页面时必须读取本 skill。
---

# ruolanui 核心模式

## 事件驱动模式

> ruolanui 推荐的事件通信机制：事件定义 + 处理放在同一文件（`xxx_event.dart`），通过独立的 EventListen Widget 包裹页面

### 模式说明

```
xxx_event.dart    — 事件 enum 定义 + EventListen Widget（事件定义和处理在同一文件）
xxx_vm.dart       — 使用 UiEventBus<XxxEvent> 发送事件
xxx_page.dart     — 用 XxxEventListen 包裹 Scaffold，接收并处理事件
```

### 1. 定义事件 + EventListen Widget（xxx_event.dart）

> 事件 enum 和 EventListen 放在同一文件中

```dart
// xxx_event.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';
import 'xxx_vm.dart';

// 事件定义
enum XxxEvent { success, failure, notAgree }

// EventListen Widget：负责监听 VM 事件并处理
class XxxEventListen extends StatefulWidget {
  final Widget child;
  final XxxVM vm;

  const XxxEventListen({required this.child, required this.vm, super.key});

  @override
  State<XxxEventListen> createState() => _XxxEventListenState();
}

class _XxxEventListenState extends State<XxxEventListen> {
  StreamSubscription<XxxEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.vm.event.stream.listen(_onEvent);
  }

  void _onEvent(XxxEvent event) async {
    if (!mounted) return;

    switch (event) {
      case XxxEvent.success:
        if (mounted) context.pop();
      case XxxEvent.failure:
        showToast(msg: '操作失败');
      case XxxEvent.notAgree:
        final result = await showConfirmDialog(
          context: context,
          content: '请先同意协议',
        );
        if (!mounted) return;
        if (result.isSuccess && result.data == true) {
          widget.vm.updateAgree(true);
          widget.vm.submit();
        }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    widget.vm.event.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

### 2. VM 层 — 使用 UiEventBus（xxx_vm.dart）

```dart
// xxx_vm.dart
import 'package:mobx/mobx.dart';
import 'package:ruolanui/ruolanui.dart';
import 'xxx_event.dart';

part 'xxx_vm.g.dart';

@injectable
class XxxVM = _XxxVM with _$XxxVM;

abstract class _XxxVM with Store {
  final XxxUseCase _useCase;
  _XxxVM(this._useCase);

  // 使用 UiEventBus，不用 EventStateMixin
  late final event = UiEventBus<XxxEvent>();

  @observable
  String inputText = '';

  @observable
  bool agree = false;

  @action
  void setInputText(String value) => inputText = value;

  @action
  void updateAgree(bool value) => agree = value;

  @action
  Future<void> submit() async {
    if (inputText.isEmpty) {
      showToast(msg: '请输入内容');
      return;
    }
    if (!agree) {
      event.emit(XxxEvent.notAgree);
      return;
    }

    showLoading(() async {
      final result = await _useCase.doSomething(inputText);
      if (result.isSuccess) {
        event.emit(XxxEvent.success);
      } else {
        event.emit(XxxEvent.failure);
      }
    });
  }
}
```

### 3. Page 层 — 用 EventListen 包裹（xxx_page.dart）

```dart
// xxx_page.dart
import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';
import 'xxx_event.dart';
import 'xxx_vm.dart';

class XxxPage extends StatelessWidget {
  const XxxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = getIt.get<XxxVM>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return XxxEventListen(
      vm: vm,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainer,
        appBar: CommonAppBar(title: '标题'),
        body: KeyboardDismiss(
          child: Column(children: [
            ClearInputTextField(
              controller: ObservableTextController(
                getter: () => vm.inputText,
                setter: (v) => vm.setInputText(v),
              ),
              labelText: '输入内容',
            ),
            PrimaryBtn(text: '提交', onTap: vm.submit),
          ]),
        ),
      ),
    );
  }
}
```

### 为什么事件定义和处理放同一文件

1. **内聚性** — 事件 enum 和它的处理逻辑天然耦合，放一起改一个不用切文件
2. **Page 更干净** — Page 只负责 UI 布局，不关心事件处理细节
3. **可复用** — 同一个 EventListen 可以在多个 Page 中复用（如列表页和详情页共享事件处理）
4. **测试方便** — EventListen 是独立 Widget，可单独测试事件处理逻辑

## Result 类型

> ruolanui 提供的操作结果封装，支持链式调用

```dart
final result = await someAsyncOperation();
result
  .onSuccess((data) {
    // 处理成功
  })
  .onError((message, code) {
    showToast(msg: message ?? '操作失败');
  });

// 转换数据
final mapped = result.map((data) => data.toViewModel());
```

### 创建 Result

```dart
return Result.success(data);
return Result.failure('错误信息', code: -1);
```

## AutoDisposeMixin

> 自动管理 ChangeNotifier 生命周期，防止内存泄漏

```dart
class _MyPageState extends State<MyPage> with AutoDisposeMixin {
  late final _focusNode = autoDispose(FocusNode());
  late final _controller = autoDispose(
    ObservableTextController(
      getter: () => vm.text,
      setter: (v) => vm.setText(v),
    ),
  );
}
```

支持所有 `ChangeNotifier` 子类：`FocusNode`、`TextEditingController`、`ObservableTextController` 等。

## 页面模板

```
xxx_page.dart      — 页面 UI，用 XxxEventListen 包裹
xxx_vm.dart        — 状态管理，使用 UiEventBus<XxxEvent>
xxx_event.dart     — 事件 enum + EventListen Widget（定义和处理在同一文件）
child/             — 业务子组件
  xxx_form_child.dart
```

依赖方向：Page → VM → UseCase → Repository → LDS/RDS
