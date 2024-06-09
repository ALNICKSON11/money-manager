import 'package:money_management_project/models/depts/depts_model.dart';

abstract class DeptdbFunctions{

  Future<List<DeptModel>> getAllDepts();

  Future<void> addDept(DeptModel deptModel);

  Future<void> convertToSettled(DeptModel deptModel);

  Future<void> deleteDept(String id);
}