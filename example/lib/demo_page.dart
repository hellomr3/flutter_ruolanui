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
