import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/currency_formatter.dart';

class MoneyInputDialog {
  static Future<double?> show(BuildContext context, {required double initialValue}) async {
    final ctrl = TextEditingController(text: formatCurrency(initialValue));
    return showDialog<double>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar salário'),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
            decoration: const InputDecoration(prefixText: 'R\$ '),
            onChanged: (v) {},
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () {
                  final parsed = parseCurrency(ctrl.text);
                  Navigator.of(ctx).pop(parsed);
                },
                child: const Text('Salvar')),
          ],
        );
      },
    );
  }

  static Future<Map<String, dynamic>?> showExpenseDialog(BuildContext context,
      {String title = '', double amount = 0.0}) {
    final titleCtrl = TextEditingController(text: title);
    final amountCtrl = TextEditingController(text: formatCurrency(amount));
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () {
                  final parsed = parseCurrency(amountCtrl.text);
                  Navigator.of(ctx).pop({'title': titleCtrl.text.trim(), 'amount': parsed});
                },
                child: const Text('Salvar')),
          ],
        );
      },
    );
  }
}
