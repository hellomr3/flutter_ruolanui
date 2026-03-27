import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 自定义侧滑拦截监听器
///
/// 在 iOS 端禁用原生侧滑并改用手势判定逻辑
/// 在 Android 端利用 PopScope 拦截物理返回键
class SwipeBackListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeBack;
  final bool isEnable; // 是否开启拦截逻辑

  const SwipeBackListener({
    super.key,
    required this.child,
    required this.onSwipeBack,
    this.isEnable = true,
  });

  @override
  State<SwipeBackListener> createState() => _SwipeBackListenerState();
}

class _SwipeBackListenerState extends State<SwipeBackListener> {
  /// 滑动起始点
  Offset _startOffset = Offset.zero;

  /// 侧滑判定的边缘宽度
  static const double _leftEdgeThreshold = 40.0;

  /// 最小触发滑动的距离 (屏幕宽度的比例)
  static const double _minSwipeDistanceFactor = 0.15;

  /// 触发返回的水平瞬时速度阈值 (类似 iOS 的 "甩出去" 动作)
  static const double _minVelocityThreshold = 200.0;

  /// 水平滑动的角度阈值 (防止上下滑动误触)
  static const double _maxSwipeAngle = 25.0;

  void _handleHorizontalDragStart(DragStartDetails details) {
    _startOffset = details.globalPosition;
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final endOffset = details.globalPosition;
    final totalOffset = endOffset - _startOffset;

    final double dx = totalOffset.dx;
    final double dy = totalOffset.dy;

    // 1. 必须是从左往右滑
    if (dx <= 0) return;

    // 2. 角度判定：避免在斜着划或上下划时触发
    final angle = (math.atan2(dy.abs(), dx) * 180 / math.pi);
    if (angle > _maxSwipeAngle) return;

    // 3. 判定触发条件：
    // 条件 A: 滑动距离超过阈值
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDistanceEnough = dx > (screenWidth * _minSwipeDistanceFactor);

    // 条件 B: 滑动速度够快 (用户想快速划走)
    final bool isVelocityFast =
        details.velocity.pixelsPerSecond.dx > _minVelocityThreshold;

    if (isDistanceEnough || isVelocityFast) {
      widget.onSwipeBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnable) return widget.child;

    final bool isIOS = Platform.isIOS;

    // PopScope 用于拦截 Android 返回键和 iOS 的原生手势
    return PopScope(
      canPop: false, // 核心：设为 false 禁用 iOS 原生侧滑和 Android 默认返回
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // 只有非 iOS 平台（如 Android）才在此处处理系统返回键逻辑
        if (!isIOS) {
          widget.onSwipeBack();
        }
      },
      child: isIOS ? _buildIOSGestureDetector() : widget.child,
    );
  }

  /// 构建 iOS 专用的手势识别器
  Widget _buildIOSGestureDetector() {
    return Stack(
      children: [
        widget.child,
        // 我们只在屏幕左侧边缘放置一个透明的“感应区”，减少对页面中间滚动组件的干扰
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _leftEdgeThreshold,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _handleHorizontalDragStart,
            onHorizontalDragEnd: _handleHorizontalDragEnd,
            // 占位
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

/// 扩展方法便于链式调用
extension SwipeBackListenerExtension on Widget {
  Widget swipeBackListener({
    required VoidCallback onSwipeBack,
    bool isEnable = true,
  }) {
    return SwipeBackListener(
      onSwipeBack: onSwipeBack,
      isEnable: isEnable,
      child: this,
    );
  }
}
