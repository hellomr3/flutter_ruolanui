import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class OptionsContent extends StatelessWidget {
  final int? value;
  final String? title;
  final List<OptionItem> options;
  final String cancelText;

  const OptionsContent({
    super.key,
    this.value,
    this.title,
    required this.options,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material(
      color: colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示条
              _DragHandle(color: colorScheme.onSurfaceVariant),

              // 标题栏（可选）
              if (title != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title!,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // 选项列表
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: options.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 0.5,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = value == option.id;
                    return _OptionTile(
                      option: option,
                      isSelected: isSelected,
                      onTap: () =>
                          Navigator.pop(context, Result.success(option.id)),
                    );
                  },
                ),
              ),

              // 底部分隔线
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),

              // 取消按钮
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 14,
                    bottom: 14 + bottomPadding * 0.2,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cancelText,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 拖拽指示条
class _DragHandle extends StatelessWidget {
  final Color color;

  const _DragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// 单个选项行
class _OptionTile extends StatelessWidget {
  final OptionItem option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: isSelected
                  ? textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    )
                  : textTheme.bodyLarge,
            ),
            if (option.desc != null) ...[
              const SizedBox(height: 2),
              Text(
                option.desc!,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
