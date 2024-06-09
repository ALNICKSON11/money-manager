import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/models/depts/dept_type.dart';
part 'depts_model.g.dart';

@HiveType(typeId: 4)
class DeptModel{

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String purpose;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final DeptType type;

  @HiveField(5)
  final bool isSettled;

  DeptModel({
    required this.id,
    required this.purpose, 
    required this.amount, 
    required this.date, 
    required this.type, 
    required this.isSettled});
}