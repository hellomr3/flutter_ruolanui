import 'package:flutter/material.dart';

class BlockBtn extends StatelessWidget {
  final String title;
  final String? hint;
  final VoidCallback? onTap;
  final IconData? leading;
  final Widget? trailing;
  final bool showDivider;
  final BorderRadius? borderRadius;

  const BlockBtn(
      {super.key,
      required this.title,
      this.hint,
      this.onTap,
      this.leading,
      this.trailing,
      this.borderRadius,
      this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final titleValid = title.isNotEmpty;
    final hintValid = hint != null && hint!.isNotEmpty;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: borderRadius,
            ),
            child: ListTile(
              leading: leading != null ? Icon(leading) : null,
              title: !titleValid
                  ? null
                  : Text(
                      title,
                      style: textTheme.bodyMedium,
                    ),
              subtitle: !titleValid && hintValid
                  ? Text(
                      hint ?? "",
                      style: textTheme.labelMedium,
                    )
                  : null,
              trailing: _buildTrailing(),
              onTap: null,
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 0.5,
            thickness: 1,
            color: colorScheme.surfaceContainer,
          ),
      ],
    );
  }

  Widget? _buildTrailing() {
    if (onTap == null) {
      return trailing;
    }

    if (trailing == null) {
      return const Icon(
        Icons.chevron_right,
        size: 20,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        trailing!,
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right,
          size: 20,
        ),
      ],
    );
  }
}
