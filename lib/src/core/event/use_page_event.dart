import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 用于监听页面事件的hook
/// [T] 事件类型
/// [onEvent] 事件处理回调
/// [eventStream] 事件流
void usePageEvent<T>(
    Stream<T> eventStream,
    void Function(T event) onEvent, {
      List<Object?>? keys,
    }) {
  useEffect(() {
    final subscription = eventStream.listen(onEvent);
    return subscription.cancel;
  }, keys ?? []);
}