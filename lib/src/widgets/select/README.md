# 双栏选择器组件 (Two Pane Selector)

通用的双栏选择器组件，支持单选和多选模式，适用于分类、单位等层级数据的场景。

## 功能特性

- 支持单选/多选模式
- 左右分栏布局，左侧显示父级分类，右侧显示子级项目
- 支持外部配置一级"全部"和二级"全部"选项
- 多选模式下底部展示已选项目
- 支持父子联动选择，智能合并选择状态
- 泛型设计，支持任意数据类型
- 灵活的渲染器自定义
- 使用 ChangeNotifier 进行状态管理（不依赖 MobX）

## 快速开始

```dart
import 'package:ruolanui/ruolanui.dart';

TwoPaneSelector<CityItem, String>(
  title: '选择城市',
  mode: SelectorMode.multiple,
  items: cities,
  idExtractor: (item) => item.id,
  parentIdExtractor: (item) => item.parentId,
  parentItemBuilder: (context, item, isSelected, hasSelectedItems, onTap) {
    return ListTile(title: Text(item.name), onTap: onTap);
  },
  childItemBuilder: (context, item, isSelected, onTap) {
    return CheckboxListTile(value: isSelected, title: Text(item.name), onChanged: (_) => onTap());
  },
  selectedItemBuilder: (context, item, onRemove) {
    return Chip(label: Text(item.name), onDeleted: onRemove);
  },
  onConfirm: (selected) {
    // 处理选中的项目（多选模式）
  },
)
```

## "全部"选项配置

组件支持从外部配置一级"全部"和二级"全部"选项：

- **`parentAllItem`**: 一级"全部"选项的数据（null 表示不显示一级"全部"）
- **`childAllItemBuilder`**: 二级"全部"选项的数据构建器，参数为当前选中的父项ID

### 配置示例

```dart
// 一级"全部"选项
static const _parentAllItem = CategoryEntity(
  id: '_all',  // 使用特殊 ID 表示全局全部
  name: "全部",
  pid: null,
);

// 构建二级"全部"选项
CategoryEntity? _buildChildAllItem(String? parentItemId) {
  if (parentItemId == null) return null;
  // 使用父项 ID 作为二级"全部"的 ID
  return CategoryEntity(
    id: parentItemId,
    name: "全部",
    pid: parentItemId,
  );
}

TwoPaneSelector<CategoryEntity, String>(
  // ... 其他参数
  parentAllItem: _parentAllItem,
  childAllItemBuilder: _buildChildAllItem,
);
```

## 单选模式返回逻辑

在单选模式下，需要通过 `onItemTap` 回调处理返回逻辑（关闭弹窗等）：

```dart
onItemTap: (item) {
  if (item == null) {
    // 点击了全局"全部"，返回 null
    SmartDialog.dismiss(result: null);
    return;
  }
  if (mode == SelectMode.single) {
    // 单选模式，关闭弹窗并返回选中的项目
    SmartDialog.dismiss(result: item);
    return;
  }
}
```

**说明**：
- 当 `item == null` 时，表示用户点击了全局"全部"（一级"全部"下的二级"全部"）
- 当 `item != null` 时，可能是：
  - 普通子项被选中
  - 父项下的二级"全部"被选中（返回父项数据）

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
返回：null（表示选中了所有分类）
```

## API 参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `title` | `String` | 是 | 标题 |
| `mode` | `SelectorMode` | 是 | 选择模式（single/multiple） |
| `items` | `List<T>` | 是 | 数据列表 |
| `idExtractor` | `ID Function(T)` | 是 | ID提取器 |
| `parentIdExtractor` | `ID? Function(T)` | 是 | 父ID提取器 |
| `parentItemBuilder` | `Widget Function` | 是 | 左侧父项构建器 |
| `childItemBuilder` | `Widget Function` | 是 | 右侧子项构建器 |
| `selectedItemBuilder` | `Widget Function` | 是 | 已选项目构建器 |
| `parentAllItem` | `T?` | 否 | 一级"全部"选项的数据 |
| `childAllItemBuilder` | `T? Function(ID?)` | 是 | 二级"全部"选项的数据构建器 |
| `onConfirm` | `Function(List<T>)?` | 否 | 确认回调（多选） |
| `onItemTap` | `Function(T?)?` | 否 | 点击回调（单选，需处理关闭弹窗等逻辑） |
| `onBack` | `VoidCallback?` | 否 | 返回回调 |
| `emptyState` | `Widget?` | 否 | 空状态提示 |
| `actionButton` | `Widget?` | 否 | 右上角自定义操作按钮 |
| `theme` | `TwoPaneSelectorTheme?` | 否 | 主题配置 |

## 选择结果处理

```dart
// 多选模式
onConfirm: (selectedItems) {
  for (final item in selectedItems) {
    final parentId = parentIdExtractor(item);

    if (parentId == null) {
      // 父项被选中，表示该父项下的"全部"
      print('选中了 ${item.name} 的全部');
    } else {
      // 子项被选中
      print('选中了子项 ${item.name}');
    }
  }
}

// 单选模式
onItemTap: (item) {
  if (item == null) {
    // 全局"全部"被选中
    Navigator.pop(context, null);
  } else {
    // 普通项目或父项"全部"被选中
    Navigator.pop(context, item);
  }
}
```

## 注意事项

1. 一级"全部"使用特殊 ID（如 `"_all"`），二级"全部"使用父项 ID
2. `onItemTap` 在单选模式下需要处理关闭弹窗的逻辑
3. 父项被选中表示该父项下的"全部"被选中
4. 确保每个数据项的 ID 是唯一的
5. parentIdExtractor 应返回 null 表示顶级项目
6. `childAllItemBuilder` 是必填参数，即使不显示二级"全部"也需要提供（可返回 null）
