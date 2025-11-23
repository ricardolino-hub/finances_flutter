import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/domain/usecases/get_finance_summary.dart';
import 'package:finance_app/domain/entities/expense.dart';

void main() {
  test('FinanceSummary calculates totalExpenses and percentageUsed', () async {
    Future<double> getSalary() async => 2000.0;
    Future<List<Expense>> getExpenses() async => [
          Expense(id: '1', title: 'Aluguel', amount: 800.0),
          Expense(id: '2', title: 'Supermercado', amount: 200.0),
        ];

    final usecase = GetFinanceSummary(getSalary: getSalary, getExpenses: getExpenses);
    final summary = await usecase();

    expect(summary.salary, 2000.0);
    expect(summary.totalExpenses, 1000.0);
    expect(summary.percentageUsed, 0.5);
  });

  test('percentageUsed is zero when salary <= 0', () async {
    final usecase = GetFinanceSummary(getSalary: () async => 0.0, getExpenses: () async => []);
    final summary = await usecase();
    expect(summary.percentageUsed, 0.0);
  });
}
