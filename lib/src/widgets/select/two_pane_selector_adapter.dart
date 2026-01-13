/// 通用的双栏选择器数据适配器
/// 用于将不同数据结构转换为统一的格式供 TwoPaneSelector 使用

/// 分组数据结构
/// 适用于数据本身是分组容器的情况（如 InventoryCategory）
class GroupedData<T, ID> {
  /// 分组ID/名称
  final ID groupId;

  /// 分组名称（用于显示）
  final String groupName;

  /// 分组下的子项列表
  final List<T> items;

  GroupedData({
    required this.groupId,
    required this.groupName,
    required this.items,
  });
}

/// 选择器数据适配器
/// 将不同数据结构转换为 TwoPaneSelector 所需的统一格式
class SelectorDataAdapter<T, ID> {
  /// 数据ID提取器
  final ID Function(T item) idExtractor;

  /// 数据显示名称提取器
  final String Function(T item) nameExtractor;

  const SelectorDataAdapter({
    required this.idExtractor,
    required this.nameExtractor,
  });

  /// 从扁平结构（带 parentId）创建数据列表
  /// 适用于 CategoryEntity 这种每个项目有 pid 指向父级的结构
  SelectorInput<T, ID> fromFlatStructure({
    required List<T> allItems,
    ID? Function(T item)? parentIdExtractor,
  }) {
    return SelectorInput<T, ID>(
      items: allItems,
      idExtractor: idExtractor,
      parentIdExtractor: parentIdExtractor ?? (_) => null,
    );
  }

  /// 从分组结构（GroupedData）创建数据列表
  /// 适用于 InventoryCategory 这种分类包含子项的嵌套结构
  SelectorInput<GroupedItem<T, ID>, ID> fromGroupedStructure({
    required List<GroupedData<T, ID>> groups,
  }) {
    final List<GroupedItem<T, ID>> items = [];

    // 添加分组项（作为父项）
    for (final group in groups) {
      items.add(GroupedItem<T, ID>.group(
        groupId: group.groupId,
        itemName: group.groupName,
      ));

      // 添加子项
      for (final item in group.items) {
        items.add(GroupedItem<T, ID>.item(
          groupId: group.groupId,
          itemName: nameExtractor(item),
          originalItem: item,
          itemId: idExtractor(item),
        ));
      }
    }

    return SelectorInput<GroupedItem<T, ID>, ID>(
      items: items,
      idExtractor: (item) => item.itemId,
      parentIdExtractor: (item) =>
          item.type == GroupedItemType.item ? item.groupId : null,
    );
  }
}

/// 分组项类型
enum GroupedItemType { group, item }

/// 统一的分组项数据结构
class GroupedItem<T, ID> {
  final GroupedItemType type;
  final ID groupId;
  final String itemName;
  final T? originalItem;
  final ID? _itemId;

  GroupedItem({
    required this.type,
    required this.groupId,
    required this.itemName,
    this.originalItem,
    ID? itemId,
  }) : _itemId = itemId;

  /// 创建分组项
  factory GroupedItem.group({
    required ID groupId,
    required String itemName,
  }) {
    return GroupedItem<T, ID>(
      type: GroupedItemType.group,
      groupId: groupId,
      itemName: itemName,
      itemId: groupId,
    );
  }

  /// 创建数据项
  factory GroupedItem.item({
    required ID groupId,
    required String itemName,
    required T originalItem,
    required ID itemId,
  }) {
    return GroupedItem<T, ID>(
      type: GroupedItemType.item,
      groupId: groupId,
      itemName: itemName,
      originalItem: originalItem,
      itemId: itemId,
    );
  }

  /// 获取项目的唯一ID
  ID get itemId {
    if (type == GroupedItemType.group) {
      return groupId;
    }
    return _itemId ?? groupId;
  }

  /// 是否为分组项
  bool get isGroup => type == GroupedItemType.group;

  /// 是否为数据项
  bool get isItem => type == GroupedItemType.item;
}

/// 选择器输入数据封装
class SelectorInput<T, ID> {
  final List<T> items;
  final ID Function(T item) idExtractor;
  final ID? Function(T item) parentIdExtractor;

  const SelectorInput({
    required this.items,
    required this.idExtractor,
    required this.parentIdExtractor,
  });
}
