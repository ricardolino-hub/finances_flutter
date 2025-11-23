import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({required super.id, required super.title, required super.amount});

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }
}
