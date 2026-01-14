import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';
import 'demo_page.dart';

void main() {
  runApp(const RuolanUIExampleApp());
}

class RuolanUIExampleApp extends StatelessWidget {
  const RuolanUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuolanUI Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: DemoPage(),
    );
  }
}
