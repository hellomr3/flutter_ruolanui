import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';
import 'package:styled_widget/styled_widget.dart';

/// 选择模式
enum SelectorMode { single, multiple }

/// 通用的双栏选择器组件
/// [T] 数据类型
/// [ID] ID类型
class TwoPaneSelector<T, ID> extends StatefulWidget {
  /// 标题
  final String title;

  /// 数据ID提取器
  final ID Function(T item) idExtractor;

  /// 父ID提取器
  final ID? Function(T item) parentIdExtractor;

  /// 选择模式
  final SelectorMode mode;

  /// 初始选中的父项ID
  final ID? initialParentId;

  /// 初始选中的项目ID列表
  final List<ID>? initialSelectedIds;

  /// 数据列表
  final List<T> items;

  /// 左侧父项构建器
  final Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
    bool hasSelectedItems,
    VoidCallback onTap,
  ) parentItemBuilder;

  /// 右侧子项构建器
  final Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
    VoidCallback onTap,
  ) childItemBuilder;

  /// 已选项目构建器（用于底部展示栏）
  final Widget Function(
    BuildContext context,
    T item,
    VoidCallback onRemove,
  ) selectedItemBuilder;

  /// 空状态提示
  final Widget? emptyState;

  /// 右上角自定义操作按钮（会覆盖默认的确认按钮）
  final Widget? actionButton;

  /// 确认按钮点击回调（多选模式）
  final void Function(List<T> selectedItems)? onConfirm;

  /// 返回按钮点击回调
  final VoidCallback? onBack;

  /// 子项点击回调（单选模式，返回选中的项目）
  final void Function(T? selectedItem)? onItemTap;

  /// 主题配置
  final TwoPaneSelectorTheme? theme;

  /// 是否显示"全部"选项（多选模式下，在右侧列表顶部显示）
  final bool showSelectAll;

  /// "全部"选项的文字
  final String selectAllText;

  /// "全部"选项的构建器
  final Widget Function(
    BuildContext context,
    bool isSelected,
    VoidCallback onTap,
  )? selectAllBuilder;

  /// 子项点击覆盖回调（返回 true 表示阻止默认行为）
  /// 可用于特殊项目的自定义处理，例如虚拟"全部"项
  final bool Function(T item)? onItemTapOverride;

  /// 子项选中状态覆盖回调（可用于自定义选中状态显示）
  /// 接收项目和默认选中状态，返回实际是否应该显示为选中
  final bool Function(T item, bool defaultIsSelected)? isSelectedOverride;

  const TwoPaneSelector({
    super.key,
    required this.title,
    required this.idExtractor,
    required this.parentIdExtractor,
    required this.mode,
    required this.items,
    required this.parentItemBuilder,
    required this.childItemBuilder,
    required this.selectedItemBuilder,
    this.initialParentId,
    this.initialSelectedIds,
    this.emptyState,
    this.actionButton,
    this.onConfirm,
    this.onBack,
    this.onItemTap,
    this.theme,
    this.showSelectAll = false,
    this.selectAllText = "全部",
    this.selectAllBuilder,
    this.onItemTapOverride,
    this.isSelectedOverride,
  });

  @override
  State<TwoPaneSelector<T, ID>> createState() => TwoPaneSelectorState<T, ID>();
}

/// TwoPaneSelector 的状态类，公开以支持外部访问 ViewModel
class TwoPaneSelectorState<T, ID> extends State<TwoPaneSelector<T, ID>> {
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
      idExtractor: widget.idExtractor,
      parentIdExtractor: widget.parentIdExtractor,
    );
    controller.init(
      widget.items,
      initialParentId: widget.initialParentId,
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
          _buildBottomBar(),
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
              if (widget.actionButton != null)
                widget.actionButton!
              else if (widget.onConfirm != null)
                PrimaryBtn(
                  label: theme.confirmButtonText,
                  height: theme.confirmButtonHeight,
                  borderRadius: theme.confirmButtonBorderRadius,
                  onPressed: () => widget.onConfirm!(controller.selectedItems),
                ),
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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: parentItems.length,
                  itemBuilder: (context, index) {
                    final item = parentItems[index];
                    final itemId = widget.idExtractor(item);
                    final isSelected = selectedParentId == itemId;
                    final hasSelectedItems =
                        controller.hasSelectedChildren(item);

                    return widget.parentItemBuilder(
                      context,
                      item,
                      isSelected,
                      hasSelectedItems,
                      () => controller.selectParent(itemId),
                    );
                  },
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
                            // "全部"选项（仅在多选模式且 showSelectAll 为 true 时显示）
                            if (widget.showSelectAll &&
                                widget.mode == SelectorMode.multiple)
                              _buildSelectAll(selectedParentId),
                            // 子项列表
                            ...childItems.map((item) {
                              final itemId = widget.idExtractor(item);
                              final defaultIsSelected =
                                  controller.selectedIds.contains(itemId);
                              final isSelected =
                                  widget.isSelectedOverride != null
                                      ? widget.isSelectedOverride!(
                                          item, defaultIsSelected)
                                      : defaultIsSelected;
                              return widget.childItemBuilder(
                                context,
                                item,
                                isSelected,
                                () => _handleItemTap(item),
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

  /// "全部"选项的构建器
  Widget _buildSelectAll(ID? selectedParentId) {
    final allSelected = controller.areAllChildrenSelected(selectedParentId);
    return widget.selectAllBuilder != null
        ? widget.selectAllBuilder!(
            context,
            allSelected,
            () => controller.toggleAllChildren(selectedParentId),
          )
        : _buildDefaultSelectAll(allSelected);
  }

  /// 默认的"全部"选项构建器
  Widget _buildDefaultSelectAll(bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            widget.selectAllText,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: colorScheme.primary,
              size: 20,
            ),
        ],
      ),
    );
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
        return widget.mode == SelectorMode.multiple &&
                controller.selectedIds.isNotEmpty
            ? _buildSelectedBottomBar()
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildSelectedBottomBar() {
    final selectedItems = controller.selectedItems;

    return Container(
      color: theme.containerColor ?? colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: selectedItems.map((item) {
              return widget.selectedItemBuilder(
                context,
                item,
                () => controller.toggleSelection(widget.idExtractor(item)),
              );
            }).toList(),
          ),
        ),
      ),
    ).paddingDirectional(
      bottom: MediaQuery.paddingOf(context).bottom,
      top: theme.bottomBarTopPadding,
    );
  }

  void _handleItemTap(T item) {
    // 如果有自定义点击处理，且返回 true，则阻止默认行为
    if (widget.onItemTapOverride?.call(item) == true) {
      return;
    }

    final itemId = widget.idExtractor(item);
    controller.toggleSelection(itemId);

    // 单选模式下，选择后立即通知调用者
    if (widget.mode == SelectorMode.single) {
      final selectedItem = controller.selectedItem;
      widget.onItemTap?.call(selectedItem);
    }
  }

  /// 获取选中的项目列表
  List<T> get selectedItems => controller.selectedItems;

  /// 获取选中的ID列表
  List<ID> get selectedIds => controller.selectedIds.toList();

  /// 获取选中的项目（单选模式）
  T? get selectedItem => controller.selectedItem;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
