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
            PrimaryBtn(
              label: '打开编辑器',
              onPressed: _openTextEditor,
            ),
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

  void _openTextEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilineTextEditorPage(
          title: '文本编辑器',
          initialText: '''1. 第一项
2. 第二项
3. 第三项''',
        ),
      ),
    ).then((result) {
      if (result != null) {
        _showSnackbar('已保存编辑内容');
      }
    });
  }
}
