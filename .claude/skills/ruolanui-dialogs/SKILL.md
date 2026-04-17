---
name: ruolanui-dialogs
description: ruolanui 对话框和选择器使用规范。包括确认对话框、选项对话框、输入对话框、日期/时间/日历选择器、双栏选择器（TwoPaneSelector）、多行文本编辑器。
---

# ruolanui 对话框使用规范

## 确认对话框

```dart
final confirmed = await showConfirmDialog(
  context,
  content: '确定删除吗？',
);
if (confirmed) {
  // 执行删除
}
```

## 选项对话框

```dart
// 使用 OptionItem
final index = await showOptionsDialog(
  context,
  items: [
    OptionItem(title: '拍照', icon: Icons.camera),
    OptionItem(title: '相册', icon: Icons.photo),
  ],
);

// 简单字符串选项
final index = await showSampleOptionsDialog(
  context,
  options: ['选项1', '选项2'],
);
```

## 输入对话框

```dart
final result = await showBottomInputDialog(
  context,
  title: '请输入备注',
  hintText: '备注内容',
);
```

## 日期选择器

```dart
// 日期选择
final date = await showRLDatePicker(
  context,
  title: '选择日期',
  minYear: 2020,
  maxYear: 2030,
);

// 时间选择（24小时制）
final time = await showTimePicker24(
  context,
  title: '选择时间',
);
```

## 日历选择器

```dart
final result = await showRLCalendarPicker(
  context,
  title: '选择日期范围',
  // 支持快捷选项：今天、+7天等
);
```

## 双栏选择器（TwoPaneSelector）

> 高级组件：支持父子层级结构的单选/多选

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
  maxSelectCount: 5, // 最多选5个
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

### 自定义主题

```dart
TwoPaneSelectorTheme(
  parentBgColor: Colors.blue.shade50,
  childBgColor: Colors.white,
  selectedColor: Colors.blue,
  // ...
)
```

## 多行文本编辑器

> 全页面文本编辑器，支持有序/无序列表、字数统计

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MultilineTextEditorPage(
      title: '编辑内容',
      initialText: '已有内容',
      maxLength: 500,
    ),
  ),
);
```

### 底部弹窗头部

```dart
BottomSheetHeader(
  title: '标题',
  onCancel: () => Navigator.pop(context),
  onConfirm: () {
    // 确认操作
  },
)
```
