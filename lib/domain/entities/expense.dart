class Expense {
  final String id;
  final String title;
  final double amount;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
  });

  Expense copyWith({String? title, double? amount}) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
    );
  }
}
