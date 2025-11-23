import '../entities/expense.dart';

class EditExpense {
  final Future<List<Expense>> Function() getExpenses;
  final Future<void> Function(List<Expense>) saveExpenses;

  EditExpense({required this.getExpenses, required this.saveExpenses});

  Future<void> call(Expense updated) async {
    final list = await getExpenses();
    final newList = list.map((e) => e.id == updated.id ? updated : e).toList();
    await saveExpenses(newList);
  }
}
