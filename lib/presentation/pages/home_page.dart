import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/money_input_dialog.dart';
import '../controllers/finance_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Color _colorForPercent(double percent) {
    if (percent <= 0) return Colors.grey;
    if (percent <= 1.0) return Colors.green;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
        centerTitle: true,
      ),
      body: Consumer<FinanceController>(
        builder: (context, ctrl, _) {
          final salary = ctrl.salary;
          final totalExpenses = ctrl.expenses.fold(0.0, (p, e) => p + e.amount);
          final percent = (salary <= 0) ? 0.0 : (totalExpenses / salary);
          final color = _colorForPercent(percent);
          final remaining = salary - totalExpenses;
          final showSalary = ctrl.showSalary;

          return Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: CircleProgressPainter(
                            percent: percent.clamp(0.0, 1.0),
                            color: color,
                            emptyColor: Colors.grey.shade300,
                          ),
                        ),
                        _BlurIfNeeded(
                          enabled: !showSalary,
                          child: GestureDetector(
                            onTap: () async {
                              final newSalary = await MoneyInputDialog.show(context, initialValue: salary);
                              if (newSalary != null) {
                                await ctrl.setSalary(newSalary);
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatCurrency(remaining),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(formatCurrency(salary), style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 60,
                          child: Transform.scale(
                            scale: 0.7, // ➜ tamanho reduzido
                            child: Switch(
                              value: showSalary,
                              onChanged: ctrl.toggleShowSalary,
                              activeThumbColor: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gastos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ctrl.expenses.isEmpty
                            ? const Center(child: Text('Nenhum gasto registrado'))
                            : ListView.builder(
                                itemCount: ctrl.expenses.length,
                                itemBuilder: (context, idx) {
                                  final e = ctrl.expenses[idx];
                                  return Dismissible(
                                    key: Key(e.id),
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 16),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.blue,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 16),
                                      child: const Icon(Icons.edit, color: Colors.white),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (direction == DismissDirection.startToEnd) {
                                        final ok = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('Excluir gasto'),
                                            content: const Text('Deseja excluir esse gasto?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Não')),
                                              ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sim')),
                                            ],
                                          ),
                                        );
                                        if (ok == true) {
                                          await ctrl.deleteExpense(e.id);
                                          return true;
                                        }
                                        return false;
                                      } else {
                                        final res = await MoneyInputDialog.showExpenseDialog(context, title: e.title, amount: e.amount);
                                        if (res != null) {
                                          final newTitle = res['title'] as String;
                                          final newAmount = res['amount'] as double;
                                          await ctrl.editExpense(e.id, newTitle, newAmount);
                                        }
                                        return false;
                                      }
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text(e.title),
                                        trailing: Text(formatCurrency(e.amount)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<FinanceController>(builder: (context, ctrl, _) {
        return FloatingActionButton(
          onPressed: () async {
            final res = await MoneyInputDialog.showExpenseDialog(context);
            if (res != null) {
              final title = res['title'] as String;
              final amount = res['amount'] as double;
              if (title.isNotEmpty) {
                await ctrl.addExpense(title, amount);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Título obrigatório')));
              }
            }
          },
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color emptyColor;

  CircleProgressPainter({required this.percent, required this.color, required this.emptyColor});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.08;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = emptyColor
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweep = 2 * 3.141592653589793 * percent;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final start = -3.141592653589793 / 2;

    if (percent > 0) {
      canvas.drawArc(rect, start, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircleProgressPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color || oldDelegate.emptyColor != emptyColor;
  }
}

class _BlurIfNeeded extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const _BlurIfNeeded({required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: child,
      ),
    );
  }
}
