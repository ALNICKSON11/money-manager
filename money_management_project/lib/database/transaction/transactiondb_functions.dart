import 'package:money_management_project/models/transaction/transaction_model.dart';

abstract class TransactiondbFunctions{

  Future<void> addTransactions  (TransactionModel transactionModel);

  Future<List<TransactionModel>> getTransactions();

  Future<void> deleteTransaction (String id);

}