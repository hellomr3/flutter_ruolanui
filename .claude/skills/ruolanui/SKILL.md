---
name: ruolanui
description: ruolanui 完整使用规范。包括所有 UI 组件（按钮、输入框、标签、网格、导航栏）、对话框与选择器（确认/选项/输入/日历/日期/时间/双栏选择器/Wrap选项弹窗）、多行文本编辑器、核心模式（事件驱动 UiEventBus、Result 类型、AutoDisposeMixin）和 MVVM 页面模板。使用 ruolanui 开发页面时必须先读取本 skill。
---

# ruolanui 完整使用规范

## 导入

```dart
import 'package:ruolanui/ruolanui.dart';
```

---

## 一、按钮组件

### PrimaryBtn — 主按钮

```dart
PrimaryBtn(
  label: '确认',
  onPressed: () {},
  // 可选参数
  height: 44,        // 默认 44
  width: null,        // 默认自适应
  borderRadius: 22,   // 默认 22
)
```

### NormalBtn — 普通按钮

```dart
NormalBtn(
  label: '取消',
  onPressed: () {},
)
```

### TextBtn — 文本按钮

```dart
TextBtn(
  label: '跳过',
  onPressed: () {},
  textColor: Colors.grey, // 可选自定义文本色
)
```

### ErrorBtn — 危险/错误按钮

```dart
ErrorBtn(
  label: '删除',
  onPressed: () {},
)
```

### BlockBtn — 列表项按钮

带图标、描述、箭头和分割线的列表行组件。

```dart
// 基础用法
BlockBtn(
  title: '设置',
  leading: Icons.settings,
  onTap: () {},
)

// 带描述文字
BlockBtn(
  title: '用户名',
  hint: '请输入用户名',
  leading: Icons.person,
  onTap: () {},
)

// 自定义尾部 + 无箭头
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

// 自定义前置组件（替代 leading icon）
BlockBtn(
  title: '头像',
  leadingWidget: CircleAvatar(backgroundImage: ...),
  onTap: () {},
)
```

### BaseBtn — 基础按钮

所有按钮的底层实现，可完全自定义背景色和文本色。

```dart
BaseBtn(
  label: '自定义',
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  onPressed: () {},
)
```

---

## 二、输入组件

### AppTextField — 基础输入框

```dart
AppTextField(
  hintText: '请输入',
  onChange: (value) {},
  controller: myController,     // 可选
  icon: Icons.search,           // 可选前置图标
  tailIcon: IconButton(...),    // 可选尾部组件
  fillColor: Colors.grey[100],  // 可选背景色
  border: OutlineInputBorder(), // 可选边框
  autofocus: false,
  keyboardType: TextInputType.text,
)
```

### ClearInputTextField — 带清除按钮的输入框

聚焦且有内容时自动显示清除按钮。

```dart
ClearInputTextField(
  hintText: '搜索',
  onChange: (value) {},
  controller: myController,  // 可选
  value: '初始值',            // 可选，无 controller 时使用
  borderRadius: 12,          // 默认 12
  fillColor: Colors.grey[100],
)
```

### ObservableTextController — MobX 双向绑定控制器

实现 VM observable 字段与 TextField 的双向绑定。

#### VM 层

```dart
abstract class _XxxVM with Store {
  @observable
  String username = '';

  @action
  void setUsername(String value) => username = value;
}
```

#### Page 层

```dart
class _XxxPageState extends State<XxxPage> with AutoDisposeMixin {
  late final vm = getIt.get<XxxVM>();

  late final _usernameCtrl = autoDispose(
    ObservableTextController(
      getter: () => vm.username,
      setter: (v) => vm.setUsername(v),
      debugLabel: 'username',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _usernameCtrl);
  }
}
```

---

## 三、标签组件

### TextTag — 单个文本标签

支持选中/未选中状态，背景、文本样式、圆角均可配置。

```dart
TextTag(
  label: '标签',
  selected: true,
  onTap: () {},
  // 可选主题
  theme: TextTagTheme(
    backgroundColor: Colors.grey[200],
    selectedBackgroundColor: Colors.blue,
    textStyle: TextStyle(...),
    selectedTextStyle: TextStyle(...),
    borderRadius: 16,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),
)

// 自定义子组件
TextTag(
  selected: false,
  child: Row(children: [Icon(Icons.add), Text('新增')]),
  onTap: () {},
)
```

### TextTagGroup — 标签组

支持单选和多选模式。

```dart
TextTagGroup(
  labels: ['标签1', '标签2', '标签3'],
  selectedIndices: {0},
  onChanged: (indices) {},
  multiSelect: false,  // 默认 false（单选）
  spacing: 8,
  runSpacing: 8,
  theme: TextTagTheme(...), // 可选
)
```

---

## 四、网格组件

### ActionGrid — 操作网格

以宫格形式展示图标+文字的操作入口。

```dart
ActionGrid(
  title: '快捷操作',  // 可选标题
  crossAxisCount: 4,  // 默认 4 列
  items: [
    ActionGridItem(
      icon: Icons.camera,
      title: '拍照',
      onTap: () {},
    ),
    ActionGridItem(
      iconWidget: Image.asset('assets/custom.png', width: 28),
      title: '自定义',
      onTap: () {},
      iconColor: Colors.blue,
    ),
  ],
)
```

---

## 五、导航与容器

### CommonAppBar — 通用应用栏

```dart
Scaffold(
  appBar: CommonAppBar(
    title: '页面标题',
    actions: [IconButton(...)],
    centerTitle: true,  // 默认 true
  ),
)
```

### KeyboardDismiss — 点击空白区域关闭键盘

```dart
KeyboardDismiss(
  child: Scaffold(body: ...),
)
```

### SwipeBackListener — 自定义侧滑返回监听

iOS 端禁用原生侧滑并改用手势判定，Android 端拦截物理返回键。

```dart
SwipeBackListener(
  onSwipeBack: () {
    // 自定义返回逻辑，如保存草稿后 pop
    Navigator.pop(context);
  },
  child: Scaffold(body: ...),
)

// 或使用扩展方法
Scaffold(body: ...).swipeBackListener(
  onSwipeBack: () => Navigator.pop(context),
)
```

### ConditionalBuilder — 条件构建器

```dart
ConditionalBuilder(
  condition: isLoading,
  trueBuilder: (context) => CircularProgressIndicator(),
  falseBuilder: (context) => Text('内容'),  // 可选，默认 SizedBox.shrink()
)
```

### BottomSheetHeader — 底部弹窗通用头部栏

```dart
BottomSheetHeader(
  cancelText: '取消',
  titleText: '标题',
  confirmText: '确定',
  onLeftPressed: () => Navigator.pop(context),
  onRightPressed: () { /* 确认操作 */ },
  confirmEnabled: true,
)
```

---

## 六、对话框

### 确认对话框

```dart
final result = await showConfirmDialog(
  context: context,
  title: '提示',          // 默认 '提示'
  content: '确定删除吗？',
  confirmText: '确定',    // 默认 '确定'
  cancelText: '取消',     // 默认 '取消'
);
// result 是 Result<bool>
result.onSuccess((confirmed) {
  if (confirmed == true) { /* 执行删除 */ }
});
```

### 选项对话框

```dart
// 使用 OptionItem
final result = await showOptionsDialog(
  context: context,
  options: [
    OptionItem(id: 0, label: '拍照'),
    OptionItem(id: 1, label: '相册', desc: '从相册选择'),
  ],
  value: 0,           // 可选，当前选中项
  title: '选择方式',   // 可选标题
);
// result 是 Result<int>，data 为选中的 OptionItem.id

// 简单字符串选项
final result = await showSampleOptionsDialog(
  context: context,
  options: ['选项1', '选项2'],
);
```

### 输入对话框

从底部弹出，自动拉起键盘。

```dart
final result = await showBottomInputDialog(
  context,
  title: '请输入备注',
  hintText: '备注内容',
  initialValue: '已有内容',  // 可选
  confirmText: '确认',       // 默认 '确认'
  cancelText: '取消',        // 默认 '取消'
  keyboardType: TextInputType.text,
);
// result 是 Result<String>
result.onSuccess((text) {
  print('输入内容: $text');
});
```

### Wrap 选项弹窗

自动换行布局，适合大量选项。

```dart
// 完全自定义 Item
final result = await showWrapOptionsDialog<MyData>(
  context: context,
  title: '选择标签',
  options: myDataList,
  initialSelected: {0, 2},
  multiSelect: true,
  itemBuilder: (item, index, isSelected, onTap) {
    return TextTag(
      label: item.name,
      selected: isSelected,
      onTap: onTap,
    );
  },
);
// result 是 Result<Set<int>>，data 为选中索引集合

// 纯文本标签（内置 TextTag 样式）
final result = await showTextWrapOptionsDialog(
  context: context,
  title: '选择标签',
  options: ['标签A', '标签B', '标签C'],
  initialSelected: {0},
  multiSelect: true,
);

// 图标+文本选项（内置 IconTextOption 样式）
final result = await showIconTextWrapOptionsDialog(
  context: context,
  title: '选择类型',
  options: [
    IconOptionItem(icon: Icons.work, label: '工作'),
    IconOptionItem(icon: Icons.home, label: '生活'),
  ],
  multiSelect: false,
);
```

### IconTextOption — 图标+文本选项卡片

```dart
IconTextOption(
  icon: Icons.star,
  label: '收藏',
  isSelected: true,
  onTap: () {},
  width: 72,       // 默认 72
  iconSize: 28,    // 默认 28
)

// 自定义图标区域
IconTextOption(
  iconBuilder: (isSelected, fgColor) => Image.asset('icon.png', width: 28),
  label: '自定义',
  isSelected: false,
  onTap: () {},
)
```

---

## 七、日期与时间选择器

### 日历选择器

支持日历网格 + 滚轮双模式切换、快捷时间段选项、日期范围限制。

```dart
final result = await showRLCalendarPicker(
  context,
  initDate: DateTime.now(),
  minDate: DateTime(2020, 1, 1),
  maxDate: DateTime(2030, 12, 31),
  showPeriodButtons: true,   // 显示快捷选项（今天、+1天、+7天等）
  showNoDate: true,          // 显示"清除日期"按钮
  labels: CalendarPickerLabels(
    title: '选择日期',
    confirm: '确定',
    clearDate: '清除日期',
  ),
  periodOptions: [           // 自定义快捷选项
    PeriodOption(label: '今天', type: PeriodType.today),
    PeriodOption(label: '+7天', days: 7),
    PeriodOption(label: '+1月', months: 1),
  ],
);
// result 是 Result<DateTime>?
result?.onSuccess((date) {
  print('选中日期: $date');  // date 为 null 表示清除日期
});
```

### 日期滚轮选择器

```dart
final result = await showRLDatePicker(
  context,
  initDate: DateTime.now(),
  min: DateTime(2020, 1, 1),
  max: DateTime(2030, 12, 31),
  mode: DatePickerMode.yearMonthDay,  // 或 DatePickerMode.yearMonth
  labels: DatePickerLabels(
    title: '选择日期',
    cancel: '取消',
    confirm: '确定',
  ),
  theme: DatePickerTheme(
    itemHeight: 44,
    visibleItemCount: 5,
    yearFormatter: (year) => '$year年',
  ),
);
// result 是 Result<DateTime>?
```

### 时间选择器（24 小时制）

```dart
final result = await showTimePicker24(
  context,
  initTime: DateTime.now(),
  mode: TimePickerMode.hourMinute,  // 或 TimePickerMode.hourMinuteSecond
  labels: TimePickerLabels(
    title: '选择时间',
    cancel: '取消',
    confirm: '确定',
  ),
  theme: TimePickerTheme(
    itemHeight: 44,
    visibleItemCount: 5,
  ),
);
// result 是 Result<DateTime>?（日期部分保留 initTime 的值）
```

---

## 八、双栏选择器（TwoPaneSelector）

支持父子层级结构的单选/多选。

### 数据模型 — 实现 SelectorItem

```dart
class MyEntity implements SelectorItem<String> {
  @override
  final String id;

  @override
  final String title;

  @override
  final String? parentId;

  MyEntity({required this.id, required this.title, this.parentId});
}
```

### 单选

```dart
final selected = await SelectorDialog.showSingle<MyEntity, String>(
  context,
  title: '选择分类',
  items: entities,
  adapter: TwoPaneSelectorAdapter<MyEntity, String>.defaultAdapter(),
);
```

### 多选

```dart
final selected = await SelectorDialog.showMultiple<MyEntity, String>(
  context,
  title: '选择标签',
  items: entities,
  adapter: TwoPaneSelectorAdapter<MyEntity, String>.defaultAdapter(),
  maxSelectCount: 5,
);
```

### 嵌入式使用

```dart
TwoPaneSelector<MyEntity, String>(
  title: '选择项目',
  idExtractor: (entity) => entity.id,
  parentIdExtractor: (entity) => entity.parentId,
  mode: SelectorMode.multiple,
  items: entities,
  parentItemBuilder: (context, item, isSelected, onTap) => ...,
  childItemBuilder: (context, item, isSelected, onTap) => ...,
  selectedItemBuilder: (context, item, onRemove) => ...,
  onConfirm: (selectedItems) {},
)
```

---

## 九、多行文本编辑器

全页面文本编辑器，支持有序/无序列表、字数统计、模板功能。

```dart
final result = await Navigator.push<String>(
  context,
  MaterialPageRoute(
    builder: (_) => MultilineTextEditorPage(
      title: '编辑内容',
      subTitle: '请详细描述',
      placeholder: '请输入内容...',
      initialText: '已有内容',
      maxInputCount: 500,
      // 模板功能（可选）
      templates: [
        EditorTemplate(name: '模板A', content: '模板A的内容...'),
        EditorTemplate(name: '模板B', content: '模板B的内容...'),
      ],
      // 国际化（可选）
      locale: MultilineEditorLocale.en,  // 或自定义
      // 主题（可选）
      theme: MultilineEditorTheme.of(context),
    ),
  ),
);
// result 为编辑后的文本，null 表示取消
```

---

## 十、AdaptiveDialogPage

适用于 Navigator 2.0 路由的自适应对话框页面，从底部滑入。

```dart
// 在 GoRouter 等路由中使用
GoRoute(
  path: '/dialog',
  pageBuilder: (context, state) => AdaptiveDialogPage(
    builder: (context) => MyDialogContent(),
    barrierDismissible: true,
  ),
)
```

---

## 十一、核心模式

### Result 类型

统一的操作结果封装，所有对话框返回值均使用此类型。

```dart
// 创建
Result.success(data);
Result.failure('错误信息', code: -1);

// 判断
result.isSuccess  // code == 0
result.isFailure  // code != 0 或 msg != null

// 链式调用
result
  .onSuccess((data) { /* 处理成功 */ })
  .onError((message, code) { showToast(msg: message ?? '操作失败'); });

// 转换
final mapped = result.map((data) => data.toViewModel());
```

### 事件驱动模式

推荐的事件通信机制：事件定义 + 处理放在同一文件（`xxx_event.dart`），通过独立的 EventListen Widget 包裹页面。

```
xxx_event.dart    — 事件 enum + EventListen Widget
xxx_vm.dart       — 使用 UiEventBus<XxxEvent> 发送事件
xxx_page.dart     — 用 XxxEventListen 包裹 Scaffold
```

#### 1. 定义事件 + EventListen Widget（xxx_event.dart）

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';
import 'xxx_vm.dart';

enum XxxEvent { success, failure, notAgree }

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
    widget.vm.event.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

#### 2. VM 层 — 使用 UiEventBus（xxx_vm.dart）

```dart
import 'package:mobx/mobx.dart';
import 'package:ruolanui/ruolanui.dart';
import 'xxx_event.dart';

part 'xxx_vm.g.dart';

@injectable
class XxxVM = _XxxVM with _$XxxVM;

abstract class _XxxVM with Store {
  final XxxUseCase _useCase;
  _XxxVM(this._useCase);

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

#### 3. Page 层 — 用 EventListen 包裹（xxx_page.dart）

```dart
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
              hintText: '输入内容',
              controller: ObservableTextController(
                getter: () => vm.inputText,
                setter: (v) => vm.setInputText(v),
              ),
            ),
            PrimaryBtn(label: '提交', onPressed: vm.submit),
          ]),
        ),
      ),
    );
  }
}
```

#### 为什么事件定义和处理放同一文件

1. **内聚性** — 事件 enum 和处理逻辑天然耦合，放一起改一个不用切文件
2. **Page 更干净** — Page 只负责 UI 布局
3. **可复用** — 同一个 EventListen 可在多个 Page 中复用
4. **测试方便** — EventListen 是独立 Widget，可单独测试

### AutoDisposeMixin

自动管理 ChangeNotifier 和 StreamSubscription 的生命周期。

```dart
class _MyPageState extends State<MyPage> with AutoDisposeMixin {
  late final _focusNode = autoDispose(FocusNode());
  late final _controller = autoDispose(
    ObservableTextController(
      getter: () => vm.text,
      setter: (v) => vm.setText(v),
    ),
  );
  late final _sub = autoCancel(someStream.listen((event) { ... }));
}
```

支持所有 `ChangeNotifier` 子类和 `StreamSubscription`。

---

## 十二、主题使用规范

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

---

## 十三、页面模板

```
xxx_page.dart      — 页面 UI，用 XxxEventListen 包裹
xxx_vm.dart        — 状态管理，使用 UiEventBus<XxxEvent>
xxx_event.dart     — 事件 enum + EventListen Widget
child/             — 业务子组件
  xxx_form_child.dart
```

依赖方向：Page → VM → UseCase → Repository → LDS/RDS
