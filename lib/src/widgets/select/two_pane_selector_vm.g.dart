// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'two_pane_selector_vm.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TwoPaneSelectorVm<T, ID> on TwoPaneSelectorVmBase<T, ID>, Store {
  Computed<List<T>>? _$parentItemsComputed;

  @override
  List<T> get parentItems =>
      (_$parentItemsComputed ??= Computed<List<T>>(() => super.parentItems,
              name: 'TwoPaneSelectorVmBase.parentItems'))
          .value;
  Computed<List<T>>? _$childItemsComputed;

  @override
  List<T> get childItems =>
      (_$childItemsComputed ??= Computed<List<T>>(() => super.childItems,
              name: 'TwoPaneSelectorVmBase.childItems'))
          .value;
  Computed<List<T>>? _$selectedItemsComputed;

  @override
  List<T> get selectedItems =>
      (_$selectedItemsComputed ??= Computed<List<T>>(() => super.selectedItems,
              name: 'TwoPaneSelectorVmBase.selectedItems'))
          .value;
  Computed<T?>? _$selectedItemComputed;

  @override
  T? get selectedItem =>
      (_$selectedItemComputed ??= Computed<T?>(() => super.selectedItem,
              name: 'TwoPaneSelectorVmBase.selectedItem'))
          .value;

  late final _$itemsAtom =
      Atom(name: 'TwoPaneSelectorVmBase.items', context: context);

  @override
  ObservableList<T> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<T> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$selectedParentIdAtom =
      Atom(name: 'TwoPaneSelectorVmBase.selectedParentId', context: context);

  @override
  ID? get selectedParentId {
    _$selectedParentIdAtom.reportRead();
    return super.selectedParentId;
  }

  @override
  set selectedParentId(ID? value) {
    _$selectedParentIdAtom.reportWrite(value, super.selectedParentId, () {
      super.selectedParentId = value;
    });
  }

  late final _$selectedIdsAtom =
      Atom(name: 'TwoPaneSelectorVmBase.selectedIds', context: context);

  @override
  ObservableSet<ID> get selectedIds {
    _$selectedIdsAtom.reportRead();
    return super.selectedIds;
  }

  @override
  set selectedIds(ObservableSet<ID> value) {
    _$selectedIdsAtom.reportWrite(value, super.selectedIds, () {
      super.selectedIds = value;
    });
  }

  late final _$TwoPaneSelectorVmBaseActionController =
      ActionController(name: 'TwoPaneSelectorVmBase', context: context);

  @override
  void init(List<T> data, {ID? initialParentId, List<ID>? selectedIds}) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase.init');
    try {
      return super.init(data,
          initialParentId: initialParentId, selectedIds: selectedIds);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectParent(ID? parentId) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase.selectParent');
    try {
      return super.selectParent(parentId);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSelection(ID itemId) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase.toggleSelection');
    try {
      return super.toggleSelection(itemId);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleParentSelection(ID parentId) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase._handleParentSelection');
    try {
      return super._handleParentSelection(parentId);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleChildSelection(ID itemId, ID parentId) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase._handleChildSelection');
    try {
      return super._handleChildSelection(itemId, parentId);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAllChildren(ID? parentId) {
    final _$actionInfo = _$TwoPaneSelectorVmBaseActionController.startAction(
        name: 'TwoPaneSelectorVmBase.toggleAllChildren');
    try {
      return super.toggleAllChildren(parentId);
    } finally {
      _$TwoPaneSelectorVmBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items},
selectedParentId: ${selectedParentId},
selectedIds: ${selectedIds},
parentItems: ${parentItems},
childItems: ${childItems},
selectedItems: ${selectedItems},
selectedItem: ${selectedItem}
    ''';
  }
}
