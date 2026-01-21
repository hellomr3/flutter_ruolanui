/// 选择器项接口
/// 使用选择器的数据模型需要实现此接口
abstract class SelectorItem<ID> {
  /// 唯一标识
  ID get id;

  /// 显示名称
  String get name;

  /// 父项ID（null 表示是一级项）
  ID? get pid;
}

const itemAll = "_all";
