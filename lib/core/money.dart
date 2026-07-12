import 'package:intl/intl.dart';
import 'strings.dart';

final NumberFormat _bsFormat = NumberFormat('#,##0.##', 'es');

String formatBs(int cents) =>
    '${Strings.currency} ${_bsFormat.format(cents / 100)}';

String centsToEditableText(int cents) {
  if (cents % 100 == 0) {
    return (cents ~/ 100).toString();
  }
  return (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
}

int? parseBsToCents(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  if (normalized.isEmpty) {
    return null;
  }
  final value = double.tryParse(normalized);
  if (value == null || value < 0) {
    return null;
  }
  return (value * 100).round();
}
