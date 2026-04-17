import 'package:flutter/material.dart';

class ActionGridItem {
  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const ActionGridItem({
    this.icon,
    this.iconWidget,
    required this.title,
    required this.onTap,
    this.iconColor,
  });
}

class ActionGrid extends StatelessWidget {
  final String? title;
  final List<ActionGridItem> items;
  final int crossAxisCount;
  final Color? backgroundColor;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const ActionGrid({
    super.key,
    this.title,
    required this.items,
    this.crossAxisCount = 4,
    this.backgroundColor,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: margin,
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: textTheme.titleMedium),
              const SizedBox(height: 16),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                    crossAxisCount;
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  children:
                      items.map((item) {
                        return SizedBox(
                          width: itemWidth,
                          child: GestureDetector(
                            onTap: item.onTap,
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                item.iconWidget ??
                                    Icon(
                                      item.icon,
                                      size: 28,
                                      color:
                                          item.iconColor ??
                                          theme.iconTheme.color,
                                    ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
