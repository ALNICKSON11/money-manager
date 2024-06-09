import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/database/balance/balancedb_functions.dart';
import 'package:money_management_project/models/balance/balance_model.dart';

const String balanceDatabase = 'balance-database';

class BalanceDb implements BalancedbFunctions {
  BalanceDb.internal();

  static BalanceDb instance = BalanceDb.internal();

  factory BalanceDb() {
    return instance;
  }

  ValueNotifier<double> updateBalanceNotifier = ValueNotifier(0);

  @override
  Future<void> addBalance(double amount) async {
    final balanceDb = await Hive.openBox<BalanceModel>(balanceDatabase);
    final currentBalance = await getBalance();
    final balanceModel = BalanceModel(balance: currentBalance + amount);
    balanceDb.put(123, balanceModel);
    await refreshBalance();
  }

  @override
  Future<double> getBalance() async {
    final balanceDb = await Hive.openBox<BalanceModel>(balanceDatabase);
    if (balanceDb.isEmpty) {
      return 0.0;
    }
    final balanceModel = balanceDb.values.first;
    return balanceModel.balance;
  }

  @override
  Future<void> substractBalance(double amount) async {
    final balanceDb = await Hive.openBox<BalanceModel>(balanceDatabase);
    final currentBalance = await getBalance();
    final balanceModel = BalanceModel(balance: currentBalance - amount);
    balanceDb.put(123, balanceModel);
    await refreshBalance();
  }

  Future<void> refreshBalance() async {
    final balance = await getBalance();
    updateBalanceNotifier.value = balance;
    updateBalanceNotifier.notifyListeners();
  }
  
  @override
  Future<void> modifyBalance(double amount) async{
    final balanceDb = await Hive.openBox<BalanceModel>(balanceDatabase);
    final balanceModel = BalanceModel(balance: amount);
    balanceDb.put(123, balanceModel);
    await refreshBalance();
  }
}
