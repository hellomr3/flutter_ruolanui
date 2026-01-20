# 双栏选择器组件 (Two Pane Selector)

通用的双栏选择器组件，支持单选和多选模式，适用于分类、单位等层级数据的场景。

## 功能特性

- 支持单选/多选模式
- 左右分栏布局，左侧显示父级分类，右侧显示子级项目
- 支持外部配置一级"全部"和二级"全部"选项
- 多选模式下底部展示已选项目（支持默认样式）
- 支持选择数量上限控制
- 支持父子联动选择，智能合并选择状态
- 泛型设计，支持任意数据类型
- 灵活的渲染器自定义
- 使用 ChangeNotifier 进行状态管理（不依赖 MobX）
- **点击处理由内部处理，外部只需负责 UI 展示**

## 快速开始

### 1. 定义数据模型

数据模型需要实现 `SelectorItem<ID>` 接口：

```dart
import 'package:ruolanui/ruolanui.dart';

class CategoryEntity implements SelectorItem<String> {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? pid;

  CategoryEntity({
    required this.id,
    required this.name,
    this.pid,
  });
}
```

### 2. 使用 SelectorDialog（推荐）

#### 单选模式

```dart
/// 单选分类封装
Future<CategoryEntity?> showSingleCategorySelect(BuildContext context,
    CategoryEntity? value,) async {
  final categories = getIt<CategoryStore>().categories.toList();
  final theme = TwoPaneSelectorTheme.of(context)
      .copyWith(leftPanelWidthFactor: 0.4);

  return SelectorDialog.showSingle(
    context: context,
    title: "选择分类",
    items: categories,
    theme: theme,
    initialSelectedId: value?.id,
    // 配置二级"全部"选项
    childAllItemBuilder: (String? pid) {
      return CategoryEntity(
        id: pid ?? "",
        pid: pid ?? "",
        name: "全部",
      );
    },
    parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
      return ParentCategoryItem(
        category: item,
        isSelected: isSelected,
        hasSelectedItems: hasSelectedItems,
      );
    },
    childItemBuilder: (context, item, isSelected) {
      return SubCategoryItem(category: item, isSelected: isSelected);
    },
  );
}

// 调用
final selected = await

showSingleCategorySelect(context, currentValue);if (
selected != null) {
print('选中了: ${selected.name}');
}
```

#### 多选模式

```dart
/// 多选分类封装
Future<List<CategoryEntity>> showCategoryMultiSelect(BuildContext context,
    List<CategoryEntity>? values,) async {
  final categories = getIt<CategoryStore>().categories.toList();
  final theme = TwoPaneSelectorTheme.of(context)
      .copyWith(leftPanelWidthFactor: 0.4);

  return SelectorDialog.showMultiple(
    context: context,
    title: "选择分类",
    items: categories,
    theme: theme,
    initialSelectedIds: values?.map((i) => i.id).toList(),
    maxSelectedCount: 5,
    // 最大可选数量，默认为5
    // 配置二级"全部"选项
    childAllItemBuilder: (String? pid) {
      return CategoryEntity(
        id: pid ?? "",
        pid: pid ?? "",
        name: "全部",
      );
    },
    // 达到上限时的回调（可选）
    onMaxLimitReached: () {
      showToast(msg: "已达上限");
    },
    parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
      return ParentCategoryItem(
        category: item,
        isSelected: isSelected,
        hasSelectedItems: hasSelectedItems,
      );
    },
    childItemBuilder: (context, item, isSelected) {
      return SubCategoryItem(category: item, isSelected: isSelected);
    },
    // selectedItemBuilder 可选，不传则使用默认样式
  );
}

// 调用
final selectedList = await

showCategoryMultiSelect(context, currentValues);for (
final item in selectedList) {
print('选中了: ${item.name}');
}
```

### 3. 自定义底部已选样式

```dart
SelectorDialog.showMultiple
(
context: context,
title: "选择项目",
items: items,
// 自定义底部已选项目样式
selectedItemBuilder: (context, item, onRemove) {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(
color: Colors.blue.withOpacity(0.1),
borderRadius: BorderRadius.circular(16),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Text(item.name),
const SizedBox(width: 4),
GestureDetector(
onTap: onRemove,
child: const Icon(Icons.close, size: 16),
),
],
),
);
},
// ... 其他参数
);
```

### 4. 直接使用 TwoPaneSelector

```dart
TwoPaneSelector<CategoryEntity, String>
(
title: '选择分类',
mode: SelectorMode.multiple,
items: categories,
maxSelectedCount: 5,
parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
return ListTile(title: Text(item.name));
},
childItemBuilder: (context, item, isSelected) {
return CheckboxListTile(
value: isSelected,
title: Text(item.name),
);
},
onConfirm: (selected) {
// 处理选中的项目（多选模式）
},
onMaxLimitReached: () {
// 达到上限时的回调
},
)
```

## "全部"选项配置

组件支持从外部配置一级"全部"和二级"全部"选项：

- **`parentAllItem`**: 一级"全部"选项的数据（null 表示不显示一级"全部"）
- **`childAllItemBuilder`**: 二级"全部"选项的数据构建器，参数为当前选中的父项ID

### 配置说明

```dart
// 一级"全部"选项（显示在左侧顶部）
parentAllItem: CategoryEntity
(
name: "全部", id: "_all"),

// 二级"全部"选项（显示在右侧顶部）
childAllItemBuilder: (String? parentItemId) {
if (parentItemId == null) return null;
// 使用父项 ID 作为二级"全部"的 ID
return CategoryEntity(
id: parentItemId,
pid: parentItemId,
name: "全部",
);
}
```

### 单选模式返回值说明

- **点击普通子项**：返回该子项数据
- **点击父项的"全部"**：返回该父项数据
- **点击一级"全部"的"全部"**：返回 `null`

## 父子联动逻辑

1. **选择父项**：自动取消该父项下所有子项的选中状态
2. **选择子项**：自动取消父项的选中状态
3. **全选子项**：当所有子项都被选中时，自动转换为父项选中，并清除子项选中状态
4. **部分选中**：部分子项被选中时，父项显示为未选中，子项保持选中状态

## 使用场景

### 场景1：选中父项"全部"

```
用户操作：点击"华东地区" → 点击右侧"全部"
底部显示：[华东地区 ×]
内部状态：selectedIds = ['east']
```

### 场景2：选中部分子项

```
用户操作：点击"华东地区" → 选中"上海"和"杭州"
底部显示：[上海 ×] [杭州 ×]
内部状态：selectedIds = ['shanghai', 'hangzhou']
```

### 场景3：选中所有子项（自动转换）

```
用户操作：点击"华东地区" → 依次选中"上海"、"杭州"、"南京"
自动转换：选中状态自动合并为父项
底部显示：[华东地区 ×]
内部状态：selectedIds = ['east']
```

### 场景4：选中全局"全部"

```
用户操作：点击一级"全部" → 点击二级"全部"
单选返回：null（表示选中了所有分类）
```

## API 参数

### TwoPaneSelector

| 参数                    | 类型                      | 必填 | 说明                        |
|-----------------------|-------------------------|----|---------------------------|
| `title`               | `String`                | 是  | 标题                        |
| `mode`                | `SelectorMode`          | 是  | 选择模式（single/multiple）     |
| `items`               | `List<T>`               | 是  | 数据列表（T 必须实现 SelectorItem） |
| `initialSelectedIds`  | `List<ID>?`             | 否  | 初始选中的ID列表                 |
| `parentItemBuilder`   | `Widget Function`       | 是  | 左侧父项构建器（只负责UI展示）          |
| `childItemBuilder`    | `Widget Function`       | 是  | 右侧子项构建器（只负责UI展示）          |
| `selectedItemBuilder` | `Widget Function`       | 否  | 已选项目构建器（底部栏，默认样式）         |
| `parentAllItem`       | `T?`                    | 否  | 一级"全部"选项的数据               |
| `childAllItemBuilder` | `T? Function(ID?)`      | 是  | 二级"全部"选项的数据构建器            |
| `onConfirm`           | `Function(List<T>)?`    | 否  | 确认回调（多选）                  |
| `onItemTap`           | `Function(T?)?`         | 否  | 点击回调（单选）                  |
| `onBack`              | `VoidCallback?`         | 否  | 返回回调                      |
| `onMaxLimitReached`   | `VoidCallback?`         | 否  | 达到选择上限时的回调                |
| `maxSelectedCount`    | `int`                   | 否  | 最大可选数量（默认为5）              |
| `emptyState`          | `Widget?`               | 否  | 空状态提示                     |
| `actionButton`        | `Widget?`               | 否  | 右上角自定义操作按钮                |
| `theme`               | `TwoPaneSelectorTheme?` | 否  | 主题配置                      |

### SelectorDialog.showSingle

| 参数                    | 类型                      | 必填 | 说明          |
|-----------------------|-------------------------|----|-------------|
| `context`             | `BuildContext`          | 是  | 上下文         |
| `title`               | `String`                | 是  | 标题          |
| `items`               | `List<T>`               | 是  | 数据列表        |
| `initialSelectedId`   | `ID?`                   | 否  | 初始选中的ID     |
| `parentItemBuilder`   | `Widget Function`       | 是  | 左侧父项构建器     |
| `childItemBuilder`    | `Widget Function`       | 是  | 右侧子项构建器     |
| `selectedItemBuilder` | `Widget Function`       | 否  | 已选项目构建器（多选） |
| `parentAllItem`       | `T?`                    | 否  | 一级"全部"选项    |
| `childAllItemBuilder` | `T? Function(ID?)`      | 是  | 二级"全部"选项构建器 |
| `onItemTap`           | `Function(T?)?`         | 否  | 点击回调（用于埋点等） |
| `theme`               | `TwoPaneSelectorTheme?` | 否  | 主题配置        |

### SelectorDialog.showMultiple

| 参数                    | 类型                      | 必填 | 说明            |
|-----------------------|-------------------------|----|---------------|
| `context`             | `BuildContext`          | 是  | 上下文           |
| `title`               | `String`                | 是  | 标题            |
| `items`               | `List<T>`               | 是  | 数据列表          |
| `initialSelectedIds`  | `List<ID>?`             | 否  | 初始选中的ID列表     |
| `parentItemBuilder`   | `Widget Function`       | 是  | 左侧父项构建器       |
| `childItemBuilder`    | `Widget Function`       | 是  | 右侧子项构建器       |
| `selectedItemBuilder` | `Widget Function`       | 否  | 已选项目构建器（默认样式） |
| `parentAllItem`       | `T?`                    | 否  | 一级"全部"选项      |
| `childAllItemBuilder` | `T? Function(ID?)`      | 是  | 二级"全部"选项构建器   |
| `onItemTap`           | `Function(T?)?`         | 否  | 点击回调（用于埋点等）   |
| `maxSelectedCount`    | `int`                   | 否  | 最大可选数量（默认为5）  |
| `onMaxLimitReached`   | `VoidCallback?`         | 否  | 达到上限时的回调      |
| `theme`               | `TwoPaneSelectorTheme?` | 否  | 主题配置          |

### Builder 签名

```dart
// 父项构建器（点击由内部处理）
Widget Function(
    BuildContext context,
    T item,
    bool isSelected, // 是否被选中
    bool hasSelectedItems, // 该父项下是否有被选中的子项
    ) parentItemBuilder

// 子项构建器（点击由内部处理）
Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
    ) childItemBuilder

// 已选项目构建器（底部栏，可选）
Widget Function(
    BuildContext context,
    T item,
    VoidCallback onRemove, // 移除回调
    ) selectedItemBuilder
```

## 底部已选栏样式

### 默认样式

不传 `selectedItemBuilder` 时，使用默认样式：

```
┌─────────────────────────────────────┐
│ 已选择          已选 2/5              │
│                                      │
│ [项目1 ×] [项目2 ×]                  │
│                                      │
│ ─────────────────────────────────   │
│                                      │
│ [清除]        [     确认选择     ]    │
└─────────────────────────────────────┘
```

### 自定义样式

传入 `selectedItemBuilder` 自定义已选项目的展示方式。

## 选择上限控制

多选模式下，可以设置最大可选数量：

```dart
SelectorDialog.showMultiple
(
context: context,
title: "选择分类",
items: categories,
maxSelectedCount: 5, // 最多选5个
onMaxLimitReached: () {
// 达到上限时的回调
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('已达上限')),
);
},
// ... 其他参数
)
```

## 注意事项

1. **数据模型必须实现 `SelectorItem<ID>` 接口**
2. 点击处理由组件内部统一处理，外部 builder 只需返回 UI widget
3. 一级"全部"使用特殊 ID（如 `"_all"`），二级"全部"使用父项 ID
4. 父项被选中表示该父项下的"全部"被选中
5. 确保每个数据项的 ID 是唯一的
6. `childAllItemBuilder` 是必填参数，即使不显示二级"全部"也需要提供（可返回 null）
7. 单选模式下点击任何选项都会自动关闭弹窗并返回结果
8. `selectedItemBuilder` 是可选参数，不传则使用默认样式
9. `maxSelectedCount` 默认值为 5
10. 弹窗默认不可通过点击外部关闭（`isDismissible: false`）
