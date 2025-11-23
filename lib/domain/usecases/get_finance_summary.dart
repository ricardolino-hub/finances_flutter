import '../entities/expense.dart';

class FinanceSummary {
  final double salary;
  final List<Expense> expenses;

  FinanceSummary({required this.salary, required this.expenses});

  double get totalExpenses => expenses.fold(0.0, (p, e) => p + e.amount);

  double get percentageUsed {
    if (salary <= 0) return 0;
    return (totalExpenses / salary).clamp(0.0, double.infinity);
  }
}

class GetFinanceSummary {
  final Future<double> Function() getSalary;
  final Future<List<Expense>> Function() getExpenses;

  GetFinanceSummary({required this.getSalary, required this.getExpenses});

  Future<FinanceSummary> call() async {
    final salary = await getSalary();
    final expenses = await getExpenses();
    return FinanceSummary(salary: salary, expenses: expenses);
  }
}
