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
            final result = await showRLDatePicker(context,
                mode: DatePickerMode.yearMonthDay,
                initDate: initDate ?? DateTime.now(),
                min: DateTime.now());
            result?.onSuccess((r) {
              if (r != null) {
                print('选择时间为B$r');
                setState(() {
                  initDate = (initDate ?? cur)
                      .copyWith(year: r.year, month: r.month, day: r.day);
                  print('initDate$initDate');
                });
              }
            });
          },
        ),
        PrimaryBtn(
          label: "年月选择器",
          onPressed: () async {
            final result = await showRLDatePicker(context,
                mode: DatePickerMode.yearMonth,
                initDate: initDate,
                min: DateTime.now());
            result?.onSuccess((r) {
              if (r != null) {
                setState(() {
                  initDate = r;
                });
              }
            });
          },
        ),
        Text("当前时间为:${initDate?.hour}:${initDate?.minute}:${initDate?.second}"),
        PrimaryBtn(
          label: "时间选择器",
          onPressed: () async {
            final cur = DateTime.now();

            final result = await showTimePicker24(
              context,
              initTime: initDate,
            );
            result?.onSuccess((r) {
              if (r != null) {
                setState(() {
                  initDate = (initDate ?? cur)
                      .copyWith(hour: r.hour, minute: r.minute);
                });
              }
            });
          },
        ),
      ],
    );
  }
}
