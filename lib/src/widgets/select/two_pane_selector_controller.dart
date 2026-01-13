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

  /// 子项列表
  List<T> get childItems {
    if (_selectedParentId == null) return [];
    return _items.where((i) => parentIdExtractor(i) == _selectedParentId).toList();
  }

  /// 选中的项目列表
  /// 排除虚拟"全部"项（id == pid 的项），只返回实际选中的项目
  List<T> get selectedItems =>
      _items.where((i) {
        final id = idExtractor(i);
        final pid = parentIdExtractor(i);
        // 排除虚拟"全部"项（id == pid 且 pid != null）
        if (pid != null && id == pid) return false;
        return _selectedIds.contains(id);
      }).toList();

  /// 获取选中的项目（单选模式）
  T? get selectedItem {
    if (_selectedIds.isEmpty) return null;
    final id = _selectedIds.first;
    return _items.firstWhere((i) {
      final itemId = idExtractor(i);
      final pid = parentIdExtractor(i);
      // 排除虚拟"全部"项
      if (pid != null && itemId == pid) return false;
      return itemId == id;
    }, orElse: () => _items.first);
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

  /// 处理父项的选择
  void _handleParentSelection(ID parentId) {
    if (_selectedIds.contains(parentId)) {
      _selectedIds.remove(parentId);
      return;
    }

    // 获取所有子项（包括虚拟"全部"项），以便清除它们
    final childIds = _items
        .where((i) => parentIdExtractor(i) == parentId)
        .map(idExtractor)
        .toList();

    _selectedIds.removeAll(childIds);
    _selectedIds.add(parentId);
  }

  /// 处理子项的选择
  void _handleChildSelection(ID itemId, ID parentId) {
    if (_selectedIds.contains(itemId)) {
      _selectedIds.remove(itemId);
    } else {
      _selectedIds.add(itemId);
    }

    _selectedIds.remove(parentId);

    // 获取所有真实子项（排除虚拟"全部"项，即排除 id == pid 的项）
    final childIds = _items
        .where((i) {
          final pid = parentIdExtractor(i);
          final id = idExtractor(i);
          return pid == parentId && id != parentId;
        })
        .map(idExtractor)
        .toList();

    // 如果有真实子项，检查是否全部被选中
    if (childIds.isNotEmpty) {
      final allChildrenSelected = childIds.every((id) => _selectedIds.contains(id));
      if (allChildrenSelected) {
        _selectedIds.removeAll(childIds);
        _selectedIds.add(parentId);
      }
    }
  }

  /// 检查父项下是否有被选中的子项
  bool hasSelectedChildren(T parentItem) {
    final parentId = idExtractor(parentItem);
    return _selectedIds.any((id) =>
        id == parentId ||
        _items.any((i) => idExtractor(i) == id && parentIdExtractor(i) == parentId));
  }

  /// 检查当前父级下的所有子项是否都被选中
  bool areAllChildrenSelected(ID? parentId) {
    if (parentId == null) return false;
    final childIds =
        _items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    if (childIds.isEmpty) return false;
    return childIds.every((id) => _selectedIds.contains(id));
  }

  /// 切换当前父级下所有子项的选中状态
  void toggleAllChildren(ID? parentId) {
    if (parentId == null) return;

    final childIds =
        _items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    final allSelected = childIds.every((id) => _selectedIds.contains(id));

    if (allSelected) {
      // 如果全部选中，则取消选择所有子项
      _selectedIds.removeAll(childIds);
    } else {
      // 否则，选中所有子项
      _selectedIds.addAll(childIds);
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
