import 'dart:async';

/// 事件状态混入，混入到 Store 中
mixin EventStateMixin<T> {
  StreamController<T>? _eventController;

  Stream<T> get eventStream {
    _eventController ??= StreamController<T>.broadcast();
    return _eventController!.stream;
  }

  void emitEvent(T event) {
    if (_eventController?.isClosed ?? false) return;
    _eventController ??= StreamController<T>.broadcast();
    _eventController!.add(event);
  }

  void dispose() {
    _eventController?.close();
    _eventController = null;
  }
}
