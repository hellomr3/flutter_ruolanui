import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// 大量选项弹窗 — 使用 Wrap 自动换行布局
///
/// 支持泛型数据 [T]，通过 [itemBuilder] 自定义每个选项的渲染。
/// 高度自适应内容，最高不超过屏幕的 0.85，超出时中间区域可滚动，
/// 底部展示取消和确认按钮。
class WrapOptionsDialog<T> extends StatefulWidget {
  /// 弹窗标题
  final String title;

  /// 顶部右侧自定义组件
  final Widget? trailing;

  /// 选项数据列表
  final List<T> options;

  /// 当前已选中的索引集合
  final Set<int> initialSelected;

  /// 自定义选项构建器
  ///
  /// - [item] 当前选项数据
  /// - [index] 当前索引
  /// - [isSelected] 是否选中
  /// - [onTap] 点击回调，调用后切换选中状态
  final Widget Function(
    T item,
    int index,
    bool isSelected,
    VoidCallback onTap,
  ) itemBuilder;

  /// Wrap 水平间距
  final double spacing;

  /// Wrap 垂直间距
  final double runSpacing;

  /// 是否支持多选，默认 true
  final bool multiSelect;

  /// 确认按钮文本
  final String confirmText;

  /// 取消按钮文本
  final String cancelText;

  const WrapOptionsDialog({
    super.key,
    required this.title,
    this.trailing,
    required this.options,
    this.initialSelected = const {},
    required this.itemBuilder,
    this.spacing = 10,
    this.runSpacing = 10,
    this.multiSelect = true,
    this.confirmText = "确定",
    this.cancelText = "取消",
  });

  @override
  State<WrapOptionsDialog<T>> createState() => _WrapOptionsDialogState<T>();
}

class _WrapOptionsDialogState<T> extends State<WrapOptionsDialog<T>> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.initialSelected);
  }

  void _toggle(int index) {
    if (widget.multiSelect) {
      setState(() {
        if (_selected.contains(index)) {
          _selected.remove(index);
        } else {
          _selected.add(index);
        }
      });
    } else {
      // 单选：点击即返回
      Navigator.pop(context, Result.success(<int>{index}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题栏
            _Header(
              title: widget.title,
              trailing: widget.trailing,
              onClose: () => Navigator.pop(context),
            ),

            // 中间可滚动区域
            Flexible(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: widget.spacing,
                  runSpacing: widget.runSpacing,
                  children: List.generate(widget.options.length, (index) {
                    final isSelected = _selected.contains(index);
                    return widget.itemBuilder(
                      widget.options[index],
                      index,
                      isSelected,
                      () => _toggle(index),
                    );
                  }),
                ),
              ),
            ),

            // 底部操作栏（仅多选时展示）
            if (widget.multiSelect)
              _BottomActions(
                cancelText: widget.cancelText,
                confirmText: widget.confirmText,
                onCancel: () => Navigator.pop(context),
                onConfirm: () =>
                    Navigator.pop(context, Result.success(_selected)),
              ),

            // 单选时底部留出安全区间距
            if (!widget.multiSelect)
              SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
          ],
        ),
      ),
    );
  }
}

/// 顶部标题栏：左侧标题 + 右侧自定义 / 关闭按钮
class _Header extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onClose;

  const _Header({
    required this.title,
    this.trailing,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, top: 12, bottom: 4),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
          if (trailing == null)
            IconButton(
              icon: Icon(
                Icons.close,
                size: 22,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: onClose,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

/// 底部操作栏：取消 + 确认
class _BottomActions extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _BottomActions({
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 12 + bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextBtn(
              label: cancelText,
              height: 44,
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryBtn(
              label: confirmText,
              height: 44,
              onPressed: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
