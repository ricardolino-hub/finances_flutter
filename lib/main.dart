import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/finance_controller.dart';
import 'presentation/pages/home_page.dart';
import 'data/datasources/local_datasource.dart';
import 'data/repositories/finance_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final local = LocalDataSourceImpl(sharedPreferences: prefs);
  final repo = FinanceRepositoryImpl(localDataSource: local);
  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final FinanceRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinanceController(repository: repository)..load(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle Financeiro',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomePage(),
      ),
    );
  }
}
