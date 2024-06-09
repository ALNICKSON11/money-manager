import 'package:money_management_project/models/category/category_model.dart';

abstract class CategorydbFuntions{

  Future<List<CategoryModel>> getCategories();

  Future<void> addCategory(CategoryModel categoryModel);

  Future<void> deleteCategory(String categoryId);
}