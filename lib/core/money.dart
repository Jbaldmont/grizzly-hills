import 'package:intl/intl.dart';
import 'strings.dart';

final NumberFormat _bsFormat = NumberFormat('#,##0.##', 'es');

final RegExp _amountPattern = RegExp(r'^\d+([.,]\d{1,2})?$');

String formatBs(int cents) =>
    '${Strings.currency} ${_bsFormat.format(cents / 100)}';

String centsToEditableText(int cents) {
  if (cents % 100 == 0) {
    return (cents ~/ 100).toString();
  }
  return (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
}

int? parseBsToCents(String input) {
  final normalized = input.trim();
  if (!_amountPattern.hasMatch(normalized)) {
    return null;
  }
  final value = double.parse(normalized.replaceAll(',', '.'));
  return (value * 100).round();
}

String formatPercent(double percent) {
  final rounded = (percent * 100).round() / 100;
  if (rounded == rounded.roundToDouble()) {
    return '${rounded.round()}%';
  }
  final text = rounded
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll('.', ',');
  return '$text%';
}

int? parseWholePercent(String input) {
  return int.tryParse(input.trim());
}
