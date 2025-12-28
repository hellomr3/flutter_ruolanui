import 'dart:async';

import 'package:flutter/widgets.dart';

import 'event_state_mixin.dart';

mixin EventHandlerMixin<T extends StatefulWidget, E> on State<T> {
  StreamSubscription<E>? _eventSubscription;

  EventStateMixin<E> get vm;

  /// 事件处理方法，子类必须实现
  FutureOr<void> onEvent(E event);

  @override
  void initState() {
    super.initState();
    _setupEventListener();
  }

  void _setupEventListener() {
    _eventSubscription = vm.eventStream.listen(
      onEvent,
      onError: (error) {
        // 可以在这里添加全局错误处理逻辑
      },
    );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    vm.dispose();
    super.dispose();
  }
}
