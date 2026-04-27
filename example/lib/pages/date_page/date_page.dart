import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:intl/intl.dart';
import 'package:ruolanui/ruolanui.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  DateTime? _selectedDate;
  DateTime? _pickerDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('日期选择器示例')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildResultCard(theme),
          const SizedBox(height: 24),
          _buildSectionTitle(theme, '日历选择器'),
          const SizedBox(height: 12),
          _buildCalendarBasicExample(),
          const SizedBox(height: 12),
          _buildCalendarWithRangeExample(),
          const SizedBox(height: 12),
          _buildCalendarCustomOptionsExample(),
          const SizedBox(height: 12),
          _buildCalendarNoPeriodButtonsExample(),
          const SizedBox(height: 24),
          _buildSectionTitle(theme, '年月日 / 年月选择器'),
          const SizedBox(height: 12),
          _buildYearMonthDayExample(),
          const SizedBox(height: 12),
          _buildYearMonthExample(),
          const SizedBox(height: 24),
          _buildSectionTitle(theme, '时间选择器'),
          const SizedBox(height: 12),
          _buildTimePickerExample(),
        ],
      ),
    );
  }

  // ==================== 通用 ====================

  Widget _buildResultCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('选中结果:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              _selectedDate == null
                  ? '未选择日期'
                  : DateFormat('yyyy年MM月dd日').format(_selectedDate!),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              _pickerDate == null
                  ? '未选择时间'
                  : '${_pickerDate!.hour.toString().padLeft(2, '0')}:'
                      '${_pickerDate!.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // ==================== 日历选择器 ====================

  Widget _buildCalendarBasicExample() {
    return PrimaryBtn(
      label: '基础日历选择器',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
        );
        result?.onSuccess((r) {
          if (r != null) setState(() => _selectedDate = r);
        });
      },
    );
  }

  Widget _buildCalendarWithRangeExample() {
    return PrimaryBtn(
      label: '带日期范围限制',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
          minDate: DateTime.now().subtract(const Duration(days: 30)),
          maxDate: DateTime.now().add(const Duration(days: 90)),
        );
        result?.onSuccess((r) {
          if (r != null) setState(() => _selectedDate = r);
        });
      },
    );
  }

  Widget _buildCalendarCustomOptionsExample() {
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
        result?.onSuccess((r) {
          if (r != null) setState(() => _selectedDate = r);
        });
      },
    );
  }

  Widget _buildCalendarNoPeriodButtonsExample() {
    return PrimaryBtn(
      label: '不显示快捷按钮',
      onPressed: () async {
        final result = await showRLCalendarPicker(
          context,
          initDate: _selectedDate ?? DateTime.now(),
          showPeriodButtons: false,
        );
        result?.onSuccess((r) {
          if (r != null) setState(() => _selectedDate = r);
        });
      },
    );
  }

  // ==================== 年月日 / 年月选择器 ====================

  Widget _buildYearMonthDayExample() {
    return PrimaryBtn(
      label: '年月日选择器',
      onPressed: () async {
        final result = await showRLDatePicker(
          context,
          mode: DatePickerMode.yearMonthDay,
          initDate: _selectedDate ?? DateTime.now(),
          min: DateTime.now(),
        );
        result?.onSuccess((r) {
          if (r != null) {
            setState(() {
              final cur = _selectedDate ?? DateTime.now();
              _selectedDate =
                  cur.copyWith(year: r.year, month: r.month, day: r.day);
            });
          }
        });
      },
    );
  }

  Widget _buildYearMonthExample() {
    return PrimaryBtn(
      label: '年月选择器',
      onPressed: () async {
        final result = await showRLDatePicker(
          context,
          mode: DatePickerMode.yearMonth,
          initDate: _selectedDate,
          min: DateTime.now(),
        );
        result?.onSuccess((r) {
          if (r != null) setState(() => _selectedDate = r);
        });
      },
    );
  }

  // ==================== 时间选择器 ====================

  Widget _buildTimePickerExample() {
    return PrimaryBtn(
      label: '时间选择器（时:分）',
      onPressed: () async {
        final result = await showTimePicker24(
          context,
          initTime: _pickerDate,
        );
        result?.onSuccess((r) {
          if (r != null) {
            setState(() {
              _pickerDate = r;
            });
          }
        });
      },
    );
  }
}
