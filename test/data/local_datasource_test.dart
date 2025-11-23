import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_app/data/datasources/local_datasource.dart';
import 'package:finance_app/data/models/expense_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalDataSource', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({}); // clean
    });

    test('save and get salary', () async {
      final prefs = await SharedPreferences.getInstance();
      final ds = LocalDataSourceImpl(sharedPreferences: prefs);
      await ds.setSalary(1500.5);
      final salary = await ds.getSalary();
      expect(salary, 1500.5);
    });

    test('save and get expenses', () async {
      final prefs = await SharedPreferences.getInstance();
      final ds = LocalDataSourceImpl(sharedPreferences: prefs);

      final list = [
        ExpenseModel(id: '1', title: 'X', amount: 10.0),
        ExpenseModel(id: '2', title: 'Y', amount: 20.0),
      ];
      await ds.saveExpenses(list);
      final fromDs = await ds.getExpenses();
      expect(fromDs.length, 2);
      expect(fromDs[0].title, 'X');
      expect(fromDs[1].amount, 20.0);
    });
  });
}
