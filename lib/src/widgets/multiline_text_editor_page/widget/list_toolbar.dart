import 'package:flutter/material.dart';

/// 列表编辑器工具栏
///
/// 支持有序列表和无序列表按钮切换
class ListToolbar extends StatefulWidget {
  /// 是否显示有序列表按钮
  final bool showOrdered;

  /// 是否显示无序列表按钮
  final bool showUnordered;

  /// 有序列表是否激活
  final bool isOrderedActive;

  /// 无序列表是否激活
  final bool isUnorderedActive;

  /// 有序列表切换回调
  final VoidCallback? onOrderedListToggle;

  /// 无序列表切换回调
  final VoidCallback? onUnorderedListToggle;

  /// 工具栏高度
  final double? height;

  const ListToolbar({
    super.key,
    this.showOrdered = true,
    this.showUnordered = true,
    this.isOrderedActive = false,
    this.isUnorderedActive = false,
    this.onOrderedListToggle,
    this.onUnorderedListToggle,
    this.height,
  });

  @override
  State<ListToolbar> createState() => ListToolbarState();
}

class ListToolbarState extends State<ListToolbar> {
  // 按钮的 GlobalKey，用于判断点击区域
  final GlobalKey _orderedButtonKey = GlobalKey();
  final GlobalKey _unorderedButtonKey = GlobalKey();

  /// 获取序列按钮的 GlobalKey 列表，用于判断点击区域
  List<GlobalKey> get listButtonKeys =>
      [_orderedButtonKey, _unorderedButtonKey];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showOrdered)
            _ToolbarButton(
              key: _orderedButtonKey,
              icon: Icons.format_list_numbered,
              isActive: widget.isOrderedActive,
              onTap: widget.onOrderedListToggle ?? () {},
            ),
          if (widget.showOrdered && widget.showUnordered)
            const SizedBox(width: 8),
          if (widget.showUnordered)
            _ToolbarButton(
              key: _unorderedButtonKey,
              icon: Icons.format_list_bulleted,
              isActive: widget.isUnorderedActive,
              onTap: widget.onUnorderedListToggle ?? () {},
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// 工具栏按钮
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolbarButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSize = 32.0;
    const borderRadius = 6.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: isActive
              ? Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.blue : Colors.grey[700],
        ),
      ),
    );
  }
}
