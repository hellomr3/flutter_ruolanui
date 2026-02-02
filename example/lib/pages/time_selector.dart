import 'package:flutter/cupertino.dart';
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
            final r = await showYearMonthDayPicker(context,
                initDate: initDate, min: DateTime.now());
            if (r != null) {
              setState(() {
                initDate = r;
              });
            }
          },
        )
      ],
    );
  }
}
