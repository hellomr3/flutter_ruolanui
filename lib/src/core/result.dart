// lib/core/result.dart
class Result<T> {
  final T? data;
  final String? msg;
  final int code;

  Result._({this.data, this.msg, required this.code});

  factory Result.success(T? data) => Result._(data: data, code: 0);

  factory Result.failure(String? error, {int? code = -1}) =>
      Result._(msg: error, code: code ?? -1);

  bool get isSuccess => code == 0;

  bool get isFailure => msg != null || code != 0;

  @override
  String toString() {
    return "Result.${isSuccess ? "ok" : "error"}:{data:${data},code:${code},msg:${msg}";
  }
}

extension ResultExtension<T> on Result<T> {
  /// 处理成功的情况
  /// 当 Result 为成功状态时，执行传入的回调函数
  /// 返回 Result 本身，支持链式调用
  Result<T> onSuccess(void Function(T? data) action) {
    if (isSuccess) {
      action(data);
    }
    return this;
  }

  /// 处理失败的情况
  /// 当 Result 为失败状态时，执行传入的回调函数
  /// 返回 Result 本身，支持链式调用
  Result<T?> onError(void Function(String? message, int code) action) {
    if (isFailure) {
      action(msg, code);
    }
    return this;
  }

  /// 将 Result.success 的 data 进行转换
  /// 返回一个新的 Result 对象，包含转换后的数据
  /// 如果当前 Result 是失败状态，则直接返回当前 Result
  Result<R> map<R>(R Function(T? data) transform) {
    if (isSuccess) {
      return Result.success(transform(data));
    }
    return Result.failure(msg, code: code);
  }
}
