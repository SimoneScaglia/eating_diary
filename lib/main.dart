import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app_1/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'models/diary_data.dart';
import 'screens/homepage_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  Utils.db = await DiaryData().OpenDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diario Alimentare',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F5F5)),
      ),
      home: const HomePage(),
    );
  }
}
