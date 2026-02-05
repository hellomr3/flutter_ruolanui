import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ruolanui/src/widgets/bottom_sheet_header.dart';

/// 时间选择器模式
enum TimePickerMode {
  /// 时分
  hourMinute,
  /// 时分秒
  hourMinuteSecond,
}

/// 时间选择器文案配置
class TimePickerLabels {
  final String title;
  final String cancel;
  final String confirm;

  const TimePickerLabels({
    this.title = '选择时间',
    this.cancel = '取消',
    this.confirm = '确定',
  });
}

/// 时间格式化函数类型
typedef TimeFormatter = String Function(int value);

/// 默认时间格式化
String _defaultHourFormatter(int hour) => '$hour时';

String _defaultMinuteFormatter(int minute) => '$minute分';

String _defaultSecondFormatter(int second) => '$second秒';

/// 时间选择器主题配置
class TimePickerTheme {
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? highlightColor;
  final double itemHeight;
  final int visibleItemCount;
  final TimeFormatter? hourFormatter;
  final TimeFormatter? minuteFormatter;
  final TimeFormatter? secondFormatter;

  const TimePickerTheme({
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.highlightColor,
    this.itemHeight = 44,
    this.visibleItemCount = 5,
    this.hourFormatter,
    this.minuteFormatter,
    this.secondFormatter,
  });
}

/// 弹出时间选择器
Future<DateTime?> showTimePicker24(
  BuildContext context, {
  DateTime? initTime,
  TimePickerMode mode = TimePickerMode.hourMinute,
  TimePickerLabels? labels,
  TimePickerTheme? theme,
}) async {
  final pickerLabels = labels ?? const TimePickerLabels();
  final pickerTheme = theme ?? const TimePickerTheme();
  DateTime? selectedTime;

  return showModalBottomSheet<DateTime>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      final textTheme = Theme.of(context).textTheme;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          BottomSheetHeader(
            cancelText: pickerLabels.cancel,
            titleText: pickerLabels.title,
            confirmText: pickerLabels.confirm,
            onRightPressed: () => Navigator.pop(context, selectedTime),
          ),
          // 选择器
          TimePickerWidget(
            mode: mode,
            initTime: initTime,
            showSecond: mode == TimePickerMode.hourMinuteSecond,
            itemExtend: pickerTheme.itemHeight,
            itemCount: pickerTheme.visibleItemCount,
            selectedTextStyle: pickerTheme.selectedTextStyle,
            unselectedTextStyle: pickerTheme.unselectedTextStyle,
            highlightColor: pickerTheme.highlightColor,
            hourFormatter: pickerTheme.hourFormatter,
            minuteFormatter: pickerTheme.minuteFormatter,
            secondFormatter: pickerTheme.secondFormatter,
            onChanged: (time) {
              selectedTime = time;
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      );
    },
  );
}

class TimePickerWidget extends StatefulWidget {
  final TimePickerMode mode;
  final DateTime? initTime;
  final bool showSecond;
  final double itemExtend;
  final int itemCount;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? highlightColor;
  final TimeFormatter? hourFormatter;
  final TimeFormatter? minuteFormatter;
  final TimeFormatter? secondFormatter;
  final ValueChanged<DateTime>? onChanged;

  const TimePickerWidget({
    super.key,
    this.mode = TimePickerMode.hourMinute,
    this.initTime,
    this.showSecond = false,
    this.itemExtend = 44,
    this.itemCount = 5,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.highlightColor,
    this.hourFormatter,
    this.minuteFormatter,
    this.secondFormatter,
    this.onChanged,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late int selectedHour;
  late int selectedMinute;
  late int selectedSecond;

  @override
  void initState() {
    super.initState();
    final init = widget.initTime ?? DateTime.now();
    selectedHour = init.hour;
    selectedMinute = init.minute;
    selectedSecond = init.second;
    _notifyChange();
  }

  void _notifyChange() {
    final now = DateTime.now();
    widget.onChanged?.call(
      DateTime(now.year, now.month, now.day, selectedHour, selectedMinute, selectedSecond),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedStyle = widget.selectedTextStyle ?? textTheme.titleMedium;
    final unselectedStyle = widget.unselectedTextStyle ?? textTheme.bodyMedium;
    final highlightColor =
        widget.highlightColor ?? colorScheme.onSurface.withValues(alpha: 0.1);
    final hourFormatter = widget.hourFormatter ?? _defaultHourFormatter;
    final minuteFormatter = widget.minuteFormatter ?? _defaultMinuteFormatter;
    final secondFormatter = widget.secondFormatter ?? _defaultSecondFormatter;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: SizedBox(
        height: widget.itemExtend * 5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                // 时
                Expanded(
                  child: NumberPicker(
                    value: selectedHour,
                    minValue: 0,
                    maxValue: 23,
                    itemHeight: widget.itemExtend,
                    itemCount: widget.itemCount,
                    selectedTextStyle: selectedStyle,
                    textStyle: unselectedStyle,
                    haptics: true,
                    onChanged: (v) {
                      setState(() {
                        selectedHour = v;
                        _notifyChange();
                      });
                    },
                    textMapper: (i) => hourFormatter(int.parse(i)),
                  ),
                ),
                // 分
                Expanded(
                  child: NumberPicker(
                    value: selectedMinute,
                    minValue: 0,
                    maxValue: 59,
                    itemHeight: widget.itemExtend,
                    itemCount: widget.itemCount,
                    selectedTextStyle: selectedStyle,
                    textStyle: unselectedStyle,
                    haptics: true,
                    onChanged: (v) {
                      setState(() {
                        selectedMinute = v;
                        _notifyChange();
                      });
                    },
                    textMapper: (i) => minuteFormatter(int.parse(i)),
                  ),
                ),
                // 秒
                if (widget.showSecond)
                  Expanded(
                    child: NumberPicker(
                      value: selectedSecond,
                      minValue: 0,
                      maxValue: 59,
                      itemHeight: widget.itemExtend,
                      itemCount: widget.itemCount,
                      selectedTextStyle: selectedStyle,
                      textStyle: unselectedStyle,
                      haptics: true,
                      onChanged: (v) {
                        setState(() {
                          selectedSecond = v;
                          _notifyChange();
                        });
                      },
                      textMapper: (i) => secondFormatter(int.parse(i)),
                    ),
                  ),
              ],
            ),
            // 选中框遮罩
            IgnorePointer(
              child: Container(
                height: widget.itemExtend,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
