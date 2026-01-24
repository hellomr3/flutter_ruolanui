import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(
      label: "显示选项",
      onPressed: () {
        showOptionsDialog(options: ["拍照", "摄像"], context: context);
      },
    );
  }

  Future<int?> showOptionsDialog(
      {required List<String> options,
      required BuildContext context,
      int? value}) async {
    final result = await showModalBottomSheet<Result<int>>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (c) => OptionsContent(
              options: options,
              value: value,
              cancelText: "取消",
              dismiss: (int? value) {
                Navigator.pop(context, Result.success(value));
              },
            ));

    return result?.data;
  }
}
