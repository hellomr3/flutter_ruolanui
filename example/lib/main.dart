import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ruolanui_example/pages/date_page/calendar_selector.dart';
import 'package:ruolanui_example/pages/date_page/date_page.dart';

import 'demo_page.dart';

void main() {
  runApp(const RuolanUIExampleApp());
}

// 定义主色调和辅助色
const Color primaryColor = Color(0xFF0092FF);
const Color primaryDarkColor = Color(0xFF007AD6);
const Color errorColor = Color(0xFFE53935);

class RuolanUIExampleApp extends StatelessWidget {
  const RuolanUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuolanUI Example',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      locale: const Locale('zh', 'CN'),
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        // 沉浸的关键代码
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            // 去除状态栏遮罩
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            // 状态栏图标字体颜色
            systemNavigationBarColor: Colors.black,
            // 底部导航栏颜色
            systemNavigationBarIconBrightness: Brightness.dark, // 底部导航栏图标颜色
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(color: Color(0xFFebebeb)),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryColor.withValues(alpha: 0.4),
          onPrimaryContainer: primaryDarkColor,
          secondary: primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
          surfaceContainer: const Color(0xFFF4F4F4),
          // 纯白色
          inverseSurface: const Color(0xFF303030),
          onInverseSurface: Colors.white,
          surfaceContainerHigh: const Color(0xFFEEEEEE),
          error: errorColor,
          onSurface: const Color(0xFF202020),
          onSurfaceVariant: const Color(0xFF505050),
          outline: const Color(0xFFE0E0E0),
          outlineVariant: const Color(0xFFEAEAEA),
          secondaryContainer: const Color(0xFFF2F2F7),
        ),
      ),
      home: CalendarSelectorExample(),
    );
  }
}
