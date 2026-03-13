import 'package:intl/intl.dart';

enum CurrencyStyle { symbol, code }

extension AmountExtension on num {
  String toAmount({CurrencyStyle style = CurrencyStyle.symbol}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final currency = style == CurrencyStyle.symbol ? '₦' : 'NGN ';
    return '$currency${formatter.format(this)}';
  }
}
