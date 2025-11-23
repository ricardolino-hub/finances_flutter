import 'package:finance_app/domain/entities/expense.dart';

class AddExpense {
  final Future<List<Expense>> Function() getExpenses;
  final Future<void> Function(List<Expense>) saveExpenses;

  AddExpense({required this.getExpenses, required this.saveExpenses});

  Future<void> call(Expense expense) async {
    final list = await getExpenses();
    final newList = [...list, expense];
    await saveExpenses(newList);
  }
}
