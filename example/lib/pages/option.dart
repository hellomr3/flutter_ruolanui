import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryBtn(
          label: "显示选项",
          onPressed: () {
            showSampleOptionsDialog(options: ["拍照", "摄像"], context: context);
          },
        ),
        PrimaryBtn(
          label: "确认弹窗",
          onPressed: () {
            showConfirmDialog(
                context: context, title: "提示", content: "确定要删除吗？");
          },
        )
      ],
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
