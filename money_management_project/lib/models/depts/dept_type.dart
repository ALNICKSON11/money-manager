import 'package:hive_flutter/hive_flutter.dart';
part 'dept_type.g.dart';

@HiveType(typeId: 5)
enum DeptType{

  @HiveField(0)
  forMe,

  @HiveField(1)
  byMe,
}