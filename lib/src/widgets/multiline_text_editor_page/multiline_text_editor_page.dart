import 'package:flutter/material.dart';

import 'widget/list_editor_widget.dart';
import 'widget/list_toolbar.dart';
import 'widget/word_count_indicator.dart';

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
  final String title;

  /// 副标题
  final String? subTitle;

  /// 占位符
  final String placeholder;

  /// 最大输入字数
  final int maxInputCount;

  /// 初始文本
  final String initialText;

  /// 主题配置
  final MultilineEditorTheme theme;

  const MultilineTextEditorPage({
    super.key,
    this.title = '编辑内容',
    this.subTitle,
    this.placeholder = '请输入内容...',
    this.maxInputCount = 500,
    this.initialText = '',
    this.theme = const MultilineEditorTheme.defaultTheme(),
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

  void _handleBackTap() {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pop(_currentText);
    });
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
                widget.title,
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
              '确定',
              style: TextStyle(
                fontSize: 15,
                color: _currentText.isNotEmpty
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
                  placeholder: widget.placeholder,
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
                      isOrderedActive: _isOrderedActive,
                      isUnorderedActive: _isUnorderedActive,
                      primaryColor: themeConfig.primaryColor,
                      onOrderedListToggle: () =>
                          _editorKey.currentState?.toggleOrderedList(),
                      onUnorderedListToggle: () =>
                          _editorKey.currentState?.toggleUnorderedList(),
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
                        '清空',
                        style: TextStyle(
                          fontSize: 14,
                          color: _currentText.isNotEmpty
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
