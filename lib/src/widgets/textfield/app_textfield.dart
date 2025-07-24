import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final bool enable;
  final String hintText;
  final IconData? icon;
  final Widget? tailIcon;
  final ValueChanged<String> onChange;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final RegExp? filterPattern;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final InputBorder? border;
  final Color? fillColor;
  final bool autofocus;

  const AppTextField(
      {super.key,
      this.enable = true,
      required this.hintText,
      this.icon,
      this.controller,
      required this.onChange,
      this.onSubmitted,
      this.filterPattern,
      this.textInputAction,
      this.focusNode,
      this.border,
      this.tailIcon,
      this.fillColor,
      bool? autofocus,
      bool? obscureText,
      TextInputType? keyboardType})
      : obscureText = obscureText ?? false,
        autofocus = autofocus ?? false,
        keyboardType = keyboardType ?? TextInputType.text;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return TextField(
      enabled: widget.enable,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      style: textTheme.titleMedium,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium,
          hoverColor: colorScheme.primary,
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: colorScheme.onSurface,
                )
              : null,
          suffixIcon: widget.tailIcon,
          filled: true,
          fillColor: widget.fillColor ?? colorScheme.surface,
          border: widget.border,
          isDense: true),
      onChanged: widget.onChange,
      onSubmitted: widget.onSubmitted,
      inputFormatters: [
        if (widget.filterPattern != null)
          FilteringTextInputFormatter.allow(widget.filterPattern!),
      ],
    );
  }
}
