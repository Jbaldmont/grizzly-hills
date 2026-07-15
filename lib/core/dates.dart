String formatShortDate(DateTime date) =>
    '${date.day}/${date.month}/${date.year}';

String formatDayMonth(DateTime date) => '${date.day}/${date.month}';

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
