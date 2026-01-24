import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(
      label: "显示选项",
      onPressed: () {
        _showAOptionsDialog(options: ["拍照", "摄像"], context: context);
      },
    );
  }

  _showAOptionsDialog(
      {required List<String> options,
      required BuildContext context,
      int? value}) async {
    final realOptions = List.generate(options.length,
        (i) => OptionItem(id: i, label: options[i], desc: options[i]));

    final r =
        showOptionsDialog(context: context, options: realOptions, value: value);
  }
}
