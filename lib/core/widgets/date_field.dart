import 'package:flutter/material.dart';

import '../dates.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.date,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today_outlined),
      title: Text(label),
      trailing: Text(
        formatShortDate(date),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => _pickDate(context),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final rangeStart = firstDate ?? DateTime(now.year - 1);
    final rangeEnd = lastDate ?? DateTime(now.year + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _clamp(date, rangeStart, rangeEnd),
      firstDate: rangeStart,
      lastDate: rangeEnd,
    );
    if (picked != null) {
      onChanged(dateOnly(picked));
    }
  }

  DateTime _clamp(DateTime value, DateTime rangeStart, DateTime rangeEnd) {
    if (value.isBefore(rangeStart)) {
      return rangeStart;
    }
    if (value.isAfter(rangeEnd)) {
      return rangeEnd;
    }
    return value;
  }
}
