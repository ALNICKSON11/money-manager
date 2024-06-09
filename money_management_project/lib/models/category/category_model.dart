import 'package:hive/hive.dart';
import 'package:money_management_project/models/category/category_type.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel{

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isDeleted;

  @HiveField(3)
  final CategoryType type;

  CategoryModel({
    required this.id,
    required this.name,
    this.isDeleted = false,
    required this.type
    });

    @override
    String toString(){
      return '$name, $type';
    }
}