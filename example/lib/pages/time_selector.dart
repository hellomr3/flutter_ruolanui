import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:ruolanui/ruolanui.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({super.key});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  DateTime? initDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("当前时间为:${initDate?.year}/${initDate?.month}/${initDate?.day}"),
        PrimaryBtn(
          label: "年月日选择器",
          onPressed: () async {
            final cur = DateTime.now();
            final r = await showRLDatePicker(context,
                mode: DatePickerMode.yearMonthDay,
                initDate: initDate,
                min: DateTime.now());
            if (r != null) {
              setState(() {
                initDate = (initDate ?? cur)
                    .copyWith(year: cur.year, month: cur.month, day: cur.day);
              });
            }
          },
        ),
        PrimaryBtn(
          label: "年月选择器",
          onPressed: () async {
            final cur = DateTime.now();
            final r = await showRLDatePicker(context,
                mode: DatePickerMode.yearMonth,
                initDate: initDate,
                min: DateTime.now());
            if (r != null) {
              setState(() {
                initDate = (initDate ?? cur)
                    .copyWith(year: cur.year, month: cur.month, day: cur.day);
              });
            }
          },
        ),
        Text("当前时间为:${initDate?.hour}:${initDate?.minute}:${initDate?.second}"),
        PrimaryBtn(
          label: "时间选择器",
          onPressed: () async {
            final cur = DateTime.now();

            final r = await showTimePicker24(
              context,
              initTime: initDate,
            );
            if (r != null) {
              setState(() {
                initDate =
                    (initDate ?? cur).copyWith(hour: r.hour, minute: r.minute);
              });
            }
          },
        ),
      ],
    );
  }
}
