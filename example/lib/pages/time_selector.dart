import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        Text("当前时间为:${initDate}"),
        PrimaryBtn(
          label: "年月日选择器",
          onPressed: () async {
            final cur = DateTime.now();
            final r = await showYearMonthDayPicker(context,
                initDate: initDate, min: DateTime.now());
            if (r != null) {
              setState(() {
                initDate = (initDate ?? cur)
                    .copyWith(year: cur.year, month: cur.month, day: cur.day);
              });
            }
          },
        ),
        PrimaryBtn(
          label: "年月日选择器",
          onPressed: () async {
            final cur = DateTime.now();

            final r = await showTimePicker24(
              context,
              initTime: TimeOfDay(
                  hour: initDate?.hour ?? cur.hour,
                  minute: initDate?.minute ?? cur.minute),
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
