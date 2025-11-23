import '../entities/expense.dart';

class DeleteExpense {
  final Future<List<Expense>> Function() getExpenses;
  final Future<void> Function(List<Expense>) saveExpenses;

  DeleteExpense({required this.getExpenses, required this.saveExpenses});

  Future<void> call(String id) async {
    final list = await getExpenses();
    final newList = list.where((e) => e.id != id).toList();
    await saveExpenses(newList);
  }
}
