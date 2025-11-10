import 'package:flutter/widgets.dart';

class AdaptiveDialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  AdaptiveDialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = const Color(0x8A000000),
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  AdaptiveDialogRoute<T> createRoute(BuildContext context) {
    return AdaptiveDialogRoute<T>(
        context: context,
        settings: this,
        builder: builder,
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        themes: themes);
  }
}

class AdaptiveDialogRoute<T> extends PageRoute<T> {
  final double? maxHeightFactor;
  final double? minHeight;
  final EdgeInsets padding;
  final WidgetBuilder _builder;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;

  AdaptiveDialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    super.settings,
    Offset? anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    bool? useSafeArea,
    CapturedThemes? themes,
    this.maxHeightFactor,
    this.minHeight,
    this.padding = EdgeInsets.zero,
  }) : _builder = builder;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget dialog = _builder(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: Builder(
              builder: (BuildContext context) {
                return CustomSingleChildLayout(
                  delegate: _AdaptiveDialogLayout(
                    mediaQuery: mediaQuery,
                    padding: padding,
                    maxHeightFactor: maxHeightFactor,
                    minHeight: minHeight,
                  ),
                  child: dialog,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AdaptiveDialogLayout extends SingleChildLayoutDelegate {
  final MediaQueryData mediaQuery;
  final EdgeInsets padding;
  final double? maxHeightFactor;
  final double? minHeight;

  _AdaptiveDialogLayout({
    required this.mediaQuery,
    required this.padding,
    this.maxHeightFactor,
    this.minHeight,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double availableHeight =
        mediaQuery.size.height - mediaQuery.viewInsets.bottom;
    final double maxHeight = maxHeightFactor != null
        ? availableHeight * maxHeightFactor!
        : availableHeight * 0.9;
    final double minHeight = this.minHeight ?? 0.0;

    return BoxConstraints(
      maxWidth: constraints.maxWidth - padding.horizontal,
      minWidth: constraints.maxWidth - padding.horizontal,
      maxHeight: maxHeight - padding.vertical,
      minHeight: minHeight > 0 ? minHeight - padding.vertical : 0.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double bottomOffset = mediaQuery.viewInsets.bottom;
    return Offset(
      padding.left,
      size.height - childSize.height - padding.bottom - bottomOffset,
    );
  }

  @override
  bool shouldRelayout(_AdaptiveDialogLayout oldDelegate) {
    return oldDelegate.mediaQuery != mediaQuery ||
        oldDelegate.padding != padding ||
        oldDelegate.maxHeightFactor != maxHeightFactor ||
        oldDelegate.minHeight != minHeight;
  }
}
