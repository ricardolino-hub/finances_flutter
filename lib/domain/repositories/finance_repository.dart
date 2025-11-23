import '../entities/expense.dart';

abstract class FinanceRepository {
  Future<double> getSalary();
  Future<void> setSalary(double salary);

  Future<List<Expense>> getExpenses();
  Future<void> saveExpenses(List<Expense> expenses);
}
