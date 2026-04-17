---
name: ruolanui-components
description: ruolanui UI 组件使用规范。包括按钮（PrimaryBtn/NormalBtn/TextBtn/ErrorBtn/BlockBtn）、输入框（AppTextField/ClearInputTextField）、导航栏（CommonAppBar）、工具组件（KeyboardDismiss/ConditionalBuilder/SwipeBackListener）。使用前必须先读取本 skill。
---

# ruolanui 组件使用规范

## 导入

```dart
import 'package:ruolanui/ruolanui.dart';
```

## 按钮

### PrimaryBtn — 主按钮

```dart
PrimaryBtn(
  text: '确认',
  onTap: () {},
)
```

### NormalBtn — 普通按钮

```dart
NormalBtn(
  text: '取消',
  onTap: () {},
)
```

### TextBtn — 文本按钮

```dart
TextBtn(
  text: '跳过',
  onTap: () {},
)
```

### ErrorBtn — 危险/错误按钮

```dart
ErrorBtn(
  text: '删除',
  onTap: () {},
)
```

### BlockBtn — 列表项按钮（带图标、描述和箭头）

```dart
// 基础用法
BlockBtn(
  leading: Icons.settings,
  title: '设置',
  onTap: () {},
)

// 带描述文字
BlockBtn(
  leading: Icons.person,
  title: '用户名',
  hint: '请输入用户名',
  onTap: () {},
)

// 无箭头 + 自定义尾部
BlockBtn(
  title: '版本',
  trailing: Text('v1.0.0'),
  arrow: false,
)

// 禁用状态
BlockBtn(
  title: '功能未开放',
  disabled: true,
)
```

## 输入框

### AppTextField — 基础输入框

```dart
AppTextField(
  controller: myController,
  labelText: '用户名',
)
```

### ClearInputTextField — 带清除按钮的输入框

```dart
ClearInputTextField(
  controller: myController,
  labelText: '搜索',
)
```

### ObservableTextController — MobX 双向绑定控制器

> **核心组件**：实现 VM observable 字段与 TextField 的双向绑定

#### VM 层

```dart
abstract class _XxxVM with Store, EventStateMixin<XxxEvent> {
  @observable
  String username = '';

  @action
  void setUsername(String value) => username = value;
}
```

#### Page 层

```dart
class _XxxPageState extends State<XxxPage>
    with EventHandlerMixin<XxxPage, XxxEvent>, AutoDisposeMixin {
  @override
  late XxxVM vm = getIt.get();

  // 使用 autoDispose 自动管理生命周期
  late final _usernameController = autoDispose(
    ObservableTextController(
      getter: () => vm.username,
      setter: (value) => vm.setUsername(value),
      debugLabel: 'username',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _usernameController);
  }
}
```

## 导航

### CommonAppBar — 通用应用栏

```dart
Scaffold(
  appBar: CommonAppBar(title: '页面标题'),
)
```

### SwipeBackListener — 自定义滑动手势返回监听

用于需要自定义 iOS/Android 返回手势行为的场景。

## 工具组件

### KeyboardDismiss — 点击空白区域关闭键盘

```dart
KeyboardDismiss(
  child: Scaffold(body: ...),
)
```

### ConditionalBuilder — 条件构建器

```dart
ConditionalBuilder(
  condition: isLoading,
  builder: () => const CircularProgressIndicator(),
  fallback: () => const Text('内容'),
)
```

## 主题使用规范

```dart
@override
Widget build(BuildContext context) {
  // 在 build 顶部获取一次，所有子组件复用
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Scaffold(
    backgroundColor: colorScheme.surfaceContainer,
    body: Text('标题', style: textTheme.titleLarge),
  );
}
```
