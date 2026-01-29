import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(
      label: "显示选项",
      onPressed: () {
        showSampleOptionsDialog(options: ["拍照", "摄像"], context: context);
      },
    );
  }
}
