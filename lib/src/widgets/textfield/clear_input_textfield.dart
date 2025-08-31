import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class ClearInputTextField extends StatefulWidget {
  final bool enable;
  final String hintText;
  final IconData? icon;
  final Widget? tailIcon;
  final String? value;
  final ValueChanged<String> onChange;
  final bool obscureText;
  final RegExp? filterPattern;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor;
  final bool autoFocus;
  final ValueChanged<String>? onSubmitted;

  const ClearInputTextField(
      {super.key,
      this.enable = true,
      required this.hintText,
      this.icon,
      this.controller,
      this.value,
      required this.onChange,
      this.filterPattern,
      this.textInputAction,
      this.focusNode,
      this.tailIcon,
      this.fillColor,
      this.onSubmitted,
      bool? autoFocus,
      bool? obscureText,
      this.borderRadius = 12,
      TextInputType? keyboardType})
      : obscureText = obscureText ?? false,
        keyboardType = keyboardType ?? TextInputType.text,
        autoFocus = autoFocus ?? false;

  @override
  State<ClearInputTextField> createState() => _ClearInputTextFieldState();
}

class _ClearInputTextFieldState extends State<ClearInputTextField> {
  late TextEditingController _controller;

  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _controller.text = widget.value ?? "";
  }

  @override
  void didUpdateWidget(covariant ClearInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value ?? "";
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      enable: widget.enable,
      hintText: widget.hintText,
      icon: widget.icon,
      filterPattern: widget.filterPattern,
      autofocus: widget.autoFocus,
      tailIcon: Visibility(
        visible: _showClearButton,
        child: IconButton(
          onPressed: () {
            _controller.clear();
            widget.onChange("");
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        borderSide: BorderSide.none,
      ),
      onChange: widget.onChange,
      focusNode: _focusNode,
      controller: _controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      fillColor: widget.fillColor,
      onSubmitted: widget.onSubmitted,
    );
  }
}
