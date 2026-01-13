import 'package:flutter/material.dart';

/// 双栏选择器主题配置
class TwoPaneSelectorTheme {
  /// 容器高度（相对于屏幕高度的比例）
  final double containerHeightFactor;

  /// 容器圆角
  final BorderRadius containerBorderRadius;

  /// 容器背景色
  final Color? containerColor;

  /// 左侧面板宽度比例（0-1）
  final double leftPanelWidthFactor;

  /// 左侧面板背景色
  final Color? leftPanelColor;

  /// 右侧面板背景色
  final Color? rightPanelColor;

  /// 标题栏内边距
  final EdgeInsets headerPadding;

  /// 标题文字样式
  final TextStyle? titleStyle;

  /// 返回按钮图标大小
  final double backIconSize;

  /// 返回按钮与标题间距
  final double backIconSpacing;

  /// 确认按钮高度
  final double confirmButtonHeight;

  /// 确认按钮圆角
  final double confirmButtonBorderRadius;

  /// 确认按钮文字
  final String confirmButtonText;

  /// 空状态提示文字
  final String emptyStateText;

  /// 空状态文字样式
  final TextStyle? emptyStateTextStyle;

  /// 底部已选项目栏顶部内边距
  final double bottomBarTopPadding;

  /// 分割线高度
  final double dividerHeight;

  const TwoPaneSelectorTheme({
    this.containerHeightFactor = 0.65,
    this.containerBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    ),
    this.containerColor,
    this.leftPanelWidthFactor = 0.3,
    this.leftPanelColor,
    this.rightPanelColor,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.titleStyle,
    this.backIconSize = 24.0,
    this.backIconSpacing = 12.0,
    this.confirmButtonHeight = 32.0,
    this.confirmButtonBorderRadius = 9.0,
    this.confirmButtonText = "确定",
    this.emptyStateText = "请选择左侧项目",
    this.emptyStateTextStyle,
    this.bottomBarTopPadding = 12,
    this.dividerHeight = 1,
  });

  /// 从上下文创建默认主题
  factory TwoPaneSelectorTheme.of(BuildContext context) {
    final theme = Theme.of(context);
    return TwoPaneSelectorTheme(
      containerColor: theme.colorScheme.surface,
      leftPanelColor: theme.colorScheme.surface,
      rightPanelColor: theme.colorScheme.surfaceContainer,
      titleStyle: theme.textTheme.titleLarge,
      emptyStateTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  /// 创建浅色主题
  static TwoPaneSelectorTheme light(ColorScheme colorScheme, TextTheme textTheme) {
    return TwoPaneSelectorTheme(
      containerColor: colorScheme.surface,
      leftPanelColor: colorScheme.surface,
      rightPanelColor: colorScheme.surfaceContainer,
      titleStyle: textTheme.titleLarge,
      emptyStateTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  /// 创建深色主题
  static TwoPaneSelectorTheme dark(ColorScheme colorScheme, TextTheme textTheme) {
    return TwoPaneSelectorTheme(
      containerColor: colorScheme.surface,
      leftPanelColor: colorScheme.surface,
      rightPanelColor: colorScheme.surfaceContainer,
      titleStyle: textTheme.titleLarge,
      emptyStateTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  /// 复制并修改部分属性
  TwoPaneSelectorTheme copyWith({
    double? containerHeightFactor,
    BorderRadius? containerBorderRadius,
    Color? containerColor,
    double? leftPanelWidthFactor,
    Color? leftPanelColor,
    Color? rightPanelColor,
    EdgeInsets? headerPadding,
    TextStyle? titleStyle,
    double? backIconSize,
    double? backIconSpacing,
    double? confirmButtonHeight,
    double? confirmButtonBorderRadius,
    String? confirmButtonText,
    String? emptyStateText,
    TextStyle? emptyStateTextStyle,
    double? bottomBarTopPadding,
    double? dividerHeight,
  }) {
    return TwoPaneSelectorTheme(
      containerHeightFactor: containerHeightFactor ?? this.containerHeightFactor,
      containerBorderRadius: containerBorderRadius ?? this.containerBorderRadius,
      containerColor: containerColor ?? this.containerColor,
      leftPanelWidthFactor: leftPanelWidthFactor ?? this.leftPanelWidthFactor,
      leftPanelColor: leftPanelColor ?? this.leftPanelColor,
      rightPanelColor: rightPanelColor ?? this.rightPanelColor,
      headerPadding: headerPadding ?? this.headerPadding,
      titleStyle: titleStyle ?? this.titleStyle,
      backIconSize: backIconSize ?? this.backIconSize,
      backIconSpacing: backIconSpacing ?? this.backIconSpacing,
      confirmButtonHeight: confirmButtonHeight ?? this.confirmButtonHeight,
      confirmButtonBorderRadius:
          confirmButtonBorderRadius ?? this.confirmButtonBorderRadius,
      confirmButtonText: confirmButtonText ?? this.confirmButtonText,
      emptyStateText: emptyStateText ?? this.emptyStateText,
      emptyStateTextStyle: emptyStateTextStyle ?? this.emptyStateTextStyle,
      bottomBarTopPadding: bottomBarTopPadding ?? this.bottomBarTopPadding,
      dividerHeight: dividerHeight ?? this.dividerHeight,
    );
  }

  /// 主题数据（用于与 Flutter 主题系统集成）
  TwoPaneSelectorThemeData toData() {
    return TwoPaneSelectorThemeData(
      containerHeightFactor: containerHeightFactor,
      containerBorderRadius: containerBorderRadius,
      containerColor: containerColor,
      leftPanelWidthFactor: leftPanelWidthFactor,
      leftPanelColor: leftPanelColor,
      rightPanelColor: rightPanelColor,
      headerPadding: headerPadding,
      titleStyle: titleStyle,
      backIconSize: backIconSize,
      backIconSpacing: backIconSpacing,
      confirmButtonHeight: confirmButtonHeight,
      confirmButtonBorderRadius: confirmButtonBorderRadius,
      confirmButtonText: confirmButtonText,
      emptyStateText: emptyStateText,
      emptyStateTextStyle: emptyStateTextStyle,
      bottomBarTopPadding: bottomBarTopPadding,
      dividerHeight: dividerHeight,
    );
  }
}

/// 主题数据（不可变）
class TwoPaneSelectorThemeData {
  final double containerHeightFactor;
  final BorderRadius containerBorderRadius;
  final Color? containerColor;
  final double leftPanelWidthFactor;
  final Color? leftPanelColor;
  final Color? rightPanelColor;
  final EdgeInsets headerPadding;
  final TextStyle? titleStyle;
  final double backIconSize;
  final double backIconSpacing;
  final double confirmButtonHeight;
  final double confirmButtonBorderRadius;
  final String confirmButtonText;
  final String emptyStateText;
  final TextStyle? emptyStateTextStyle;
  final double bottomBarTopPadding;
  final double dividerHeight;

  const TwoPaneSelectorThemeData({
    this.containerHeightFactor = 0.65,
    this.containerBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    ),
    this.containerColor,
    this.leftPanelWidthFactor = 0.3,
    this.leftPanelColor,
    this.rightPanelColor,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.titleStyle,
    this.backIconSize = 24.0,
    this.backIconSpacing = 12.0,
    this.confirmButtonHeight = 32.0,
    this.confirmButtonBorderRadius = 9.0,
    this.confirmButtonText = "确定",
    this.emptyStateText = "请选择左侧项目",
    this.emptyStateTextStyle,
    this.bottomBarTopPadding = 12,
    this.dividerHeight = 1,
  });

  /// 转换为可变主题对象
  TwoPaneSelectorTheme toTheme() {
    return TwoPaneSelectorTheme(
      containerHeightFactor: containerHeightFactor,
      containerBorderRadius: containerBorderRadius,
      containerColor: containerColor,
      leftPanelWidthFactor: leftPanelWidthFactor,
      leftPanelColor: leftPanelColor,
      rightPanelColor: rightPanelColor,
      headerPadding: headerPadding,
      titleStyle: titleStyle,
      backIconSize: backIconSize,
      backIconSpacing: backIconSpacing,
      confirmButtonHeight: confirmButtonHeight,
      confirmButtonBorderRadius: confirmButtonBorderRadius,
      confirmButtonText: confirmButtonText,
      emptyStateText: emptyStateText,
      emptyStateTextStyle: emptyStateTextStyle,
      bottomBarTopPadding: bottomBarTopPadding,
      dividerHeight: dividerHeight,
    );
  }
}
