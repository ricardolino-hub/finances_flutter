import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

abstract class LocalDataSource {
  Future<double> getSalary();
  Future<void> setSalary(double salary);

  Future<List<ExpenseModel>> getExpenses();
  Future<void> saveExpenses(List<ExpenseModel> expenses);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _salaryKey = 'salary';
  static const _expensesKey = 'expenses';

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<double> getSalary() async {
    final val = sharedPreferences.getDouble(_salaryKey);
    return val ?? 0.0;
  }

  @override
  Future<void> setSalary(double salary) async {
    await sharedPreferences.setDouble(_salaryKey, salary);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final jsonString = sharedPreferences.getString(_expensesKey);
    if (jsonString == null) return [];
    final List decoded = json.decode(jsonString) as List;
    return decoded.map((e) => ExpenseModel.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<void> saveExpenses(List<ExpenseModel> expenses) async {
    final list = expenses.map((e) => e.toMap()).toList();
    final jsonString = json.encode(list);
    await sharedPreferences.setString(_expensesKey, jsonString);
  }
}
