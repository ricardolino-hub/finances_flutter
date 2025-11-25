import 'package:intl/intl.dart';

final _brCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: '');

String formatCurrency(double value) {
  return _brCurrency.format(value);
}

double parseCurrency(String input) {
  final only = input.replaceAll(RegExp(r'[^0-9,\.]'), '');
  if (only.isEmpty) return 0.0;
  if (only.contains(',') && only.contains('.')) {
    final normalized = only.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  } else if (only.contains(',')) {
    final normalized = only.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  } else {
    return double.tryParse(only) ?? 0.0;
  }
}
