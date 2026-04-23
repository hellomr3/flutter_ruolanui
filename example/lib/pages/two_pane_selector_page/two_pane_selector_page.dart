import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// 双栏选择器（含搜索）测试页面
class TwoPaneSelectorPage extends StatefulWidget {
  const TwoPaneSelectorPage({super.key});

  @override
  State<TwoPaneSelectorPage> createState() => _TwoPaneSelectorPageState();
}

class _TwoPaneSelectorPageState extends State<TwoPaneSelectorPage> {
  String? _singleResult;
  String? _singleSelectedId;
  List<String> _multiResult = [];
  List<String> _multiSelectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '双栏选择器（搜索）'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('单选模式'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '单选 + 搜索',
            description: '带搜索框的单选分类选择器',
            icon: Icons.search,
            onPressed: _showSingleWithSearch,
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: '单选 + 搜索 + 全部',
            description: '带一级/二级"全部"选项',
            icon: Icons.select_all,
            onPressed: _showSingleWithSearchAndAll,
          ),
          if (_singleResult != null) ...[
            const SizedBox(height: 12),
            _ResultCard(text: '单选结果: $_singleResult'),
          ],
          const SizedBox(height: 32),
          _buildSectionTitle('多选模式'),
          const SizedBox(height: 12),
          _DemoButton(
            label: '多选 + 搜索',
            description: '带搜索框的多选城市选择器',
            icon: Icons.checklist,
            onPressed: _showMultiWithSearch,
          ),
          if (_multiResult.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ResultCard(text: '多选结果: ${_multiResult.join(", ")}'),
          ],
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

  // ==================== 单选 + 搜索 ====================

  void _showSingleWithSearch() {
    final items = _buildFoodData();

    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '选择食品',
      items: items,
      searchable: true,
      searchHint: '搜索食品名称',
      initialSelectedId: _singleSelectedId,
      childAllItemBuilder: (String? pid) {
        if (pid == null) return null;
        return _FoodItem(id: pid, name: '全部', pid: pid);
      },
      parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
        return _ParentTile(
          name: item.name,
          isSelected: isSelected,
          hasSelectedItems: hasSelectedItems,
        );
      },
      childItemBuilder: (context, item, isSelected) {
        return _ChildTile(name: item.name, isSelected: isSelected);
      },
      searchResultItemBuilder: (context, item, isSelected) {
        return _SearchResultTile(name: item.name, isSelected: isSelected);
      },
    ).then((result) {
      result.onSuccess((item) {
        setState(() {
          _singleResult = item?.name ?? '全部';
          _singleSelectedId = item?.id;
        });
      });
    });
  }

  // ==================== 单选 + 搜索 + 全部 ====================

  void _showSingleWithSearchAndAll() {
    final items = _buildFoodData();

    SelectorDialog.showSingle<_FoodItem, String>(
      context: context,
      title: '选择食品',
      items: items,
      searchable: true,
      searchHint: '输入关键词过滤',
      initialSelectedId: _singleSelectedId,
      parentAllItem: _FoodItem(id: itemAll, name: '全部'),
      childAllItemBuilder: (String? pid) {
        if (pid == null) return null;
        return _FoodItem(id: pid, name: '全部', pid: pid);
      },
      parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
        return _ParentTile(
          name: item.name,
          isSelected: isSelected,
          hasSelectedItems: hasSelectedItems,
        );
      },
      childItemBuilder: (context, item, isSelected) {
        return _ChildTile(name: item.name, isSelected: isSelected);
      },
      searchResultItemBuilder: (context, item, isSelected) {
        return _SearchResultTile(name: item.name, isSelected: isSelected);
      },
    ).then((result) {
      result.onSuccess((item) {
        setState(() {
          _singleResult = item?.name ?? '全部';
          _singleSelectedId = item?.id;
        });
      });
    });
  }

  // ==================== 多选 + 搜索 ====================

  void _showMultiWithSearch() {
    final items = _buildCityData();

    SelectorDialog.showMultiple<_CityItem, String>(
      context: context,
      title: '选择城市',
      items: items,
      searchable: true,
      searchHint: '搜索城市名称',
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
          const SnackBar(content: Text('已达到选择上限（5个）')),
        );
      },
      parentItemBuilder: (context, item, isSelected, hasSelectedItems) {
        return _ParentTile(
          name: item.name,
          isSelected: isSelected,
          hasSelectedItems: hasSelectedItems,
        );
      },
      childItemBuilder: (context, item, isSelected) {
        return _ChildTile(name: item.name, isSelected: isSelected);
      },
      searchResultItemBuilder: (context, item, isSelected) {
        return _SearchResultTile(name: item.name, isSelected: isSelected);
      },
    ).then((result) {
      result.onSuccess((selected) {
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
      });
    });
  }

  // ==================== 测试数据 ====================

  /// 食品数据（数据量较多，方便测试搜索过滤效果）
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

  /// 城市数据
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

// ==================== 数据模型 ====================

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

// ==================== 通用 UI 组件 ====================

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

/// 搜索结果项 Tile（纯文本样式，不带前置选中图标）
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

/// Demo 按钮
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
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(width: 16),
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
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// 结果展示卡片
class _ResultCard extends StatelessWidget {
  final String text;

  const _ResultCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
