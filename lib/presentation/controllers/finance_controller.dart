import 'package:finance_app/domain/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/edit_expense.dart';
import '../../domain/usecases/get_finance_summary.dart';
import '../../domain/repositories/finance_repository.dart';

class FinanceController extends ChangeNotifier {
  final FinanceRepository repository;
  final uuid = const Uuid();

  double salary = 0.0;
  List<Expense> expenses = [];
  bool loading = false;

  FinanceController({required this.repository});

  Future<void> load() async {
    loading = true;
    notifyListeners();
    salary = await repository.getSalary();
    expenses = await repository.getExpenses();
    loading = false;
    notifyListeners();
  }

  Future<void> setSalary(double newSalary) async {
    salary = newSalary;
    await repository.setSalary(newSalary);
    notifyListeners();
  }

  Future<void> addExpense(String title, double amount) async {
    final exp = Expense(id: uuid.v4(), title: title, amount: amount);
    final usecase = AddExpense(
      getExpenses: repository.getExpenses,
      saveExpenses: repository.saveExpenses,
    );
    await usecase(exp);
    await load();
  }

  Future<void> deleteExpense(String id) async {
    final usecase = DeleteExpense(getExpenses: repository.getExpenses, saveExpenses: repository.saveExpenses);
    await usecase(id);
    await load();
  }

  Future<void> editExpense(String id, String title, double amount) async {
    final updated = Expense(id: id, title: title, amount: amount);
    final usecase = EditExpense(getExpenses: repository.getExpenses, saveExpenses: repository.saveExpenses);
    await usecase(updated);
    await load();
  }

  Future<FinanceSummary> getSummary() async {
    final usecase = GetFinanceSummary(getSalary: repository.getSalary, getExpenses: repository.getExpenses);
    return await usecase();
  }
}
