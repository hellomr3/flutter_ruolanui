import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  const CommonAppBar({
    Key? key,
    this.backgroundColor,
    this.title,
    this.actions,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: title != null
          ? Text(title ?? "", style: textTheme.titleMedium)
          : null,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      flexibleSpace: Container(color: backgroundColor ?? colorScheme.surface),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
