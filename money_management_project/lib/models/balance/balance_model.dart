import 'package:hive_flutter/hive_flutter.dart';
part 'balance_model.g.dart';

@HiveType(typeId: 7)
class BalanceModel{
  @HiveField(0)
  int id;

  @HiveField(1)
  final double balance;

  BalanceModel({required this.balance, this.id = 123});
}