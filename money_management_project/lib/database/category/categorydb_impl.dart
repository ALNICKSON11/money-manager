import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/database/category/categorydb_functions.dart';
import 'package:money_management_project/models/category/category_model.dart';
import 'package:money_management_project/models/category/category_type.dart';

const CATEGORY_DB_NAME = 'category-database';
class CategoryDb implements CategorydbFuntions{

  CategoryDb.internal();

  static CategoryDb instance = CategoryDb.internal();

  factory CategoryDb(){
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);

  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);



  @override
  Future<List<CategoryModel>> getCategories() async{
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }




  @override
  Future<void> addCategory(CategoryModel categoryModel) async{
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(categoryModel.id, categoryModel);
    refreshUI();
  }

  Future<void> refreshUI() async{
    final allCategories = await getCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    await Future.forEach(allCategories, (CategoryModel categoryModel){
      if(categoryModel.type == CategoryType.income){
        incomeCategoryList.value.add(categoryModel);
      }else{
        expenseCategoryList.value.add(categoryModel);
      }
    });

    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }
  
  @override
  Future<void> deleteCategory(String categoryId) async{
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(categoryId);
    refreshUI();
  }
}