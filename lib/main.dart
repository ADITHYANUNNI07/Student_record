import 'package:flutter/material.dart';
import 'package:week_05_db/Screen/addstudent.dart';
import 'package:week_05_db/database/databasesqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.yellow,
          appBarTheme: AppBarTheme(color: Colors.yellow)),
      home: AddStudent(),
    );
  }
}
