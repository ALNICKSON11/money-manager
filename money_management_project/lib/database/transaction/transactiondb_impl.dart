import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/database/transaction/transactiondb_functions.dart';
import 'package:money_management_project/models/category/category_type.dart';
import 'package:money_management_project/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-database';
class TransactionDb implements TransactiondbFunctions{

    TransactionDb.internal();

    static TransactionDb instance = TransactionDb.internal();

    factory TransactionDb(){
      return instance;
    }

  ValueNotifier<List<TransactionModel>> transactionModelList = ValueNotifier([]);
  ValueNotifier<double> currrentMonthSpendNotifier = ValueNotifier(0.0);
  ValueNotifier<double> currentWeekNotifier = ValueNotifier(0.0);
  ValueNotifier<double> todayNotifier = ValueNotifier(0.0);

  final startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  final endOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(const Duration(days: 7));
  final startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-1);
  final endOfDay =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1));
  final startOfCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month).subtract(const Duration(milliseconds: 1));

    Future<void> refreshTransationUI() async{
    final allTransactions = await getTransactions();
    allTransactions.sort((first, second)=>second.date.compareTo(first.date));
    transactionModelList.value.clear();
    transactionModelList.value.addAll(allTransactions);
    transactionModelList.notifyListeners();
    currentMonthSpendings(allTransactions);
    thisWeekSpendings(allTransactions);
    currentDaySpending(allTransactions);
  }

  @override
  Future<void> addTransactions(TransactionModel transactionModel) async{
    final transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionDB.put(transactionModel.id, transactionModel);
    await refreshTransationUI();
  }
  
  @override
  Future<List<TransactionModel>> getTransactions() async{
    final transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionDb.values.toList();
  }
  
  @override
  Future<void> deleteTransaction(String id) async{
    final transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionDb.delete(id);
    await refreshTransationUI();
  }

  Future<void> currentMonthSpendings(List<TransactionModel> allTransactions) async{
      currrentMonthSpendNotifier.value = 0.0;
      for(var transactionModel in allTransactions){
      if(transactionModel.type == CategoryType.expense){
        if(transactionModel.date.isAfter(startOfCurrentMonth) && transactionModel.date.isBefore(DateTime.now().add(const Duration(days: 1)))){
           currrentMonthSpendNotifier.value += transactionModel.amount;
        } 
      }
    }
    currrentMonthSpendNotifier.notifyListeners();
  }

  Future<void> thisWeekSpendings(List<TransactionModel> allTransactions) async{
    currentWeekNotifier.value = 0.0;

    for(var transactionModel in allTransactions){
      if(transactionModel.type == CategoryType.expense){
        if(transactionModel.date.isAfter(startOfWeek) && transactionModel.date.isBefore(endOfWeek)){
          currentWeekNotifier.value += transactionModel.amount;
        }
      }
    }
    currentWeekNotifier.notifyListeners();
  }

  Future<void> currentDaySpending(List<TransactionModel> allTransactions) async{
    todayNotifier.value = 0.0;

    for(var transactionModel in allTransactions){
      if(transactionModel.type == CategoryType.expense){
        if(transactionModel.date.isAfter(startOfDay) && transactionModel.date.isBefore(endOfDay)){
          todayNotifier.value += transactionModel.amount;
        }
      }
    }
    todayNotifier.notifyListeners();
  }
}