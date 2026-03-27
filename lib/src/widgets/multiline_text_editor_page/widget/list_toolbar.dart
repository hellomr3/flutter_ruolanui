import 'package:flutter/material.dart';

/// 列表编辑器工具栏
///
/// 支持有序列表、无序列表和模板按钮
class ListToolbar extends StatefulWidget {
  /// 是否显示有序列表按钮
  final bool showOrdered;

  /// 是否显示无序列表按钮
  final bool showUnordered;

  /// 是否显示模板按钮
  final bool showTemplate;

  /// 有序列表是否激活
  final bool isOrderedActive;

  /// 无序列表是否激活
  final bool isUnorderedActive;

  /// 有序列表切换回调
  final VoidCallback? onOrderedListToggle;

  /// 无序列表切换回调
  final VoidCallback? onUnorderedListToggle;

  /// 模板按钮点击回调
  final VoidCallback? onTemplateTap;

  /// 工具栏高度
  final double? height;

  /// 主色
  final Color primaryColor;

  const ListToolbar({
    super.key,
    this.showOrdered = true,
    this.showUnordered = true,
    this.showTemplate = false,
    this.isOrderedActive = false,
    this.isUnorderedActive = false,
    this.onOrderedListToggle,
    this.onUnorderedListToggle,
    this.onTemplateTap,
    this.height,
    this.primaryColor = const Color(0xFF0052D9),
  });

  @override
  State<ListToolbar> createState() => ListToolbarState();
}

class ListToolbarState extends State<ListToolbar> {
  // 按钮的 GlobalKey，用于判断点击区域
  final GlobalKey _orderedButtonKey = GlobalKey();
  final GlobalKey _unorderedButtonKey = GlobalKey();
  final GlobalKey _templateButtonKey = GlobalKey();

  /// 获取序列按钮的 GlobalKey 列表，用于判断点击区域
  List<GlobalKey> get listButtonKeys => [
    _orderedButtonKey,
    _unorderedButtonKey,
    _templateButtonKey,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 48,
      child: Row(
        children: [
          if (widget.showOrdered)
            _ToolbarButton(
              key: _orderedButtonKey,
              icon: Icons.format_list_numbered,
              isActive: widget.isOrderedActive,
              primaryColor: widget.primaryColor,
              onTap: widget.onOrderedListToggle ?? () {},
            ),
          if (widget.showOrdered && widget.showUnordered)
            const SizedBox(width: 8),
          if (widget.showUnordered)
            _ToolbarButton(
              key: _unorderedButtonKey,
              icon: Icons.format_list_bulleted,
              isActive: widget.isUnorderedActive,
              primaryColor: widget.primaryColor,
              onTap: widget.onUnorderedListToggle ?? () {},
            ),
          if (widget.showTemplate) ...[
            const SizedBox(width: 8),
            _ToolbarButton(
              key: _templateButtonKey,
              icon: Icons.description_outlined,
              isActive: false,
              primaryColor: widget.primaryColor,
              onTap: widget.onTemplateTap ?? () {},
            ),
          ],
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
  final Color primaryColor;
  final VoidCallback onTap;

  const _ToolbarButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSize = 32.0;
    const borderRadius = 6.0;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border:
              isActive
                  ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
                  : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? primaryColor : textTheme.titleMedium!.color,
        ),
      ),
    );
  }
}
