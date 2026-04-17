import 'dart:async';

import 'package:flutter/widgets.dart';

/// 自动 dispose mixin，用于管理需要在 State dispose 时清理的资源。
///
/// 使用 [autoDispose] 方法注册任意 [ChangeNotifier] 子类（如 FocusNode、
/// TextEditingController、ObservableTextController 等），
/// 使用 [autoCancel] 方法注册 [StreamSubscription]，
/// 在 State dispose 时自动清理。
///
/// ```dart
/// class _MyPageState extends State<MyPage>
///     with AutoDisposeMixin {
///   late final FocusNode _focusNode = autoDispose(FocusNode());
///   late final ObservableTextController _controller = autoDispose(
///     ObservableTextController(...),
///   );
///   late final StreamSubscription _sub = autoCancel(someStream.listen(...));
/// }
/// ```
mixin AutoDisposeMixin<T extends StatefulWidget> on State<T> {
  final List<ChangeNotifier> _disposeList = [];
  final List<StreamSubscription> _streamList = [];

  /// 注册一个 [ChangeNotifier]，在 State dispose 时自动 dispose。
  /// 返回传入的对象本身，方便直接赋值。
  N autoDispose<N extends ChangeNotifier>(N notifier) {
    _disposeList.add(notifier);
    return notifier;
  }

  /// 注册一个 [StreamSubscription]，在 State dispose 时自动 cancel。
  /// 返回传入的对象本身，方便直接赋值。
  S autoCancel<S extends StreamSubscription>(S subscription) {
    _streamList.add(subscription);
    return subscription;
  }

  @override
  void dispose() {
    for (final notifier in _disposeList) {
      notifier.dispose();
    }
    _disposeList.clear();
    for (final sub in _streamList) {
      sub.cancel();
    }
    _streamList.clear();
    super.dispose();
  }
}
