import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruolanui/ruolanui.dart';

class CalendarSelectorExample extends StatefulWidget {
  const CalendarSelectorExample({super.key});

  @override
  State<CalendarSelectorExample> createState() => _CalendarSelectorExampleState();
}

class _CalendarSelectorExampleState extends State<CalendarSelectorExample> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日历选择器示例')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildResultCard(),
          const SizedBox(height: 16),
          _buildBasicExample(),
          const SizedBox(height: 16),
          _buildWithRangeExample(),
          const SizedBox(height: 16),
          _buildCustomOptionsExample(),
          const SizedBox(height: 16),
          _buildNoPeriodButtonsExample(),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('选中的日期:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              _selectedDate == null
                  ? '未选择'
                  : DateFormat('yyyy年MM月dd日').format(_selectedDate!),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicExample() {
    return PrimaryBtn(
      label: '基础日历选择器',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
        );
        if (result != null) {
          setState(() => _selectedDate = result);
        }
      },
    );
  }

  Widget _buildWithRangeExample() {
    return PrimaryBtn(
      label: '带日期范围限制',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
          minDate: DateTime.now().subtract(const Duration(days: 30)),
          maxDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (result != null) {
          setState(() => _selectedDate = result);
        }
      },
    );
  }

  Widget _buildCustomOptionsExample() {
    return PrimaryBtn(
      label: '自定义快捷选项',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
          periodOptions: const [
            PeriodOption(label: '今天', type: PeriodType.today),
            PeriodOption(label: '+3天', days: 3),
            PeriodOption(label: '+2周', days: 14),
            PeriodOption(label: '+3月', months: 3),
            PeriodOption(label: '+6月', months: 6),
          ],
        );
        if (result != null) {
          setState(() => _selectedDate = result);
        }
      },
    );
  }

  Widget _buildNoPeriodButtonsExample() {
    return PrimaryBtn(
      label: '不显示快捷按钮',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
          showPeriodButtons: false,
        );
        if (result != null) {
          setState(() => _selectedDate = result);
        }
      },
    );
  }
}
