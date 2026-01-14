import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// RuolanUI 组件示例页面
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _textFieldController = TextEditingController();
  final _clearInputController = TextEditingController();
  String? _selectedOption;
  String? _selectedCategory;
  final Set<String> _selectedItems = {};

  @override
  void dispose() {
    _textFieldController.dispose();
    _clearInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'RuolanUI 组件示例',
      ),
      body: KeyboardDismiss(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('按钮组件'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                PrimaryBtn(
                  label: '主要按钮',
                  onPressed: () => _showSnackbar('点击了主要按钮'),
                ),
                NormalBtn(
                  label: '普通按钮',
                  onPressed: () => _showSnackbar('点击了普通按钮'),
                ),
                ErrorBtn(
                  label: '错误按钮',
                  onPressed: () => _showSnackbar('点击了错误按钮'),
                ),
                TextBtn(
                  label: '文本按钮',
                  onPressed: () => _showSnackbar('点击了文本按钮'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('输入框组件'),
            const SizedBox(height: 12),
            AppTextField(
              controller: _textFieldController,
              hintText: '普通输入框',
              icon: Icons.search,
              onChange: (_) {},
            ),
            const SizedBox(height: 12),
            ClearInputTextField(
              controller: _clearInputController,
              hintText: '带清除按钮的输入框',
              icon: Icons.person,
              onChange: (_) {},
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('对话框组件'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                PrimaryBtn(
                  label: '确认对话框',
                  onPressed: _showConfirmDialog,
                ),
                NormalBtn(
                  label: '选项对话框',
                  onPressed: _showOptionsDialog,
                ),
                ErrorBtn(
                  label: '输入对话框',
                  onPressed: _showInputDialog,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('选择器组件'),
            const SizedBox(height: 12),
            _buildSelectorSection(),
            const SizedBox(height: 32),
            _buildSectionTitle('多行文本编辑器'),
            const SizedBox(height: 12),
            _buildEditorSection(),
            const SizedBox(height: 32),
            _buildSectionTitle('条件构建器'),
            const SizedBox(height: 12),
            ConditionalBuilder(
              condition: _selectedOption != null,
              trueBuilder: (context) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '条件满足时显示的内容: $_selectedOption',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              falseBuilder: (context) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '条件不满足时显示的内容',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSelectorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SelectorButton(
          label: '单选选择器',
          description: '选择单个项目',
          icon: Icons.radio_button_checked,
          onPressed: _showSingleSelector,
        ),
        const SizedBox(height: 12),
        _SelectorButton(
          label: '多选选择器',
          description: '选择多个项目',
          icon: Icons.check_box,
          onPressed: _showMultipleSelector,
        ),
        const SizedBox(height: 12),
        _SelectorButton(
          label: '带全选多选',
          description: '支持全选功能',
          icon: Icons.select_all,
          onPressed: _showSelectorWithSelectAll,
        ),
        const SizedBox(height: 12),
        _SelectorButton(
          label: '自定义主题',
          description: '自定义选择器样式',
          icon: Icons.palette,
          onPressed: _showSelectorWithTheme,
        ),
        if (_selectedItems.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '已选择: ${_selectedItems.join(", ")}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EditorButton(
          label: '基本编辑器',
          description: '支持有序列表和无序列表',
          onPressed: _openBasicEditor,
        ),
        const SizedBox(height: 12),
        _EditorButton(
          label: '带副标题',
          description: '显示副标题信息',
          onPressed: _openEditorWithSubtitle,
        ),
        const SizedBox(height: 12),
        _EditorButton(
          label: '字数限制',
          description: '最大输入 100 字',
          onPressed: _openEditorWithLimit,
        ),
        const SizedBox(height: 12),
        _EditorButton(
          label: '自定义主题',
          description: '使用深色主题',
          onPressed: _openEditorWithCustomTheme,
        ),
        const SizedBox(height: 12),
        _EditorButton(
          label: '完整示例',
          description: '带副标题 + 字数限制 + 自定义主题',
          onPressed: _openFullEditor,
        ),
      ],
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: '确认操作',
        content: '您确定要执行此操作吗？',
        confirmText: '确定',
        cancelText: '取消',
        onConfirm: () => _showSnackbar('已确认操作'),
        onCancel: () => _showSnackbar('已取消操作'),
      ),
    );
  }

  void _showOptionsDialog() {
    final options = ['选项一', '选项二', '选项三'];
    int? currentIndex = options.indexOf(_selectedOption ?? '');
    if (currentIndex == -1) currentIndex = null;

    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionsContent(
        value: currentIndex,
        options: options,
        cancelText: '取消',
        dismiss: (index) {
          if (index != null) {
            setState(() => _selectedOption = options[index]);
            _showSnackbar('选择了: ${options[index]}');
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showInputDialog() {
    showBottomInputDialog(
      context,
      title: '请输入内容',
      hintText: '输入一些文字...',
      initialValue: _selectedOption ?? '',
    ).then((result) {
      result.onSuccess(
        (value) {
          setState(() => _selectedOption = value);
          _showSnackbar('输入成功: $value');
        },
      );
    });
  }

  /// 单选选择器
  void _showSingleSelector() {
    final items = _buildCategoryData();

    SelectorDialog.showSingle<CategoryItem, String>(
      context: context,
      title: '选择分类',
      items: items,
      idExtractor: (item) => item.id,
      parentIdExtractor: (item) => item.parentId,
      initialSelectedId: _selectedCategory,
      parentItemBuilder: (context, item, isSelected, hasSelectedItems, onTap) {
        final theme = Theme.of(context);
        return ListTile(
          leading: Icon(
            isSelected ? Icons.folder_open : Icons.folder,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          title: Text(
            item.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? theme.colorScheme.primary : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
          onTap: onTap,
        );
      },
      childItemBuilder: (context, item, isSelected, onTap) {
        final theme = Theme.of(context);
        return ListTile(
          leading: Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          title: Text(
            item.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
          onTap: onTap,
        );
      },
      selectedItemBuilder: (context, item, onRemove) {
        return Chip(
          label: Text(item.name),
          onDeleted: onRemove,
          avatar: const Icon(Icons.check_circle, size: 18),
        );
      },
    ).then((selected) {
      if (selected != null) {
        setState(() => _selectedCategory = selected.id);
        _showSnackbar('选择了: ${selected.name}');
      }
    });
  }

  /// 多选选择器
  void _showMultipleSelector() {
    final items = _buildProductData();

    SelectorDialog.showMultiple<ProductItem, String>(
      context: context,
      title: '选择产品',
      items: items,
      idExtractor: (item) => item.id,
      parentIdExtractor: (item) => item.categoryId,
      parentItemBuilder: (context, item, isSelected, hasSelectedItems, onTap) {
        final theme = Theme.of(context);
        return ListTile(
          leading: Badge(
            label: Text(item.childCount.toString()),
            child: Icon(
              Icons.category,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
          title: Text(
            item.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        );
      },
      childItemBuilder: (context, item, isSelected, onTap) {
        final theme = Theme.of(context);
        return CheckboxListTile(
          value: isSelected,
          onChanged: (_) => onTap(),
          title: Text(item.name),
          subtitle: Text('¥${item.price.toStringAsFixed(2)}'),
          secondary: Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
        );
      },
      selectedItemBuilder: (context, item, onRemove) {
        return Chip(
          label: Text(item.name),
          onDeleted: onRemove,
        );
      },
    ).then((selected) {
      if (selected.isNotEmpty) {
        setState(() => _selectedItems.clear());
        setState(() => _selectedItems.addAll(selected.map((e) => e.name)));
        _showSnackbar('已选择 ${selected.length} 个产品');
      }
    });
  }

  /// 带全选的多选选择器
  void _showSelectorWithSelectAll() {
    final items = _buildCityData();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('选择城市'),
          ),
          body: TwoPaneSelector<CityItem, String>(
            title: '选择城市',
            mode: SelectorMode.multiple,
            items: items,
            idExtractor: (item) => item.id,
            parentIdExtractor: (item) => item.parentId,
            selectAllText: '全部',
            parentItemBuilder:
                (context, item, isSelected, hasSelectedItems, onTap) {
              final theme = Theme.of(context);
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.location_city
                      : Icons.location_city_outlined,
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
                title: Text(
                  item.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: onTap,
              );
            },
            childItemBuilder: (context, item, isSelected, onTap) {
              final theme = Theme.of(context);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => onTap(),
                title: Text(item.name),
                secondary: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
              );
            },
            selectedItemBuilder: (context, item, onRemove) {
              return Chip(
                label: Text(item.name),
                onDeleted: onRemove,
              );
            },
            onBack: () => Navigator.pop(context),
            onConfirm: (selected) {
              setState(() => _selectedItems.clear());
              setState(
                  () => _selectedItems.addAll(selected.map((e) => e.name)));
              Navigator.pop(context);
              _showSnackbar('已选择 ${selected.length} 个城市');
            },
          ),
        ),
      ),
    );
  }

  /// 自定义主题的选择器
  void _showSelectorWithTheme() {
    final items = _buildCategoryData();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('自定义主题'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: TwoPaneSelector<CategoryItem, String>(
            title: '选择分类',
            mode: SelectorMode.single,
            items: items,
            idExtractor: (item) => item.id,
            parentIdExtractor: (item) => item.parentId,
            // theme: TwoPaneSelectorTheme(
            //   backgroundColor: const Color(0xFFF5F5F5),
            //   surfaceColor: Colors.white,
            //   primaryColor: Colors.deepPurple,
            //   onPrimaryColor: Colors.white,
            //   dividerColor: const Color(0xFFE0E0E0),
            //   selectedBackgroundColor: const Color(0xFFEDE7F6),
            // ),
            parentItemBuilder:
                (context, item, isSelected, hasSelectedItems, onTap) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEDE7F6) : null,
                    border: Border(
                      left: BorderSide(
                        color:
                            isSelected ? Colors.deepPurple : Colors.transparent,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder,
                        color: isSelected ? Colors.deepPurple : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected ? Colors.deepPurple : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childItemBuilder: (context, item, isSelected, onTap) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.deepPurple : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.deepPurple : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            selectedItemBuilder: (context, item, onRemove) {
              return Chip(
                label: Text(item.name),
                backgroundColor: Colors.deepPurple,
                labelStyle: const TextStyle(color: Colors.white),
                deleteIconColor: Colors.white,
                onDeleted: onRemove,
              );
            },
            onBack: () => Navigator.pop(context),
            onItemTap: (selected) {
              if (selected != null) {
                setState(() => _selectedCategory = selected.id);
                Navigator.pop(context);
                _showSnackbar('选择了: ${selected.name}');
              }
            },
          ),
        ),
      ),
    );
  }

  /// 构建分类数据
  List<CategoryItem> _buildCategoryData() {
    return [
      CategoryItem(id: 'electronics', name: '电子产品', parentId: null),
      CategoryItem(id: 'phone', name: '手机', parentId: 'electronics'),
      CategoryItem(id: 'laptop', name: '笔记本', parentId: 'electronics'),
      CategoryItem(id: 'tablet', name: '平板', parentId: 'electronics'),
      CategoryItem(id: 'clothing', name: '服装', parentId: null),
      CategoryItem(id: 'men', name: '男装', parentId: 'clothing'),
      CategoryItem(id: 'women', name: '女装', parentId: 'clothing'),
      CategoryItem(id: 'kids', name: '童装', parentId: 'clothing'),
    ];
  }

  /// 构建产品数据
  List<ProductItem> _buildProductData() {
    return [
      ProductItem(
          id: 'electronics',
          name: '电子产品',
          categoryId: null,
          childCount: 3,
          price: 0),
      ProductItem(
          id: 'phone1',
          name: 'iPhone 15',
          categoryId: 'electronics',
          childCount: 0,
          price: 5999),
      ProductItem(
          id: 'phone2',
          name: '华为 Mate 60',
          categoryId: 'electronics',
          childCount: 0,
          price: 5499),
      ProductItem(
          id: 'phone3',
          name: '小米 14',
          categoryId: 'electronics',
          childCount: 0,
          price: 3999),
      ProductItem(
          id: 'clothing',
          name: '服装',
          categoryId: null,
          childCount: 3,
          price: 0),
      ProductItem(
          id: 'cloth1',
          name: '羽绒服',
          categoryId: 'clothing',
          childCount: 0,
          price: 599),
      ProductItem(
          id: 'cloth2',
          name: '毛衣',
          categoryId: 'clothing',
          childCount: 0,
          price: 299),
      ProductItem(
          id: 'cloth3',
          name: '牛仔裤',
          categoryId: 'clothing',
          childCount: 0,
          price: 199),
    ];
  }

  /// 构建城市数据
  List<CityItem> _buildCityData() {
    return [
      CityItem(id: 'east', name: '华东地区', parentId: null),
      CityItem(id: 'shanghai', name: '上海', parentId: 'east'),
      CityItem(id: 'hangzhou', name: '杭州', parentId: 'east'),
      CityItem(id: 'nanjing', name: '南京', parentId: 'east'),
      CityItem(id: 'north', name: '华北地区', parentId: null),
      CityItem(id: 'beijing', name: '北京', parentId: 'north'),
      CityItem(id: 'tianjin', name: '天津', parentId: 'north'),
      CityItem(id: 'shijiazhuang', name: '石家庄', parentId: 'north'),
    ];
  }

  /// 基本编辑器
  void _openBasicEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '基本编辑器',
          initialText: '''1. 第一项内容
2. 第二项内容
3. 第三项内容''',
        ),
      ),
    ).then((result) {
      if (result != null) {
        _showSnackbar('已保存内容，共 ${result.length} 字');
      }
    });
  }

  /// 带副标题的编辑器
  void _openEditorWithSubtitle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '编辑内容',
          subTitle: '请输入详细描述',
          initialText: '''● 要点一
● 要点二
● 要点三''',
        ),
      ),
    );
  }

  /// 带字数限制的编辑器
  void _openEditorWithLimit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '简短描述',
          maxInputCount: 100,
          initialText: '在此输入内容，最多100字',
          placeholder: '请输入内容...',
        ),
      ),
    );
  }

  /// 自定义主题的编辑器
  void _openEditorWithCustomTheme() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '深色主题编辑器',
          initialText: '''1. 支持自定义主题
2. 可配置颜色、样式等
3. 适配不同的设计风格''',
          theme: MultilineEditorTheme(
            backgroundColor: const Color(0xFF1E1E1E),
            appBarBackgroundColor: const Color(0xFF2D2D2D),
            titleColor: const Color(0xFFFFFFFF),
            subTitleColor: const Color(0xFFAAAAAA),
            backIconColor: const Color(0xFFFFFFFF),
            confirmButtonColor: const Color(0xFF4CAF50),
            confirmButtonDisabledColor: const Color(0xFF555555),
            toolbarBackgroundColor: const Color(0xFF2D2D2D),
            clearButtonColor: const Color(0xFF4CAF50),
            clearButtonDisabledColor: const Color(0xFF555555),
          ),
        ),
      ),
    );
  }

  /// 完整示例
  void _openFullEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '产品需求描述',
          subTitle: '请详细描述产品需求，支持列表格式',
          placeholder: '请输入需求描述...',
          maxInputCount: 500,
          initialText: '''1. 功能需求
   - 用户登录
   - 数据同步

2. 性能要求
   - 响应时间 < 100ms
   - 支持 1000 并发

3. 设计规范
   • 遵循 Material Design
   • 使用品牌色调''',
          theme: MultilineEditorTheme(
            backgroundColor: Colors.white,
            appBarBackgroundColor: const Color(0xFFF5F5F5),
            titleColor: const Color(0xFF212121),
            subTitleColor: const Color(0xFF757575),
            backIconColor: const Color(0xFF212121),
            confirmButtonColor: const Color(0xFF2196F3),
            confirmButtonDisabledColor: const Color(0xFFBDBDBD),
            toolbarBackgroundColor: Colors.white,
            clearButtonColor: const Color(0xFF2196F3),
            clearButtonDisabledColor: const Color(0xFFBDBDBD),
          ),
        ),
      ),
    );
  }
}

/// 分类数据项
class CategoryItem {
  final String id;
  final String name;
  final String? parentId;

  CategoryItem({required this.id, required this.name, this.parentId});
}

/// 产品数据项
class ProductItem {
  final String id;
  final String name;
  final String? categoryId;
  final int childCount;
  final double price;

  ProductItem({
    required this.id,
    required this.name,
    this.categoryId,
    required this.childCount,
    required this.price,
  });
}

/// 城市数据项
class CityItem {
  final String id;
  final String name;
  final String? parentId;

  CityItem({required this.id, required this.name, this.parentId});
}

/// 选择器按钮组件
class _SelectorButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const _SelectorButton({
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
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 28,
            ),
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

/// 编辑器按钮组件
class _EditorButton extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onPressed;

  const _EditorButton({
    required this.label,
    required this.description,
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
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.edit_note,
              color: colorScheme.primary,
              size: 28,
            ),
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
