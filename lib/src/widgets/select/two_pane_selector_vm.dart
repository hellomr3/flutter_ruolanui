import 'package:mobx/mobx.dart';

part 'two_pane_selector_vm.g.dart';

/// 通用的双栏选择器 ViewModel
/// [T] 数据类型
/// [ID] ID类型
class TwoPaneSelectorVm<T, ID> = TwoPaneSelectorVmBase<T, ID>
    with _$TwoPaneSelectorVm;

abstract class TwoPaneSelectorVmBase<T, ID> with Store {
  /// 数据ID提取器
  final ID Function(T item) idExtractor;

  /// 父ID提取器
  final ID? Function(T item) parentIdExtractor;

  TwoPaneSelectorVmBase({
    required this.idExtractor,
    required this.parentIdExtractor,
  });

  @observable
  ObservableList<T> items = ObservableList<T>();

  @observable
  ID? selectedParentId;

  @observable
  ObservableSet<ID> selectedIds = ObservableSet<ID>();

  @action
  void init(List<T> data, {ID? initialParentId, List<ID>? selectedIds}) {
    items.clear();
    items.addAll(data);

    this.selectedIds.clear();
    if (selectedIds != null) {
      this.selectedIds.addAll(selectedIds);
    }

    if (initialParentId != null) {
      selectedParentId = initialParentId;
    } else if (this.selectedIds.isNotEmpty) {
      // 如果没有提供 initialParentId，但有选中的项目
      // 则自动将 selectedParentId 设置为第一个选中项的父级ID
      final firstSelectedId = this.selectedIds.first;
      final firstSelectedItem =
          items.firstWhere((i) => idExtractor(i) == firstSelectedId);
      final parentId = parentIdExtractor(firstSelectedItem);

      if (parentId != null) {
        // 如果是子项，选中其父级
        selectedParentId = parentId;
      } else {
        // 如果本身就是父项，则选中自己
        selectedParentId = firstSelectedId;
      }
    }
  }

  @action
  void selectParent(ID? parentId) {
    selectedParentId = parentId;
  }

  @action
  void toggleSelection(ID itemId) {
    final item = items.firstWhere((i) => idExtractor(i) == itemId);
    final parentId = parentIdExtractor(item);

    if (parentId == null) {
      _handleParentSelection(itemId);
      return;
    }

    _handleChildSelection(itemId, parentId);
  }

  @action
  void _handleParentSelection(ID parentId) {
    if (selectedIds.contains(parentId)) {
      selectedIds.remove(parentId);
      return;
    }

    final childIds = items
        .where((i) => parentIdExtractor(i) == parentId)
        .map(idExtractor)
        .toList();

    selectedIds.removeAll(childIds);
    selectedIds.add(parentId);
  }

  @action
  void _handleChildSelection(ID itemId, ID parentId) {
    if (selectedIds.contains(itemId)) {
      selectedIds.remove(itemId);
    } else {
      selectedIds.add(itemId);
    }

    selectedIds.remove(parentId);

    final childIds =
        items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    final allChildrenSelected = childIds.every((id) => selectedIds.contains(id));

    if (allChildrenSelected && childIds.isNotEmpty) {
      selectedIds.removeAll(childIds);
      selectedIds.add(parentId);
    }
  }

  @computed
  List<T> get parentItems =>
      items.where((i) => parentIdExtractor(i) == null).toList();

  @computed
  List<T> get childItems {
    if (selectedParentId == null) return [];
    return items.where((i) => parentIdExtractor(i) == selectedParentId).toList();
  }

  @computed
  List<T> get selectedItems =>
      items.where((i) => selectedIds.contains(idExtractor(i))).toList();

  /// 获取选中的项目（单选模式）
  @computed
  T? get selectedItem {
    if (selectedIds.isEmpty) return null;
    final id = selectedIds.first;
    return items.firstWhere((i) => idExtractor(i) == id);
  }

  /// 检查父项下是否有被选中的子项
  bool hasSelectedChildren(T parentItem) {
    final parentId = idExtractor(parentItem);
    return selectedIds.any((id) =>
        id == parentId ||
        items.any((i) => idExtractor(i) == id && parentIdExtractor(i) == parentId));
  }

  /// 检查当前父级下的所有子项是否都被选中
  bool areAllChildrenSelected(ID? parentId) {
    if (parentId == null) return false;
    final childIds =
        items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    if (childIds.isEmpty) return false;
    return childIds.every((id) => selectedIds.contains(id));
  }

  /// 切换当前父级下所有子项的选中状态
  @action
  void toggleAllChildren(ID? parentId) {
    if (parentId == null) return;

    final childIds =
        items.where((i) => parentIdExtractor(i) == parentId).map(idExtractor).toList();
    final allSelected = childIds.every((id) => selectedIds.contains(id));

    if (allSelected) {
      // 如果全部选中，则取消选择所有子项
      selectedIds.removeAll(childIds);
    } else {
      // 否则，选中所有子项
      selectedIds.addAll(childIds);
    }
  }
}
