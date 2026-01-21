import 'package:flutter/material.dart';

import 'selector_dialog.dart';
import 'selector_item.dart';
import 'two_pane_selector_controller.dart';
import 'two_pane_selector_theme.dart';
import 'widgets/selected_bottom_bar.dart';

/// 通用的双栏选择器组件（内部使用，不对外暴露）
/// [T] 数据类型，必须实现 SelectorItem 接口
/// [ID] ID类型
class TwoPaneSelector<T extends SelectorItem<ID>, ID> extends StatefulWidget {
  /// 标题
  final String title;

  /// 选择模式
  final SelectorMode mode;

  /// 初始选中的项目ID列表
  final List<ID>? initialSelectedIds;

  /// 数据列表
  final List<T> items;

  /// 左侧父项构建器（只负责 UI 展示，点击由内部处理）
  final Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
    bool hasSelectedItems,
  ) parentItemBuilder;

  /// 右侧子项构建器（只负责 UI 展示，点击由内部处理）
  final Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
  ) childItemBuilder;

  /// 已选项目构建器（用于底部展示栏）
  final Widget Function(
    BuildContext context,
    T item,
    VoidCallback onRemove,
  )? selectedItemBuilder;

  /// 空状态提示
  final Widget? emptyState;

  /// 右上角自定义操作按钮（会覆盖默认的确认按钮）
  final Widget? actionButton;

  /// 确认按钮点击回调（多选模式）
  final void Function(List<T> selectedItems)? onConfirm;

  /// 返回按钮点击回调
  final VoidCallback? onBack;

  /// 子项点击回调（单选模式，返回选中的项目）
  /// 注意：在单选模式下，需要外部在此回调中处理关闭弹窗等逻辑
  /// 多选模式下不使用此回调
  final void Function(T? selectedItem)? onItemTap;

  /// 主题配置
  final TwoPaneSelectorTheme? theme;

  /// 最大可选数量（多选模式，默认为5）
  final int maxSelectedCount;

  /// 达到选择上限时的回调（可选，用于外部提示"已达上限"）
  final VoidCallback? onMaxLimitReached;

  // ========== 新增："全部"选项配置 ==========

  /// 一级"全部"选项的数据（null 表示不显示一级"全部"）
  final T? parentAllItem;

  /// 二级"全部"选项的数据构建器
  /// 参数：当前选中的父项ID
  /// 返回：二级"全部"选项的数据（null 表示不显示二级"全部"）
  final T? Function(ID? parentItemId) childAllItemBuilder;

  const TwoPaneSelector({
    super.key,
    required this.title,
    required this.mode,
    required this.items,
    required this.parentItemBuilder,
    required this.childItemBuilder,
    this.selectedItemBuilder,
    this.initialSelectedIds,
    this.emptyState,
    this.actionButton,
    this.onConfirm,
    this.onBack,
    this.onItemTap,
    this.theme,
    this.maxSelectedCount = 5,
    this.onMaxLimitReached,
    this.parentAllItem,
    required this.childAllItemBuilder,
  });

  @override
  State<TwoPaneSelector<T, ID>> createState() => TwoPaneSelectorState<T, ID>();
}

/// TwoPaneSelector 的状态类
class TwoPaneSelectorState<T extends SelectorItem<ID>, ID>
    extends State<TwoPaneSelector<T, ID>> {
  late final TwoPaneSelectorController<T, ID> controller;

  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  TextTheme get textTheme => Theme.of(context).textTheme;

  /// 获取主题配置，如果没有提供则使用默认主题
  TwoPaneSelectorTheme get theme =>
      widget.theme ?? TwoPaneSelectorTheme.of(context);

  @override
  void initState() {
    super.initState();
    controller = TwoPaneSelectorController<T, ID>(
      mode: widget.mode,
      maxSelectedCount: widget.maxSelectedCount,
    );

    controller.init(
      widget.items,
      selectedIds: widget.initialSelectedIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * theme.containerHeightFactor,
      decoration: BoxDecoration(
        color: theme.containerColor ?? colorScheme.surface,
        borderRadius: theme.containerBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Divider(height: theme.dividerHeight),
          _buildContent(),
          if (widget.mode == SelectorMode.multiple) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          padding: theme.headerPadding,
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Icon(
                  Icons.arrow_back,
                  size: theme.backIconSize,
                ),
              ),
              SizedBox(width: theme.backIconSpacing),
              Text(
                widget.title,
                style: theme.titleStyle ?? textTheme.titleLarge,
              ),
              const Spacer(),
              if (widget.actionButton != null) widget.actionButton!
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final parentItems = controller.parentItems;
        final childItems = controller.childItems;
        final selectedParentId = controller.selectedParentId;

        return Expanded(
          child: Row(
            children: [
              // 左侧父项列表
              Container(
                width: MediaQuery.of(context).size.width *
                    theme.leftPanelWidthFactor,
                color: theme.leftPanelColor ?? colorScheme.surface,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // 左侧顶部"全部"选项（如果配置了）
                    if (widget.parentAllItem != null) _buildParentAllItem(),
                    // 父项列表
                    ...parentItems.map((item) {
                      final isSelected = selectedParentId == item.id;
                      final hasSelectedItems =
                          controller.hasSelectedChildren(item);

                      return InkWell(
                        onTap: () => controller.selectParent(item.id),
                        child: widget.parentItemBuilder(
                          context,
                          item,
                          isSelected,
                          hasSelectedItems,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // 右侧子项列表
              Expanded(
                child: Container(
                  color: theme.rightPanelColor ?? colorScheme.surfaceContainer,
                  child: selectedParentId == null
                      ? widget.emptyState ?? _defaultEmptyState()
                      : ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            // 右侧顶部"全部"选项（如果配置了）
                            _buildChildAllItem(selectedParentId),
                            // 子项列表
                            ...childItems.map((item) {
                              final isSelected =
                                  controller.selectedIds.contains(item.id);
                              return InkWell(
                                onTap: () => _handleItemTap(item),
                                child: widget.childItemBuilder(
                                  context,
                                  item,
                                  isSelected,
                                ),
                              );
                            }),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建一级"全部"选项
  Widget _buildParentAllItem() {
    final allItem = widget.parentAllItem!;
    final isSelected = controller.selectedParentId == allItem.id;

    return InkWell(
      onTap: () => controller.selectParent(allItem.id),
      child: widget.parentItemBuilder(
        context,
        allItem,
        isSelected,
        false,
      ),
    );
  }

  /// 构建二级"全部"选项
  Widget _buildChildAllItem(ID? selectedParentId) {
    if (selectedParentId == null) return const SizedBox.shrink();

    // 调用外部构建器获取二级"全部"选项数据
    final childAllItem = widget.childAllItemBuilder?.call(selectedParentId);
    if (childAllItem == null) return const SizedBox.shrink();

    // 检查是否是"全部"项（ID 等于父项 ID）
    // 如果是，则检查父项是否被选中
    final bool isSelected;
    if (childAllItem.id == selectedParentId) {
      // 这是"全部"项，选中状态取决于父项是否被选中
      isSelected = controller.selectedIds.contains(selectedParentId);
    } else {
      // 普通子项，检查自己是否被选中
      isSelected = controller.selectedIds.contains(childAllItem.id);
    }

    return InkWell(
      onTap: () => _handleItemTap(childAllItem),
      child: widget.childItemBuilder(
        context,
        childAllItem,
        isSelected,
      ),
    );
  }

  void _handleItemTap(T item) {
    if (item.id == itemAll) {
      widget.onConfirm?.call([item]);
      return;
    }
    // 单选模式下，选择后调用 onItemTap 返回结果
    if (widget.mode == SelectorMode.single) {
      widget.onConfirm?.call([item]);
      return;
    }

    final success = controller.toggleSelection(item.id);

    if (!success) {
      widget.onMaxLimitReached?.call();
      return;
    }
  }

  Widget _defaultEmptyState() {
    return Center(
      child: Text(
        theme.emptyStateText,
        style: theme.emptyStateTextStyle ??
            textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return controller.selectedIds.isNotEmpty
            ? _buildSelectedBottomBar()
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildSelectedBottomBar() {
    final selectedItems = controller.selectedItems;
    final selectedCount = selectedItems.length;

    return SelectedBottomBar<T, ID>(
      selectedCount: selectedCount,
      maxSelectedCount: widget.maxSelectedCount,
      selectedItemBuilder: widget.selectedItemBuilder,
      selectedItems: selectedItems,
      onRemove: (itemId) => controller.toggleSelection(itemId),
      onClear: () => controller.clearSelection(),
      onConfirm: () => widget.onConfirm!(selectedItems),
      bottomPadding: MediaQuery.paddingOf(context).bottom,
      topPadding: theme.bottomBarTopPadding,
    );
  }

  /// 获取选中的项目列表
  List<T> get selectedItems => controller.selectedItems;

  /// 获取选中的ID列表
  List<ID> get selectedIds => controller.selectedIds.toList();

  /// 获取选中的项目（单选模式）
  T? get selectedItem => controller.selectedItem;

  /// 获取当前选中的父项ID
  ID? get selectedParentId => controller.selectedParentId;

  /// 获取控制器（用于高级用法）
  TwoPaneSelectorController<T, ID> get controllerValue => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
