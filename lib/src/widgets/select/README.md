# 双栏选择器组件 (Two Pane Selector)

通用的双栏选择器组件，支持单选和多选模式，适用于分类、单位等层级数据的场景。

## 功能特性

- 支持单选/多选模式
- 左右分栏布局，左侧显示父级分类，右侧显示子级项目
- 多选模式下底部展示已选项目
- 支持父子联动选择
- 泛型设计，支持任意数据类型
- 灵活的渲染器自定义
- 使用 ChangeNotifier 进行状态管理（不依赖 MobX）

## 目录结构

```
lib/src/widgets/select/
├── two_pane_selector_controller.dart # Controller (ChangeNotifier)
├── two_pane_selector.dart             # UI 组件
├── two_pane_selector_adapter.dart    # 数据适配器
├── two_pane_selector_theme.dart      # 主题配置
├── selector_dialog.dart              # 弹窗工具类
└── README.md                          # 使用文档
```

## 快速开始

### 1. 导入组件

```dart
import 'package:ruolanui/ruolanui.dart';
```

### 2. 基础使用

```dart
TwoPaneSelector<CategoryEntity, String>(
  title: "选择分类",
  idExtractor: (category) => category.id,
  parentIdExtractor: (category) => category.pid,
  mode: SelectorMode.multiple,
  items: categories,
  initialSelectedIds: ['cat1', 'cat2'],
  parentItemBuilder: (context, item, isSelected, hasSelectedItems, onTap) {
    return ListTile(
      title: Text(item.name),
      selected: isSelected,
      onTap: onTap,
    );
  },
  childItemBuilder: (context, item, isSelected, onTap) {
    return ListTile(
      title: Text(item.name),
      leading: isSelected ? const Icon(Icons.check_circle) : null,
      onTap: onTap,
    );
  },
  selectedItemBuilder: (context, item, onRemove) {
    return Chip(
      label: Text(item.name),
      onDeleted: onRemove,
    );
  },
  onBack: () => Navigator.pop(context),
  onConfirm: (selectedItems) {
    // 处理选中的项目
    print('已选: ${selectedItems.length} 项');
  },
)
```

## 数据结构支持

组件支持两种数据结构：

### 1. 扁平结构（带 parentId）

适用于每个数据项有 `parentId` 或 `pid` 字段指向父级的结构：

```dart
class CategoryEntity {
  final String id;
  final String? pid;  // 父级ID
  final String name;
  // ...
}

// 直接使用
TwoPaneSelector<CategoryEntity, String>(
  idExtractor: (c) => c.id,
  parentIdExtractor: (c) => c.pid,
  items: categories,
  // ...
)
```

### 2. 嵌套结构（分组容器）

适用于分类包含子项的嵌套结构，需要使用适配器转换：

```dart
class InventoryCategory {
  final String category;
  final List<InventoryUnit> units;
}

// 使用适配器转换
final adapter = SelectorDataAdapter<InventoryUnit, String>(
  idExtractor: (unit) => unit.id,
  nameExtractor: (unit) => unit.name,
);

final groups = categories.map((cat) => GroupedData(
  groupId: cat.category,
  groupName: cat.category,
  items: cat.units,
)).toList();

final input = adapter.fromGroupedStructure(groups: groups);
final items = input.items;

TwoPaneSelector<GroupedItem<InventoryUnit, String>, String>(
  idExtractor: (item) => item.itemId,
  parentIdExtractor: (item) => item.isItem ? item.groupId : null,
  items: items,
  // ...
)
```

## API 文档

### TwoPaneSelector

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `title` | `String` | 是 | 弹窗标题 |
| `idExtractor` | `ID Function(T)` | 是 | 数据ID提取器 |
| `parentIdExtractor` | `ID? Function(T)` | 是 | 父ID提取器 |
| `mode` | `SelectorMode` | 是 | 选择模式（single/multiple） |
| `items` | `List<T>` | 是 | 数据列表 |
| `parentItemBuilder` | `Widget Function` | 是 | 左侧父项构建器 |
| `childItemBuilder` | `Widget Function` | 是 | 右侧子项构建器 |
| `selectedItemBuilder` | `Widget Function` | 是 | 已选项目构建器 |
| `initialParentId` | `ID?` | 否 | 初始选中的父项ID |
| `initialSelectedIds` | `List<ID>?` | 否 | 初始选中的项目ID列表 |
| `emptyState` | `Widget?` | 否 | 空状态组件 |
| `actionButton` | `Widget?` | 否 | 右上角自定义按钮 |
| `onConfirm` | `Function(List<T>)?` | 否 | 确认回调（多选模式） |
| `onBack` | `VoidCallback?` | 否 | 返回回调 |
| `onItemTap` | `Function(T?)?` | 否 | 子项点击回调（单选模式） |
| `theme` | `TwoPaneSelectorTheme?` | 否 | 主题配置 |
| `showSelectAll` | `bool` | `false` | 是否显示"全部"选项（多选模式） |
| `selectAllText` | `String` | `"全部"` | "全部"选项的文字 |
| `selectAllBuilder` | `Widget Function?` | `null` | "全部"选项的自定义构建器 |
| `onItemTapOverride` | `bool Function(T)?` | `null` | 子项点击覆盖回调（返回 true 表示阻止默认行为） |
| `isSelectedOverride` | `bool Function(T, bool)?` | `null` | 子项选中状态覆盖回调 |

#### 高级功能：点击覆盖

通过 `onItemTapOverride` 可以自定义某些项目的点击行为：

```dart
TwoPaneSelector<CategoryEntity, String>(
  onItemTapOverride: (category) {
    // 特殊项目的自定义处理
    if (category.isVirtual) {
      // 自定义逻辑
      return true; // 阻止默认行为
    }
    return false; // 使用默认行为
  },
  // ... 其他参数
)
```

#### 高级功能：选中状态覆盖

通过 `isSelectedOverride` 可以自定义某些项目的选中状态显示：

```dart
TwoPaneSelector<CategoryEntity, String>(
  isSelectedOverride: (category, defaultIsSelected) {
    // 对于虚拟"全部"项，检查其父级是否被选中
    if (category.isVirtual && category.pid != null) {
      final controller = _selectorKey.currentState?.controller;
      return controller?.selectedIds.contains(category.pid) ?? false;
    }
    return defaultIsSelected;
  },
  // ... 其他参数
)
```

### TwoPaneSelectorController

选择器的控制器，可以通过 `GlobalKey` 访问：

```dart
final _selectorKey = GlobalKey<TwoPaneSelectorState<CategoryEntity, String>>();

// 访问控制器
final controller = _selectorKey.currentState?.controller;

// 获取选中的项目
final selectedItems = controller?.selectedItems;

// 只选中父项（清除其下所有子项）
controller?.selectParentOnly(parentId);

// 设置选中的ID集合
controller?.setSelectedIds([id1, id2, id3]);
```

#### Controller 方法

| 方法 | 说明 |
|------|------|
| `init(List<T> data, {ID? initialParentId, List<ID>? selectedIds})` | 初始化数据 |
| `selectParent(ID? parentId)` | 选择父项 |
| `toggleSelection(ID itemId)` | 切换项目的选中状态 |
| `selectParentOnly(ID parentId)` | 只选中父项（清除其下所有子项） |
| `setSelectedIds(List<ID> ids)` | 设置选中的ID集合 |
| `toggleAllChildren(ID? parentId)` | 切换当前父级下所有子项的选中状态 |

#### Controller 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `items` | `List<T>` | 数据列表 |
| `selectedParentId` | `ID?` | 当前选中的父项ID |
| `selectedIds` | `Set<ID>` | 选中的ID集合 |
| `parentItems` | `List<T>` | 父项列表 |
| `childItems` | `List<T>` | 子项列表 |
| `selectedItems` | `List<T>` | 选中的项目列表 |
| `selectedItem` | `T?` | 选中的项目（单选模式） |

### TwoPaneSelectorTheme

主题配置类，用于自定义选择器的样式。

#### 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `containerHeightFactor` | `double` | `0.65` | 容器高度（相对于屏幕高度的比例） |
| `containerBorderRadius` | `BorderRadius` | `BorderRadius.only(topLeft: 12, topRight: 12)` | 容器圆角 |
| `containerColor` | `Color?` | 主题色 | 容器背景色 |
| `leftPanelWidthFactor` | `double` | `0.3` | 左侧面板宽度比例（0-1） |
| `leftPanelColor` | `Color?` | 主题色 | 左侧面板背景色 |
| `rightPanelColor` | `Color?` | 主题色 | 右侧面板背景色 |
| `headerPadding` | `EdgeInsets` | `EdgeInsets.symmetric(horizontal: 16, vertical: 16)` | 标题栏内边距 |
| `titleStyle` | `TextStyle?` | 主题样式 | 标题文字样式 |
| `backIconSize` | `double` | `24.0` | 返回按钮图标大小 |
| `backIconSpacing` | `double` | `12.0` | 返回按钮与标题间距 |
| `confirmButtonHeight` | `double` | `32.0` | 确认按钮高度 |
| `confirmButtonBorderRadius` | `double` | `9.0` | 确认按钮圆角 |
| `confirmButtonText` | `String` | `"确定"` | 确认按钮文字 |
| `emptyStateText` | `String` | `"请选择左侧项目"` | 空状态提示文字 |
| `emptyStateTextStyle` | `TextStyle?` | 主题样式 | 空状态文字样式 |
| `bottomBarTopPadding` | `double` | `12` | 底部已选项目栏顶部内边距 |
| `dividerHeight` | `double` | `1` | 分割线高度 |

## 父子联动逻辑

组件内置了智能的父子联动选择逻辑：

1. **选择父级**：自动取消所有子级的选中状态，只选中父级
2. **选择子级**：自动取消父级的选中状态
3. **全选子级**：当所有子级都被选中时，自动切换为选中父级
4. **部分选中**：当部分子级被选中时，父级显示为未选中，但子级保持选中状态

## 虚拟"全部"项实现模式

对于需要在每个父级下显示"全部"选项的场景（如分类选择），可以创建虚拟子项：

```dart
// 创建虚拟"全部"子项（使用父级的ID）
final allChildren = parentCategories.map((parent) {
  return CategoryEntity(
    id: parent.id,        // 使用父级的ID
    pid: parent.id,       // 指向父级
    name: "全部",
    order: 0,
  );
}).toList();

return [
  const CategoryEntity(id: '_all', name: "全部", pid: null),
  ...allChildren,
  ...data,
];
```

然后使用 `isSelectedOverride` 来确保虚拟"全部"项的选中状态正确显示：

```dart
isSelectedOverride: (category, defaultIsSelected) {
  // 对于虚拟"全部"项，检查其父级是否被选中
  if (category.name == "全部" && category.pid != null) {
    final controller = _selectorKey.currentState?.controller;
    if (controller != null) {
      return controller.selectedIds.contains(category.pid);
    }
  }
  return defaultIsSelected;
},
```

## 注意事项

1. **ID 唯一性**：确保每个数据项的 ID 是唯一的
2. **父子关系**：parentIdExtractor 应返回 null 表示顶级项目
3. **虚拟项处理**：如果使用虚拟"全部"项，确保其 ID 与父级 ID 相同，并使用 `isSelectedOverride` 处理显示
4. **状态管理**：组件内部使用 ChangeNotifier 管理状态，无需额外处理
5. **Controller 访问**：如需访问 Controller，使用 `GlobalKey<TwoPaneSelectorState<T, ID>>`
