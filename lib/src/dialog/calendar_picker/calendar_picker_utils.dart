import 'calendar_picker_models.dart';

/// 根据 PeriodOption 添加时间
DateTime addPeriod(DateTime date, PeriodOption option) {
  DateTime result = date;
  if (option.days != 0) {
    result = result.add(Duration(days: option.days));
  }
  if (option.months != 0) {
    result = addMonths(result, option.months);
  }
  if (option.years != 0) {
    result = addMonths(result, option.years * 12);
  }
  return result;
}

/// 安全地给日期添加月份
DateTime addMonths(DateTime date, int months) {
  int newYear = date.year;
  int newMonth = date.month + months;

  while (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }
  while (newMonth < 1) {
    newYear--;
    newMonth += 12;
  }

  newYear = newYear.clamp(1, 9999);

  int newDay = date.day;
  int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  if (newDay > daysInNewMonth) {
    newDay = daysInNewMonth;
  }

  return DateTime(newYear, newMonth, newDay, date.hour, date.minute,
      date.second, date.millisecond, date.microsecond);
}
