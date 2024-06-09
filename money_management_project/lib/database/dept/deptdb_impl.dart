import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/database/balance/balancedb_impl.dart';
import 'package:money_management_project/database/dept/deptdb_functions.dart';
import 'package:money_management_project/models/depts/dept_type.dart';
import 'package:money_management_project/models/depts/depts_model.dart';

const deptDbName = 'dept-database';

class DeptDb implements DeptdbFunctions {
  DeptDb.internal();
  static final DeptDb instance = DeptDb.internal();
  factory DeptDb() => instance;

  ValueNotifier<List<DeptModel>> forMeDeptList = ValueNotifier([]);
  ValueNotifier<List<DeptModel>> byMeDeptList = ValueNotifier([]);
  ValueNotifier<List<DeptModel>> isSettledList = ValueNotifier([]);
  ValueNotifier<double> totalOwedToMeNotifier = ValueNotifier(0.0);
  ValueNotifier<double> totalOwedByMeNotifier = ValueNotifier(0.0);

  @override
  Future<void> addDept(DeptModel deptModel) async {
    final deptDb = await Hive.openBox<DeptModel>(deptDbName);
    if(deptModel.type == DeptType.forMe){
      BalanceDb.instance.substractBalance(deptModel.amount);
    }
    if(deptModel.type == DeptType.byMe){
      BalanceDb.instance.addBalance(deptModel.amount);
    }
    await deptDb.put(deptModel.id, deptModel);
    BalanceDb.instance.refreshBalance();
    refreshDeptUI();
  }

  @override
  Future<void> convertToSettled(DeptModel deptModel) async {
    final deptDb = await Hive.openBox<DeptModel>(deptDbName);
    final convertedDept = DeptModel(
      id: deptModel.id, 
      purpose: deptModel.purpose,
      amount: deptModel.amount,
      date: deptModel.date,
      type: deptModel.type,
      isSettled: true,
    );
    if(deptModel.type == DeptType.forMe){
      BalanceDb.instance.addBalance(deptModel.amount);
    }
    if(deptModel.type == DeptType.byMe){
      BalanceDb.instance.substractBalance(deptModel.amount);
    }
    await deptDb.put(deptModel.id, convertedDept);
    BalanceDb().refreshBalance();
    refreshDeptUI();
  }

  @override
  Future<void> deleteDept(String deptId) async {
    final deptDb = await Hive.openBox<DeptModel>(deptDbName);
    await deptDb.delete(deptId);
    refreshDeptUI();
  }

  @override
  Future<List<DeptModel>> getAllDepts() async {
    final deptDb = await Hive.openBox<DeptModel>(deptDbName);
    return deptDb.values.toList();
  }

  Future<void> refreshDeptUI() async {
    final allDepts = await getAllDepts();
    allDepts.sort((first, second) => second.date.compareTo(first.date));
    forMeDeptList.value.clear();
    byMeDeptList.value.clear();
    isSettledList.value.clear();
    for (var deptModel in allDepts) {
      if (!deptModel.isSettled) {
        if (deptModel.type == DeptType.forMe) {
          forMeDeptList.value.add(deptModel);
        } else {
          byMeDeptList.value.add(deptModel);
        }
      } else {
        isSettledList.value.add(deptModel);
      }
    }

    totalDeptToMe(allDepts);

    forMeDeptList.notifyListeners();
    byMeDeptList.notifyListeners();
    isSettledList.notifyListeners();
  }

  Future<void> totalDeptToMe(List<DeptModel> allDepts) async{
    totalOwedByMeNotifier.value = 0.0;
    totalOwedToMeNotifier.value = 0.0;
    for(var debtModel in allDepts){
      if(!debtModel.isSettled){
        if(debtModel.type == DeptType.forMe){
          totalOwedToMeNotifier.value += debtModel.amount;
        }
        if(debtModel.type == DeptType.byMe){
          totalOwedByMeNotifier.value += debtModel.amount;
        }
      }
    }

    totalOwedToMeNotifier.notifyListeners();
    totalOwedByMeNotifier.notifyListeners();
  }
}
