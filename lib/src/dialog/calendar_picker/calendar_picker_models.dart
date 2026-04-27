/// 时间段类型
enum PeriodType {
  noDate,
  today,
  period,
}

/// 时间段选项配置
class PeriodOption {
  final String label;
  final PeriodType type;
  final int years;
  final int months;
  final int days;

  const PeriodOption({
    required this.label,
    this.type = PeriodType.period,
    this.years = 0,
    this.months = 0,
    this.days = 0,
  });
}

/// 默认的时间段选项配置
class DefaultPeriodOptions {
  static const List<PeriodOption> defaultOptions = [
    PeriodOption(label: '今天', type: PeriodType.today),
    PeriodOption(label: '+1天', days: 1),
    PeriodOption(label: '+7天', days: 7),
    PeriodOption(label: '+1月', months: 1),
    PeriodOption(label: '+1年', years: 1),
  ];
}

/// 日历选择器文案配置
class CalendarPickerLabels {
  final String title;
  final String confirm;
  final String clearDate;

  const CalendarPickerLabels({
    this.title = '选择日期',
    this.confirm = '确定',
    this.clearDate = '清除日期',
  });
}
