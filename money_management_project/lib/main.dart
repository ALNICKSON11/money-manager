import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/models/balance/balance_model.dart';
import 'package:money_management_project/models/category/category_model.dart';
import 'package:money_management_project/models/category/category_type.dart';
import 'package:money_management_project/models/depts/dept_type.dart';
import 'package:money_management_project/models/depts/depts_model.dart';
import 'package:money_management_project/models/notes/notes_model.dart';
import 'package:money_management_project/models/transaction/transaction_model.dart';
import 'package:money_management_project/screens/add_transaction/add_transaction.dart';
import 'package:money_management_project/screens/home/screen_home.dart';
import 'package:money_management_project/screens/splash/screen_splash.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
    Hive.registerAdapter(TransactionModelAdapter());
  }

  if(!Hive.isAdapterRegistered(DeptModelAdapter().typeId)){
    Hive.registerAdapter(DeptModelAdapter());
  }

  if(!Hive.isAdapterRegistered(DeptTypeAdapter().typeId)){
    Hive.registerAdapter(DeptTypeAdapter());
  }

  if(!Hive.isAdapterRegistered(NotesModelAdapter().typeId)){
    Hive.registerAdapter(NotesModelAdapter());
  }

  if(!Hive.isAdapterRegistered(BalanceModelAdapter().typeId)){
    Hive.registerAdapter(BalanceModelAdapter());
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.white,
      ),
      home: const ScreenSplash(),
      routes: {
        AddTransaction.routeName:(ctx)=> const AddTransaction()
      },
    );
  }
}
