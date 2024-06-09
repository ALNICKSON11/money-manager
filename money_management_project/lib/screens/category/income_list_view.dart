import 'package:flutter/material.dart';
import 'package:money_management_project/database/category/categorydb_impl.dart';
import 'package:money_management_project/models/category/category_model.dart';

class IncomeListView extends StatelessWidget {
  const IncomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().incomeCategoryList, 
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _){
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index){
            final category = newList[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(onPressed: (){
                  CategoryDb.instance.deleteCategory(category.id);
                }, 
                icon: const Icon(Icons.delete)),
              ),
            );
          }, 
          separatorBuilder: (ctx, index){
            return const SizedBox(height: 10,);
          }, 
          itemCount: newList.length);
      });
  }
}