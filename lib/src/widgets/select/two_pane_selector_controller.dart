import 'package:flutter/foundation.dart';

/// 通用的双栏选择器控制器
/// [T] 数据类型
/// [ID] ID类型
class TwoPaneSelectorController<T, ID> extends ChangeNotifier {
  /// 数据ID提取器
  final ID Function(T item) idExtractor;

  /// 父ID提取器
  final ID? Function(T item) parentIdExtractor;

  TwoPaneSelectorController({
    required this.idExtractor,
    required this.parentIdExtractor,
  });

  List<T> _items = [];
  ID? _selectedParentId;
  final Set<ID> _selectedIds = {};

  /// 数据列表
  List<T> get items => List.unmodifiable(_items);

  /// 当前选中的父项ID
  ID? get selectedParentId => _selectedParentId;

  /// 选中的ID集合
  Set<ID> get selectedIds => Set.unmodifiable(_selectedIds);

  /// 父项列表
  List<T> get parentItems =>
      _items.where((i) => parentIdExtractor(i) == null).toList();

  /// 子项列表（包含虚拟"全部"项）
  List<T> get childItems {
    if (_selectedParentId == null) return [];
    return _items.where((i) => parentIdExtractor(i) == _selectedParentId).toList();
  }

  /// 获取虚拟"全部"项（用于内部判断）
  T? getVirtualAllItem() {
    if (_selectedParentId == null) return null;
    return _items.firstWhere(
      (i) => idExtractor(i) == _selectedParentId && parentIdExtractor(i) == null,
      orElse: () => _items.first,
    );
  }

  /// 选中的项目列表（用于底部展示）
  /// 多选模式：返回所有选中的项（父项和子项）
  /// 如果父项被选中，只返回父项；如果是部分子项被选中，返回子项
  List<T> get selectedItems {
    final result = <T>[];
    for (final item in _items) {
      final id = idExtractor(item);
      if (_selectedIds.contains(id)) {
        result.add(item);
      }
    }
    return result;
  }

  /// 获取选中的项目（单选模式）
  T? get selectedItem {
    if (_selectedIds.isEmpty) return null;
    final id = _selectedIds.first;
    return _items.firstWhere(
      (i) => idExtractor(i) == id,
      orElse: () => _items.first,
    );
  }

  /// 初始化数据
  void init(List<T> data, {ID? initialParentId, List<ID>? selectedIds}) {
    _items = data;

    _selectedIds.clear();
    if (selectedIds != null) {
      _selectedIds.addAll(selectedIds);
    }

    if (initialParentId != null) {
      _selectedParentId = initialParentId;
    } else if (_selectedIds.isNotEmpty) {
      // 如果没有提供 initialParentId，但有选中的项目
      // 则自动将 _selectedParentId 设置为第一个选中项的父级ID
      final firstSelectedId = _selectedIds.first;
      final firstSelectedItem =
          _items.firstWhere((i) => idExtractor(i) == firstSelectedId, orElse: () => _items.first);
      final parentId = parentIdExtractor(firstSelectedItem);

      if (parentId != null) {
        // 如果是子项，选中其父级
        _selectedParentId = parentId;
      } else {
        // 如果本身就是父项，则选中自己
        _selectedParentId = firstSelectedId;
      }
    } else {
      // 如果既没有提供 initialParentId，也没有选中项
      // 则保持 _selectedParentId 为 null（将由 TwoPaneSelector 处理）
      _selectedParentId = null;
    }

    notifyListeners();
  }

  /// 选择父项
  void selectParent(ID? parentId) {
    if (_selectedParentId != parentId) {
      _selectedParentId = parentId;
      notifyListeners();
    }
  }

  /// 切换项目的选中状态
  void toggleSelection(ID itemId) {
    final item = _items.firstWhere((i) => idExtractor(i) == itemId);
    final parentId = parentIdExtractor(item);

    if (parentId == null) {
      _handleParentSelection(itemId);
    } else {
      _handleChildSelection(itemId, parentId);
    }

    notifyListeners();
  }

  /// 处理父项的选择（多选模式下，选中父项 = 选中该父项下的全部）
  void _handleParentSelection(ID parentId) {
    if (_selectedIds.contains(parentId)) {
      // 取消选中父项
      _selectedIds.remove(parentId);
    } else {
      // 选中父项，清除该父项下的所有子项选中状态
      final childIds = _items
          .where((i) => parentIdExtractor(i) == parentId)
          .map(idExtractor)
          .toList();
      _selectedIds.removeAll(childIds);
      _selectedIds.add(parentId);
    }
  }

  /// 处理子项的选择
  void _handleChildSelection(ID itemId, ID parentId) {
    // 先移除父项的选中状态（因为选择了具体子项）
    _selectedIds.remove(parentId);

    if (_selectedIds.contains(itemId)) {
      _selectedIds.remove(itemId);
    } else {
      _selectedIds.add(itemId);
    }

    // 获取所有子项
    final childIds = _items
        .where((i) => parentIdExtractor(i) == parentId)
        .map(idExtractor)
        .toList();

    // 检查是否所有子项都被选中
    if (childIds.isNotEmpty && childIds.every((id) => _selectedIds.contains(id))) {
      // 全部选中时，移除所有子项，只保留父项
      _selectedIds.removeAll(childIds);
      _selectedIds.add(parentId);
    }
  }

  /// 检查父项下是否有被选中的子项
  bool hasSelectedChildren(T parentItem) {
    final parentId = idExtractor(parentItem);
    return _selectedIds.any((id) =>
        id == parentId ||
        _items.any((i) => idExtractor(i) == id && parentIdExtractor(i) == parentId));
  }

  /// 检查父项是否被选中（表示选中了该父项下的全部）
  bool isParentSelected(ID? parentId) {
    if (parentId == null) return false;
    return _selectedIds.contains(parentId);
  }

  /// 检查当前父级下的所有子项是否都被选中
  bool areAllChildrenSelected(ID? parentId) {
    if (parentId == null) return false;
    // 如果父项被选中，表示全部被选中
    if (_selectedIds.contains(parentId)) return true;
    
    final childIds =
        _items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    if (childIds.isEmpty) return false;
    return childIds.every((id) => _selectedIds.contains(id));
  }

  /// 切换"全部"选项（实际上是切换父项的选中状态）
  void toggleAllChildren(ID? parentId) {
    if (parentId == null) return;

    if (_selectedIds.contains(parentId)) {
      // 如果父项被选中，取消选中
      _selectedIds.remove(parentId);
    } else {
      // 否则，选中父项，并清除所有子项
      final childIds =
          _items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
      _selectedIds.removeAll(childIds);
      _selectedIds.add(parentId);
    }

    notifyListeners();
  }

  /// 设置选中的ID集合
  void setSelectedIds(List<ID> ids) {
    _selectedIds.clear();
    _selectedIds.addAll(ids);
    notifyListeners();
  }

  /// 只选中父项（清除其下所有子项的选中状态）
  void selectParentOnly(ID parentId) {
    final childIds = _items
        .where((i) => parentIdExtractor(i) == parentId)
        .map(idExtractor)
        .toList();

    _selectedIds.removeAll(childIds);
    _selectedIds.add(parentId);
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    _selectedIds.clear();
    super.dispose();
  }
}
