import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardDismiss extends StatelessWidget {
  const KeyboardDismiss({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处隐藏键盘
        systemHideKeyboard();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// 系统通道直接隐藏键盘
void systemHideKeyboard() {
  try {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  } catch (e) {
    // doNothing
  }
}
