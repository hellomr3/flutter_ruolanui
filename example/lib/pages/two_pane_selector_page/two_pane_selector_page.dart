import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// 双栏选择器（含搜索）测试页面
/// 枚举所有可能的使用场景
class TwoPaneSelectorPage extends StatefulWidget {
  const TwoPaneSelectorPage({super.key});

  @override
  State<TwoPaneSelectorPage> createState() => _TwoPaneSelectorPageState();
}

class _TwoPaneSelectorPageState extends State<TwoPaneSelectorPage> {
  // ========== 单选状态 ==========
  String? _singleResult;
  String? _singleSelectedId;

  // ========== 多选状态 ==========
  List<String> _multiResult = [];
  List<String> _multiSelectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '双栏选择器'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 当前选中状态展示 ====================
          if (_singleResult != null || _multiResult.isNotEmpty) ...[
            _buildResultsCard(),
            const SizedBox(height: 24),
          ],

          // ==================== 单选 - 基础场景 ====================
          _buildSectionTitle('① 单选 · 基础与「全部」选项'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '1. 最基础单选',
            description: '无搜索 · 无「全部」选项',
            icon: Icons.radio_button_checked,
            onPressed: _demoSingleBasic,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '2. 单选 + 搜索',
            description: '在父项与子项中搜索',
            icon: Icons.search,
            onPressed: _demoSingleWithSearch,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '3. 单选 + 一级「全部」',
            description: '左侧顶部增加「全部」入口',
            icon: Icons.list_alt,
            onPressed: _demoSingleWithParentAll,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '4. 单选 + 二级「全部」',
            description: '右侧顶部增加「全部」入口',
            icon: Icons.fact_check_outlined,
            onPressed: _demoSingleWithChildAll,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '5. 单选 + 全量「全部」 + 搜索',
            description: '一级、二级「全部」 + 搜索 + 初始回显',
            icon: Icons.select_all,
            onPressed: _demoSingleFull,
          ),

          const SizedBox(height: 32),
          // ==================== 单选 - 自定义场景 ====================
          _buildSectionTitle('② 单选 · 自定义渲染与主题'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '6. 自定义主题',
            description: '面板宽度 / 高度 / 颜色 / 标题样式',
            icon: Icons.palette_outlined,
            onPressed: _demoSingleCustomTheme,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '7. 自定义搜索结果样式',
            description: '搜索时使用专属卡片渲染',
            icon: Icons.style_outlined,
            onPressed: _demoSingleCustomSearchResult,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '8. 自定义空状态',
            description: '左侧未选中时右侧的占位 UI',
            icon: Icons.hourglass_empty,
            onPressed: _demoSingleCustomEmpty,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '9. 自定义右上角操作按钮',
            description: '替换 actionButton 实现自定义入口',
            icon: Icons.add_circle_outline,
            onPressed: _demoSingleCustomAction,
          ),

          const SizedBox(height: 32),
          // ==================== 多选 - 基础场景 ====================
          _buildSectionTitle('③ 多选 · 基础与上限'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '10. 最基础多选',
            description: '无搜索 · 默认上限 5 · 默认 chip',
            icon: Icons.checklist_outlined,
            onPressed: _demoMultiBasic,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '11. 多选 + 搜索',
            description: '搜索状态下也支持多选',
            icon: Icons.manage_search,
            onPressed: _demoMultiWithSearch,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '12. 多选 + 数量限制（3）',
            description: '达到上限触发 onMaxLimitReached',
            icon: Icons.warning_amber_outlined,
            onPressed: _demoMultiWithLimit,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '13. 多选 + 全量「全部」 + 搜索 + 回显',
            description: '父子联动 · 不选即「全部」',
            icon: Icons.done_all,
            onPressed: _demoMultiFull,
          ),

          const SizedBox(height: 32),
          // ==================== 多选 - 自定义场景 ====================
          _buildSectionTitle('④ 多选 · 自定义渲染与主题'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '14. 自定义底部已选 chip',
            description: '使用 selectedItemBuilder 自定义样式',
            icon: Icons.label_outline,
            onPressed: _demoMultiCustomChip,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '15. 自定义主题（紧凑模式）',
            description: '更小高度 / 更宽左栏 / 自定义配色',
            icon: Icons.tune,
            onPressed: _demoMultiCustomTheme,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '16. 多选 + 自定义搜索结果',
            description: '搜索结果展示选中状态',
            icon: Icons.format_list_bulleted,
            onPressed: _demoMultiCustomSearchResult,
          ),

          const SizedBox(height: 32),
          // ==================== 工具按钮 ====================
          _buildSectionTitle('⑤ 工具'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '清除所有选中状态',
            description: '重置单选/多选回显',
            icon: Icons.refresh,
            onPressed: _resetAll,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildResultsCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                '当前选中',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          if (_singleResult != null) ...[
            const SizedBox(height: 8),
            Text('单选：$_singleResult'),
          ],
          if (_multiResult.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('多选：${_multiResult.join("、")}'),
          ],
        ],
      ),
    );
  }

  void _resetAll() {
    setState(() {
      _singleResult = null;
      _singleSelectedId = null;
      _multiResult = [];
      _multiSelectedIds = [];
    });
  }

  // ============================================================
  //                  结果处理（统一入口）
  // ============================================================
  // 注：setState 仅能在 State 子类中使用，这里集中处理。

  void _handleSingleResult(Result<_FoodItem> result) {
    result
        .onSuccess((item) {
          setState(() {
            _singleResult = item?.name ?? '全部';
            _singleSelectedId = item?.id;
          });
        })
        .onError((msg, _) {
          // 取消选择，保持原状态
        });
  }

  void _handleMultiResult(Result<List<_CityItem>> result) {
    result
        .onSuccess((selected) {
          final safeSelected = selected ?? <_CityItem>[];
          setState(() {
            if (safeSelected.isEmpty) {
              _multiResult = ['全部'];
              _multiSelectedIds = [];
            } else {
              _multiResult = safeSelected.map((e) => e.name).toList();
              _multiSelectedIds = safeSelected.map((e) => e.id).toList();
            }
          });
        })
        .onError((msg, _) {
          // 取消选择，保持原状态
        });
  }
}

// ============================================================
//                       单选 Demo 实现
// ============================================================
extension _SingleDemos on _TwoPaneSelectorPageState {
  // 1. 最基础单选 —— 无搜索、无任何「全部」
  void _demoSingleBasic() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '基础单选',
      items: _buildFoodData(),
      initialSelectedId: _singleSelectedId,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 2. 单选 + 搜索
  void _demoSingleWithSearch() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '单选 + 搜索',
      items: _buildFoodData(),
      searchable: true,
      searchHint: '搜索食品名称',
      initialSelectedId: _singleSelectedId,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 3. 单选 + 仅一级「全部」
  void _demoSingleWithParentAll() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '单选 · 一级全部',
      items: _buildFoodData(),
      initialSelectedId: _singleSelectedId,
      parentAllItem: _FoodItem(id: itemAll, name: '全部'),
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 4. 单选 + 仅二级「全部」
  void _demoSingleWithChildAll() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '单选 · 二级全部',
      items: _buildFoodData(),
      initialSelectedId: _singleSelectedId,
      childAllItemBuilder: (String? pid) {
        if (pid == null) return null;
        return _FoodItem(id: pid, name: '全部', pid: pid);
      },
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 5. 单选 + 一级 + 二级「全部」 + 搜索 + 初始回显
  void _demoSingleFull() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '单选 · 完整功能',
      items: _buildFoodData(),
      searchable: true,
      searchHint: '输入关键字过滤',
      initialSelectedId: _singleSelectedId,
      parentAllItem: _FoodItem(id: itemAll, name: '全部'),
      childAllItemBuilder: (String? pid) {
        if (pid == null) return null;
        return _FoodItem(id: pid, name: '全部', pid: pid);
      },
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
      searchResultItemBuilder: _buildSearchResultTile,
    ).then(_handleSingleResult);
  }

  // 6. 单选 + 自定义主题
  void _demoSingleCustomTheme() {
    final base = TwoPaneSelectorTheme.of(context);
    final theme = base.copyWith(
      containerHeightFactor: 0.75,
      leftPanelWidthFactor: 0.38,
      leftPanelColor: const Color(0xFFF7F8FA),
      rightPanelColor: Colors.white,
      titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
      headerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      backIconSize: 22,
      emptyStateText: '左侧选个分类先 ~',
    );

    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '单选 · 自定义主题',
      items: _buildFoodData(),
      theme: theme,
      searchable: true,
      initialSelectedId: _singleSelectedId,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 7. 单选 + 自定义搜索结果样式
  void _demoSingleCustomSearchResult() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '自定义搜索结果',
      items: _buildFoodData(),
      searchable: true,
      searchHint: '试试搜索「鸡」「果」',
      initialSelectedId: _singleSelectedId,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
      searchResultItemBuilder: (context, item, isSelected) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 1.2 : 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.label_outline,
                size: 18,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, size: 18, color: colorScheme.primary),
            ],
          ),
        );
      },
    ).then(_handleSingleResult);
  }

  // 8. 单选 + 自定义空状态
  void _demoSingleCustomEmpty() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '自定义空状态',
      items: _buildFoodData(),
      initialSelectedId: null,
      emptyState: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              '请先在左侧选择一个分类',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }

  // 9. 单选 + 自定义右上角操作按钮
  void _demoSingleCustomAction() {
    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '自定义操作按钮',
      items: _buildFoodData(),
      initialSelectedId: _singleSelectedId,
      actionButton: TextButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('点击了右上角的「新增」按钮')),
          );
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('新增'),
      ),
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleSingleResult);
  }
}
// ============================================================
//                       多选 Demo 实现
// ============================================================
extension _MultiDemos on _TwoPaneSelectorPageState {
  // 10. 最基础多选
  void _demoMultiBasic() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '基础多选',
      items: _buildCityData(),
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleMultiResult);
  }

  // 11. 多选 + 搜索
  void _demoMultiWithSearch() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '多选 + 搜索',
      items: _buildCityData(),
      searchable: true,
      searchHint: '搜索城市',
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleMultiResult);
  }

  // 12. 多选 + 数量限制
  void _demoMultiWithLimit() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '多选 · 最多 3 个',
      items: _buildCityData(),
      maxSelectedCount: 3,
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      onMaxLimitReached: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('最多只能选择 3 个城市'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleMultiResult);
  }

  // 13. 多选完整：一级、二级「全部」 + 搜索 + 回显 + 上限
  void _demoMultiFull() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '多选 · 完整功能',
      items: _buildCityData(),
      searchable: true,
      searchHint: '搜索城市名',
      maxSelectedCount: 5,
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentAllItem: _CityItem(id: itemAll, name: '全部'),
      childAllItemBuilder: (String? pid) {
        if (pid == null) return null;
        return _CityItem(id: pid, name: '全部', pid: pid);
      },
      onMaxLimitReached: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已达到选择上限（5 个）')),
        );
      },
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
      searchResultItemBuilder: _buildSearchResultTile,
    ).then(_handleMultiResult);
  }

  // 14. 多选 + 自定义底部已选 chip
  void _demoMultiCustomChip() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '多选 · 自定义 Chip',
      items: _buildCityData(),
      searchable: true,
      maxSelectedCount: 6,
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
      selectedItemBuilder: (context, item, onRemove) {
        final colorScheme = Theme.of(context).colorScheme;
        return GestureDetector(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  item.name,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.cancel,
                  size: 14,
                  color: colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        );
      },
    ).then(_handleMultiResult);
  }

  // 15. 多选 + 自定义主题
  void _demoMultiCustomTheme() {
    final base = TwoPaneSelectorTheme.of(context);
    final theme = base.copyWith(
      containerHeightFactor: 0.55,
      leftPanelWidthFactor: 0.32,
      containerBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      leftPanelColor: const Color(0xFFEFF3F8),
      rightPanelColor: Colors.white,
      headerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      bottomBarTopPadding: 8,
    );

    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '紧凑主题',
      items: _buildCityData(),
      theme: theme,
      maxSelectedCount: 4,
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
    ).then(_handleMultiResult);
  }

  // 16. 多选 + 自定义搜索结果项
  void _demoMultiCustomSearchResult() {
    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '搜索结果带选中态',
      items: _buildCityData(),
      searchable: true,
      maxSelectedCount: 8,
      initialSelectedIds:
          _multiSelectedIds.isNotEmpty ? _multiSelectedIds : null,
      parentItemBuilder: _buildParentTile,
      childItemBuilder: _buildChildTile,
      searchResultItemBuilder: (context, item, isSelected) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.06)
                : null,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 1.4,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then(_handleMultiResult);
  }
}

// ============================================================
//                  共享 Builder（父项 / 子项 / 搜索）
// ============================================================
//
// 注：由于 Dart 函数参数的逆变规则（Function(Super) 可赋值给 Function(Sub)），
// 这些通用 Builder 的入参用 SelectorItem<String>，可以直接以 tear-off 形式
// 传给 SelectorDialog.showSingle<_FoodItem, ...> / showMultiple<_CityItem, ...>。
extension _SharedBuilders on _TwoPaneSelectorPageState {
  Widget _buildParentTile(
    BuildContext context,
    SelectorItem<String> item,
    bool isSelected,
    bool hasSelectedItems,
  ) {
    return _ParentTile(
      name: item.name,
      isSelected: isSelected,
      hasSelectedItems: hasSelectedItems,
    );
  }

  Widget _buildChildTile(
    BuildContext context,
    SelectorItem<String> item,
    bool isSelected,
  ) {
    return _ChildTile(name: item.name, isSelected: isSelected);
  }

  Widget _buildSearchResultTile(
    BuildContext context,
    SelectorItem<String> item,
    bool isSelected,
  ) {
    return _SearchResultTile(name: item.name, isSelected: isSelected);
  }
}

// ============================================================
//                          测试数据
// ============================================================
extension _DataBuilders on _TwoPaneSelectorPageState {
  /// 食品分类数据（用于单选演示）
  List<_FoodItem> _buildFoodData() {
    return [
      // 水果
      _FoodItem(id: 'fruit', name: '水果'),
      _FoodItem(id: 'apple', name: '苹果', pid: 'fruit'),
      _FoodItem(id: 'banana', name: '香蕉', pid: 'fruit'),
      _FoodItem(id: 'orange', name: '橙子', pid: 'fruit'),
      _FoodItem(id: 'grape', name: '葡萄', pid: 'fruit'),
      _FoodItem(id: 'watermelon', name: '西瓜', pid: 'fruit'),
      _FoodItem(id: 'strawberry', name: '草莓', pid: 'fruit'),
      _FoodItem(id: 'mango', name: '芒果', pid: 'fruit'),
      // 蔬菜
      _FoodItem(id: 'vegetable', name: '蔬菜'),
      _FoodItem(id: 'tomato', name: '番茄', pid: 'vegetable'),
      _FoodItem(id: 'potato', name: '土豆', pid: 'vegetable'),
      _FoodItem(id: 'carrot', name: '胡萝卜', pid: 'vegetable'),
      _FoodItem(id: 'cabbage', name: '白菜', pid: 'vegetable'),
      _FoodItem(id: 'spinach', name: '菠菜', pid: 'vegetable'),
      _FoodItem(id: 'cucumber', name: '黄瓜', pid: 'vegetable'),
      // 肉类
      _FoodItem(id: 'meat', name: '肉类'),
      _FoodItem(id: 'pork', name: '猪肉', pid: 'meat'),
      _FoodItem(id: 'beef', name: '牛肉', pid: 'meat'),
      _FoodItem(id: 'chicken', name: '鸡肉', pid: 'meat'),
      _FoodItem(id: 'lamb', name: '羊肉', pid: 'meat'),
      _FoodItem(id: 'fish', name: '鱼肉', pid: 'meat'),
      // 饮品
      _FoodItem(id: 'drink', name: '饮品'),
      _FoodItem(id: 'coffee', name: '咖啡', pid: 'drink'),
      _FoodItem(id: 'tea', name: '茶', pid: 'drink'),
      _FoodItem(id: 'juice', name: '果汁', pid: 'drink'),
      _FoodItem(id: 'milk', name: '牛奶', pid: 'drink'),
      _FoodItem(id: 'soda', name: '汽水', pid: 'drink'),
      // 零食
      _FoodItem(id: 'snack', name: '零食'),
      _FoodItem(id: 'chips', name: '薯片', pid: 'snack'),
      _FoodItem(id: 'chocolate', name: '巧克力', pid: 'snack'),
      _FoodItem(id: 'cookie', name: '饼干', pid: 'snack'),
      _FoodItem(id: 'candy', name: '糖果', pid: 'snack'),
      _FoodItem(id: 'nuts', name: '坚果', pid: 'snack'),
    ];
  }

  /// 城市数据（用于多选演示）
  List<_CityItem> _buildCityData() {
    return [
      _CityItem(id: 'east', name: '华东地区'),
      _CityItem(id: 'shanghai', name: '上海', pid: 'east'),
      _CityItem(id: 'hangzhou', name: '杭州', pid: 'east'),
      _CityItem(id: 'nanjing', name: '南京', pid: 'east'),
      _CityItem(id: 'suzhou', name: '苏州', pid: 'east'),
      _CityItem(id: 'hefei', name: '合肥', pid: 'east'),
      _CityItem(id: 'north', name: '华北地区'),
      _CityItem(id: 'beijing', name: '北京', pid: 'north'),
      _CityItem(id: 'tianjin', name: '天津', pid: 'north'),
      _CityItem(id: 'shijiazhuang', name: '石家庄', pid: 'north'),
      _CityItem(id: 'taiyuan', name: '太原', pid: 'north'),
      _CityItem(id: 'south', name: '华南地区'),
      _CityItem(id: 'guangzhou', name: '广州', pid: 'south'),
      _CityItem(id: 'shenzhen', name: '深圳', pid: 'south'),
      _CityItem(id: 'zhuhai', name: '珠海', pid: 'south'),
      _CityItem(id: 'dongguan', name: '东莞', pid: 'south'),
      _CityItem(id: 'west', name: '西部地区'),
      _CityItem(id: 'chengdu', name: '成都', pid: 'west'),
      _CityItem(id: 'chongqing', name: '重庆', pid: 'west'),
      _CityItem(id: 'xian', name: '西安', pid: 'west'),
      _CityItem(id: 'kunming', name: '昆明', pid: 'west'),
    ];
  }
}

// ============================================================
//                          数据模型
// ============================================================
class _FoodItem implements SelectorItem<String> {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? pid;

  _FoodItem({required this.id, required this.name, this.pid});
}

class _CityItem implements SelectorItem<String> {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? pid;

  _CityItem({required this.id, required this.name, this.pid});
}

// ============================================================
//                          通用 UI
// ============================================================

/// 左侧父项 Tile
class _ParentTile extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool hasSelectedItems;

  const _ParentTile({
    required this.name,
    required this.isSelected,
    required this.hasSelectedItems,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        border: Border(
          left: BorderSide(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ),
          if (hasSelectedItems)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

/// 右侧子项 Tile
class _ChildTile extends StatelessWidget {
  final String name;
  final bool isSelected;

  const _ChildTile({
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 默认搜索结果项 Tile
class _SearchResultTile extends StatelessWidget {
  final String name;
  final bool isSelected;

  const _SearchResultTile({
    required this.name,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
            : null,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}

/// Demo 按钮卡片
class _DemoButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const _DemoButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurfaceVariant,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
