import 'package:flutter/foundation.dart';

import 'selector_dialog.dart';
import 'selector_item.dart';

/// 通用的双栏选择器控制器（内部使用）
/// [T] 数据类型，必须实现 SelectorItem 接口
/// [ID] ID类型
class TwoPaneSelectorController<T extends SelectorItem<ID>, ID>
    extends ChangeNotifier {
  TwoPaneSelectorController({
    this.mode = SelectorMode.single,
    this.maxSelectedCount,
  });

  /// 选择模式
  final SelectorMode mode;

  /// 最大可选数量（null 表示无限制）
  final int? maxSelectedCount;

  List<T> _items = [];
  ID? _selectedParentId;
  final Set<ID> _selectedIds = {};
  String _searchQuery = '';

  /// 数据列表
  List<T> get items => List.unmodifiable(_items);

  /// 当前选中的父项ID
  ID? get selectedParentId => _selectedParentId;

  /// 选中的ID集合
  Set<ID> get selectedIds => Set.unmodifiable(_selectedIds);

  /// 当前搜索关键词
  String get searchQuery => _searchQuery;

  /// 父项列表
  List<T> get parentItems => _items.where((i) => i.pid == null).toList();

  /// 子项列表（包含虚拟"全部"项）
  List<T> get childItems {
    if (_selectedParentId == null) return [];
    return _items.where((i) => i.pid == _selectedParentId).toList();
  }

  /// 根据搜索关键词过滤后的父项列表
  List<T> get filteredParentItems {
    if (_searchQuery.isEmpty) return parentItems;
    final query = _searchQuery.toLowerCase();
    // 父项自身匹配，或其下有子项匹配，则保留
    return parentItems.where((parent) {
      if (parent.name.toLowerCase().contains(query)) return true;
      return _items.any(
        (child) =>
            child.pid == parent.id && child.name.toLowerCase().contains(query),
      );
    }).toList();
  }

  /// 根据搜索关键词过滤后的子项列表
  List<T> get filteredChildItems {
    if (_searchQuery.isEmpty) return childItems;
    final query = _searchQuery.toLowerCase();
    return childItems
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  /// 是否处于搜索模式（有搜索关键词）
  bool get isSearching => _searchQuery.isNotEmpty;

  /// 搜索结果：所有匹配的项目（扁平列表，包含父项和子项）
  List<T> get searchResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return _items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  /// 选中的项目列表（用于底部展示）
  /// 多选模式：返回所有选中的项（父项和子项）
  /// 如果父项被选中，只返回父项；如果是部分子项被选中，返回子项
  List<T> get selectedItems {
    final result = <T>[];
    for (final item in _items) {
      if (_selectedIds.contains(item.id)) {
        result.add(item);
      }
    }
    return result;
  }

  /// 获取选中的项目（单选模式）
  T? get selectedItem {
    if (_selectedIds.isEmpty) return null;
    final id = _selectedIds.first;
    return _items.firstWhere((i) => i.id == id, orElse: () => _items.first);
  }

  /// 初始化数据
  void init(List<T> data, {List<ID>? selectedIds}) {
    _items = data;

    _selectedIds.clear();
    if (selectedIds != null) {
      _selectedIds.addAll(selectedIds);
    }

    if (_selectedIds.isNotEmpty) {
      // 取第一个选中项
      final firstSelectedId = _selectedIds.first;
      final firstSelectedItem = _items.firstWhere(
        (i) => i.id == firstSelectedId,
        orElse: () => _items.first,
      );
      final parentId = firstSelectedItem.pid;

      if (parentId != null) {
        // 如果是子项，选中其父级
        _selectedParentId = parentId;
      } else {
        // 如果本身就是父项，则选中自己
        _selectedParentId = firstSelectedId;
      }
    } else {
      // 默认选中左侧第一个父项
      _selectedParentId = parentItems.isEmpty ? null : parentItems.first.id;
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

  /// 检查是否已达到选择上限
  bool get isMaxLimitReached {
    if (maxSelectedCount == null) return false;
    return _selectedIds.length >= maxSelectedCount!;
  }

  /// 检查是否可以选中指定数量的项目
  bool canSelect(int count) {
    if (maxSelectedCount == null) return true;
    return _selectedIds.length + count <= maxSelectedCount!;
  }

  /// 切换项目的选中状态
  /// 返回 true 表示操作成功，false 表示达到上限
  bool toggleSelection(ID itemId) {
    final item = _items.firstWhere((i) => i.id == itemId);
    final parentId = item.pid;

    if (mode == SelectorMode.single) {
      // 单选模式：清除之前的选择，只保留当前选择
      _selectedIds.clear();
      _selectedIds.add(itemId);

      // 更新选中的父项
      if (parentId != null) {
        _selectedParentId = parentId;
      } else {
        _selectedParentId = itemId;
      }

      notifyListeners();
      return true;
    }

    // 多选模式：检查是否是取消选中操作
    if (_selectedIds.contains(itemId)) {
      // 取消选中，总是允许
      if (parentId == null) {
        _handleParentSelection(itemId);
      } else {
        _handleChildSelection(itemId, parentId);
      }
      notifyListeners();
      return true;
    }

    // 新选中操作，检查是否达到上限
    if (isMaxLimitReached) {
      return false;
    }

    // 多选模式：使用父子联动逻辑
    if (parentId == null) {
      _handleParentSelection(itemId);
    } else {
      _handleChildSelection(itemId, parentId);
    }

    notifyListeners();
    return true;
  }

  /// 处理父项的选择（多选模式下，选中父项 = 选中该父项下的全部）
  void _handleParentSelection(ID parentId) {
    if (_selectedIds.contains(parentId)) {
      // 取消选中父项
      _selectedIds.remove(parentId);
    } else {
      // 选中父项，清除该父项下的所有子项选中状态
      final childIds =
          _items.where((i) => i.pid == parentId).map((i) => i.id).toList();
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
    final childIds =
        _items.where((i) => i.pid == parentId).map((i) => i.id).toList();

    // 检查是否所有子项都被选中
    if (childIds.isNotEmpty &&
        childIds.every((id) => _selectedIds.contains(id))) {
      // 全部选中时，移除所有子项，只保留父项
      _selectedIds.removeAll(childIds);
      _selectedIds.add(parentId);
    }
  }

  /// 检查父项下是否有被选中的子项
  bool hasSelectedChildren(T parentItem) {
    final parentId = parentItem.id;
    return _selectedIds.any(
      (id) =>
          id == parentId || _items.any((i) => i.id == id && i.pid == parentId),
    );
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
        _items.where((i) => i.pid == parentId).map((i) => i.id).toList();
    if (childIds.isEmpty) return false;
    return childIds.every((id) => _selectedIds.contains(id));
  }

  /// 切换"全部"选项（实际上是切换父项的选中状态）
  /// 返回 true 表示操作成功，false 表示达到上限
  bool toggleAllChildren(ID? parentId) {
    if (parentId == null) return true;

    if (mode == SelectorMode.single) {
      // 单选模式：清除之前的选择，只选中当前父项
      _selectedIds.clear();
      _selectedIds.add(parentId);
      _selectedParentId = parentId;
      notifyListeners();
      return true;
    }

    // 多选模式：检查是否是取消选中操作
    if (_selectedIds.contains(parentId)) {
      _selectedIds.remove(parentId);
      notifyListeners();
      return true;
    }

    // 新选中操作，检查是否达到上限
    if (isMaxLimitReached) {
      return false;
    }

    final childIds =
        _items.where((i) => i.pid == parentId).map((i) => i.id).toList();
    _selectedIds.removeAll(childIds);
    _selectedIds.add(parentId);
    notifyListeners();
    return true;
  }

  /// 设置选中的ID集合
  void setSelectedIds(List<ID> ids) {
    _selectedIds.clear();
    _selectedIds.addAll(ids);
    notifyListeners();
  }

  /// 更新搜索关键词
  void updateSearch(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// 清除搜索关键词
  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      notifyListeners();
    }
  }

  /// 清除所有选中项
  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    _selectedIds.clear();
    super.dispose();
  }
}
