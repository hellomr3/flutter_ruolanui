import 'package:flutter/widgets.dart';

/// 自动 dispose mixin，用于管理需要在 State dispose 时清理的资源。
///
/// 使用 [register] 方法注册任意 [ChangeNotifier] 子类（如 FocusNode、
/// TextEditingController、ObservableTextController 等），
/// 在 State dispose 时自动调用其 dispose()。
///
/// ```dart
/// class _MyPageState extends State<MyPage>
///     with AutoDisposeMixin {
///   late final FocusNode _focusNode = autoDispose(FocusNode());
///   late final ObservableTextController _controller = autoDispose(
///     ObservableTextController(...),
///   );
/// }
/// ```
mixin AutoDisposeMixin<T extends StatefulWidget> on State<T> {
  final List<ChangeNotifier> _disposeList = [];

  /// 注册一个 [ChangeNotifier]，在 State dispose 时自动 dispose。
  /// 返回传入的对象本身，方便直接赋值。
  N autoDispose<N extends ChangeNotifier>(N notifier) {
    _disposeList.add(notifier);
    return notifier;
  }

  @override
  void dispose() {
    for (final notifier in _disposeList) {
      notifier.dispose();
    }
    _disposeList.clear();
    super.dispose();
  }
}
