import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruolanui_example/pages/time_selector.dart';

class DatePage extends StatelessWidget {
  const DatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [TimeSelector()],
        ),
      ),
    );
  }
}
