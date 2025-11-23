import '../../domain/entities/expense.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/local_datasource.dart';
import '../models/expense_model.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final LocalDataSource localDataSource;

  FinanceRepositoryImpl({required this.localDataSource});

  @override
  Future<double> getSalary() => localDataSource.getSalary();

  @override
  Future<void> setSalary(double salary) => localDataSource.setSalary(salary);

  @override
  Future<List<Expense>> getExpenses() async {
    final models = await localDataSource.getExpenses();
    return models;
  }

  @override
  Future<void> saveExpenses(List<Expense> expenses) async {
    final models = expenses
        .map((e) => ExpenseModel(id: e.id, title: e.title, amount: e.amount))
        .toList();
    await localDataSource.saveExpenses(models);
  }
}
