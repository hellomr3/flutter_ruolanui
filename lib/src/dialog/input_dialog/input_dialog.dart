import 'package:flutter/material.dart';
import 'package:ruolanui/src/widgets/textfield/clear_input_textfield.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final String initialValue;
  final ValueChanged<String> onConfirm;

  const InputDialog({
    super.key,
    required this.title,
    required this.hintText,
    required this.confirmText,
    required this.cancelText,
    required this.initialValue,
    required this.onConfirm,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ClearInputTextField(
              value: widget.initialValue,
              controller: controller,
              hintText: widget.hintText,
              onChange: (v) {},
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      widget.cancelText,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onConfirm(controller.text);
                    },
                    child: Text(
                      widget.confirmText,
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
