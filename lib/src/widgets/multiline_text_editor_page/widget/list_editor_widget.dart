import 'package:flutter/material.dart';
import '../mixin/list_editor_mixin.dart';

/// 列表编辑器组件
///
/// 支持有序列表（1、2、3、）和无序列表（●）功能。
class ListEditorWidget extends StatefulWidget {
  /// 初始文本
  final String text;

  /// 占位符
  final String placeholder;

  /// 焦点节点
  final FocusNode focusNode;

  /// 焦点出现回调
  final VoidCallback? onFocus;

  /// 焦点消失回调
  final VoidCallback? onBlur;

  /// 输入变化回调
  final ValueChanged<String>? onChanged;

  /// 列表状态变化回调（用于更新工具栏按钮状态）
  final void Function(bool isOrdered, bool isUnordered)? onListStateChanged;

  /// 最大输入数量
  final int maxInputCount;

  /// 是否启用列表功能
  final bool enableList;

  /// 点击外部区域回调
  final void Function(PointerDownEvent)? onTapOutside;

  const ListEditorWidget({
    super.key,
    this.text = '',
    this.placeholder = '请输入内容...',
    required this.focusNode,
    this.onFocus,
    this.onBlur,
    this.onChanged,
    this.onListStateChanged,
    this.maxInputCount = 500,
    this.enableList = true,
    this.onTapOutside,
  });

  @override
  State<ListEditorWidget> createState() => ListEditorWidgetState();
}

class ListEditorWidgetState extends State<ListEditorWidget>
    with ListEditorMixin {
  late TextEditingController _controller;

  // ============ ListEditorMixin 实现 ============

  @override
  TextEditingController get listController => _controller;

  FocusNode get listFocusNode => widget.focusNode;

  @override
  void onListStateChanged(bool isOrdered, bool isUnordered) {
    widget.onListStateChanged?.call(isOrdered, isUnordered);
  }

  // ============ 生命周期 ============

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    if (widget.enableList) {
      initListEditor();
    }
  }

  @override
  void didUpdateWidget(ListEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 只在非焦点状态下更新文本，避免编辑时被覆盖
    if (widget.text != oldWidget.text && !widget.focusNode.hasFocus) {
      _controller.text = widget.text;
      if (widget.enableList) {
        updateListPreviousText(widget.text);
      }
    }
  }

  @override
  void dispose() {
    if (widget.enableList) {
      disposeListEditor();
    }
    _controller.dispose();
    super.dispose();
  }

  // ============ 公开方法 ============

  /// 清空内容
  void clear() {
    _controller.clear();
    if (widget.enableList) {
      updateListPreviousText('');
    }
    widget.onChanged?.call('');
  }

  /// 获取当前文本
  String getText() {
    return _controller.text;
  }

  /// 设置文本内容
  void setText(String text) {
    _controller.text = text;
    if (widget.enableList) {
      updateListPreviousText(text);
    }
    widget.onChanged?.call(text);
  }

  // ============ 内部方法 ============

  /// 处理文本变化
  void _handleTextChanged(String newText) {
    if (!widget.enableList) {
      widget.onChanged?.call(newText);
      return;
    }

    final processedText = handleListTextChanged(newText);
    widget.onChanged?.call(processedText);
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      maxLines: null,
      minLines: 1,
      maxLength: widget.maxInputCount,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        border: InputBorder.none,
        counterStyle: const TextStyle(fontSize: 0),
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        height: 1.6,
      ),
      strutStyle: const StrutStyle(
        fontSize: 15,
        height: 1.6,
      ),
      onChanged: _handleTextChanged,
      onTap: widget.onFocus,
    );

    if (widget.onTapOutside != null) {
      return Listener(
        onPointerDown: widget.onTapOutside,
        behavior: HitTestBehavior.translucent,
        child: textField,
      );
    }

    return textField;
  }
}
