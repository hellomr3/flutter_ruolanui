import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

import 'widget/list_editor_widget.dart';
import 'widget/list_toolbar.dart';
import 'widget/word_count_indicator.dart';

/// 编辑器模板
class EditorTemplate {
  /// 模板名称（用于选择列表展示）
  final String name;

  /// 模板内容
  final String content;

  const EditorTemplate({required this.name, required this.content});
}

/// 多行文本编辑器国际化配置
class MultilineEditorLocale {
  /// 确定按钮文本
  final String confirm;

  /// 清空按钮文本
  final String clear;

  /// 默认标题
  final String defaultTitle;

  /// 默认占位符
  final String defaultPlaceholder;

  /// 挽留弹窗标题
  final String retainTitle;

  /// 挽留弹窗内容
  final String retainContent;

  /// 挽留弹窗确认按钮（继续编辑，强化）
  final String retainConfirm;

  /// 挽留弹窗取消按钮（放弃）
  final String retainCancel;

  /// 模板按钮文本
  final String template;

  /// 模板替换确认弹窗标题
  final String templateReplaceTitle;

  /// 模板替换确认弹窗内容
  final String templateReplaceContent;

  /// 模板替换确认按钮
  final String templateReplaceConfirm;

  /// 模板替换取消按钮
  final String templateReplaceCancel;

  /// 模板选择取消按钮
  final String templateSelectCancel;

  const MultilineEditorLocale({
    this.confirm = '确定',
    this.clear = '清空',
    this.defaultTitle = '编辑内容',
    this.defaultPlaceholder = '请输入内容...',
    this.retainTitle = '提示',
    this.retainContent = '内容已修改，确定要放弃编辑吗？',
    this.retainConfirm = '继续编辑',
    this.retainCancel = '放弃',
    this.template = '模板',
    this.templateReplaceTitle = '提示',
    this.templateReplaceContent = '当前内容将被模板替换，是否继续？',
    this.templateReplaceConfirm = '替换',
    this.templateReplaceCancel = '取消',
    this.templateSelectCancel = '取消',
  });

  /// 创建中文配置
  const MultilineEditorLocale.zh() : this();

  /// 创建英文配置
  static const MultilineEditorLocale en = MultilineEditorLocale(
    confirm: 'Confirm',
    clear: 'Clear',
    defaultTitle: 'Edit Content',
    defaultPlaceholder: 'Please enter content...',
    retainTitle: 'Unsaved Changes',
    retainContent: 'You have unsaved changes. Discard them?',
    retainConfirm: 'Keep Editing',
    retainCancel: 'Discard',
    template: 'Template',
    templateReplaceTitle: 'Notice',
    templateReplaceContent:
        'Current content will be replaced by the template. Continue?',
    templateReplaceConfirm: 'Replace',
    templateReplaceCancel: 'Cancel',
    templateSelectCancel: 'Cancel',
  );
}

/// 多行文本编辑器主题配置
class MultilineEditorTheme {
  /// 背景色
  final Color backgroundColor;

  /// AppBar 背景色
  final Color appBarBackgroundColor;

  /// 标题颜色
  final Color titleColor;

  /// 副标题颜色
  final Color subTitleColor;

  /// 返回按钮颜色
  final Color backIconColor;

  /// 主色（确定按钮、清空按钮、工具栏激活状态）
  final Color primaryColor;

  /// 禁用态颜色
  final Color disabledColor;

  /// 底部工具栏背景色
  final Color toolbarBackgroundColor;

  const MultilineEditorTheme({
    this.backgroundColor = Colors.white,
    this.appBarBackgroundColor = Colors.white,
    this.titleColor = const Color(0xFF424242),
    this.subTitleColor = const Color(0xFF787878),
    this.backIconColor = const Color(0xFF424242),
    this.primaryColor = const Color(0xFF0052D9),
    this.disabledColor = const Color(0xFFBBBBBB),
    this.toolbarBackgroundColor = Colors.white,
  });

  /// 创建默认主题
  const MultilineEditorTheme.defaultTheme() : this();

  /// 从当前 context 创建基于系统主题的配置
  factory MultilineEditorTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return MultilineEditorTheme(
      backgroundColor: colorScheme.surface,
      appBarBackgroundColor: colorScheme.surface,
      titleColor: colorScheme.onSurface,
      subTitleColor: colorScheme.onSurface.withOpacity(0.6),
      backIconColor: colorScheme.onSurface,
      primaryColor: colorScheme.primary,
      disabledColor: colorScheme.onSurface.withOpacity(0.38),
      toolbarBackgroundColor: colorScheme.surface,
    );
  }
}

/// 长文本编辑页面
///
/// 支持有序列表（1、2、3、）和无序列表（●）功能，
/// 底部工具栏可切换列表模式，显示字数统计。
class MultilineTextEditorPage extends StatefulWidget {
  /// 标题
  final String? title;

  /// 副标题
  final String? subTitle;

  /// 占位符
  final String? placeholder;

  /// 最大输入字数
  final int maxInputCount;

  /// 初始文本
  final String initialText;

  /// 主题配置
  final MultilineEditorTheme theme;

  /// 国际化配置
  final MultilineEditorLocale locale;

  /// 模板列表（为空或 null 时不显示模板按钮）
  final List<EditorTemplate>? templates;

  const MultilineTextEditorPage({
    super.key,
    this.title,
    this.subTitle,
    this.placeholder,
    this.maxInputCount = 500,
    this.initialText = '',
    this.theme = const MultilineEditorTheme.defaultTheme(),
    this.locale = const MultilineEditorLocale.zh(),
    this.templates,
  });

  @override
  State<MultilineTextEditorPage> createState() =>
      _MultilineTextEditorPageState();
}

class _MultilineTextEditorPageState extends State<MultilineTextEditorPage> {
  final FocusNode _focusNode = FocusNode();
  final _editorKey = GlobalKey<ListEditorWidgetState>();
  final _toolbarKey = GlobalKey<ListToolbarState>();

  // 列表激活状态
  bool _isOrderedActive = false;
  bool _isUnorderedActive = false;

  // 当前文本
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.initialText;

    // 自动弹出键盘
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// 内容是否有变化
  bool get _hasChanges => _currentText != widget.initialText;

  void _handleBackTap() async {
    if (_hasChanges) {
      final result = await _showRetainDialog();
      // confirm（继续编辑）返回 true → 留下；cancel（放弃）返回 false → 离开
      if (result.data != false) return;
    }
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) Navigator.of(context).pop(null);
    });
  }

  Future<Result<bool>> _showRetainDialog() {
    final locale = widget.locale;
    return showConfirmDialog(
      context: context,
      title: locale.retainTitle,
      content: locale.retainContent,
      confirmText: locale.retainConfirm,
      cancelText: locale.retainCancel,
    );
  }

  void _handleConfirmTap() {
    _focusNode.unfocus();
    Navigator.of(context).pop(_currentText);
  }

  void _handleClearTap() {
    if (_currentText.isEmpty) return;

    // 清空编辑器文本
    _editorKey.currentState?.clear();
    setState(() {
      _currentText = '';
    });
  }

  bool get _hasTemplates =>
      widget.templates != null && widget.templates!.isNotEmpty;

  void _handleTemplateTap() async {
    final templates = widget.templates;
    if (templates == null || templates.isEmpty) return;

    // 先收起键盘，防止弹窗弹出时界面跳动
    _focusNode.unfocus();

    // 弹出模板选择列表
    final options = List.generate(
      templates.length,
      (i) => OptionItem(id: i, label: templates[i].name),
    );
    final result = await showOptionsDialog(
      context: context,
      options: options,
      cancelText: widget.locale.templateSelectCancel,
    );
    if (!result.isSuccess || !mounted) return;

    final selected = templates[result.data!];

    // 如果当前有内容，先确认替换
    if (_currentText.isNotEmpty) {
      final confirm = await showConfirmDialog(
        context: context,
        title: widget.locale.templateReplaceTitle,
        content: widget.locale.templateReplaceContent,
        confirmText: widget.locale.templateReplaceConfirm,
        cancelText: widget.locale.templateReplaceCancel,
      );
      if (confirm.data != true || !mounted) return;
    }

    // 应用模板
    _editorKey.currentState?.setText(selected.content);
    setState(() {
      _currentText = selected.content;
    });
  }

  void _onTextChanged(String text) {
    setState(() {
      _currentText = text;
    });
  }

  void _onListStateChanged(bool isOrdered, bool isUnordered) {
    setState(() {
      _isOrderedActive = isOrdered;
      _isUnorderedActive = isUnordered;
    });
  }

  void _handleTapOutside(PointerDownEvent event) {
    // 判断点击是否在工具栏按钮内
    final listButtonKeys = _toolbarKey.currentState?.listButtonKeys ?? [];
    for (final key in listButtonKeys) {
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero);
          final buttonRect = offset & renderBox.size;
          if (buttonRect.contains(event.position)) {
            // 点击在序列按钮内，不关闭键盘
            return;
          }
        }
      }
    }
    // 点击在序列按钮外，关闭键盘
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = widget.theme;

    return Scaffold(
      backgroundColor: themeConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeConfig.appBarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeConfig.backIconColor),
          onPressed: _handleBackTap,
        ),
        title: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title ?? widget.locale.defaultTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: themeConfig.titleColor,
                ),
              ),
              if (widget.subTitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.subTitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeConfig.subTitleColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        titleSpacing: 0,
        actions: [
          TextButton(
            onPressed: _handleConfirmTap,
            child: Text(
              widget.locale.confirm,
              style: TextStyle(
                fontSize: 15,
                color:
                    _currentText.isNotEmpty
                        ? themeConfig.primaryColor
                        : themeConfig.disabledColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 编辑器区域
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListEditorWidget(
                  key: _editorKey,
                  text: widget.initialText,
                  placeholder:
                      widget.placeholder ?? widget.locale.defaultPlaceholder,
                  focusNode: _focusNode,
                  maxInputCount: widget.maxInputCount,
                  enableList: true,
                  onChanged: _onTextChanged,
                  onListStateChanged: _onListStateChanged,
                  onTapOutside: _handleTapOutside,
                ),
              ),
            ),
            // 底部区域：工具栏 + 字数统计 + 清空按钮
            Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: themeConfig.toolbarBackgroundColor,
              ),
              child: Row(
                children: [
                  // 工具栏
                  Expanded(
                    child: ListToolbar(
                      key: _toolbarKey,
                      showOrdered: true,
                      showUnordered: true,
                      showTemplate: _hasTemplates,
                      isOrderedActive: _isOrderedActive,
                      isUnorderedActive: _isUnorderedActive,
                      primaryColor: themeConfig.primaryColor,
                      onOrderedListToggle:
                          () => _editorKey.currentState?.toggleOrderedList(),
                      onUnorderedListToggle:
                          () => _editorKey.currentState?.toggleUnorderedList(),
                      onTemplateTap: _handleTemplateTap,
                    ),
                  ),
                  // 字数统计
                  WordCountIndicator(
                    currentLength: _currentText.length,
                    maxLength: widget.maxInputCount,
                  ),
                  const SizedBox(width: 12),
                  // 清空按钮
                  InkWell(
                    onTap: _currentText.isNotEmpty ? _handleClearTap : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        widget.locale.clear,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              _currentText.isNotEmpty
                                  ? themeConfig.primaryColor
                                  : themeConfig.disabledColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
