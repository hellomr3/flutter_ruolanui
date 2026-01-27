import 'dart:async';

class UiEventBus<E> {
  final _ctrl = StreamController<E>.broadcast();

  Stream<E> get stream => _ctrl.stream;

  void emit(E event) {
    if (!_ctrl.isClosed) {
      _ctrl.add(event);
    }
  }

  void dispose() {
    _ctrl.close();
  }
}
