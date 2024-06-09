import 'package:flutter/material.dart';
import 'package:money_management_project/database/category/categorydb_impl.dart';
import 'package:money_management_project/models/category/category_model.dart';
import 'package:money_management_project/models/category/category_type.dart';

//This notifier is used to notify the type of the category to the add category popup
ValueNotifier<CategoryType> selectedCategoryNotifier = ValueNotifier(CategoryType.income);

Future<void> categoryAddPopup(BuildContext context) async{

  //This Controller is used to store the value in the TextFormField
  final categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showDialog(context: context, builder: (ctx){
    return Form(
      key: _formKey,
      child: SimpleDialog(
        backgroundColor: Colors.white,
        title: const Text('Add a category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: categoryNameController,
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter a category';
                }
                return null;
              },
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                label: Text('Category name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  )
                ),
              ),
            ),
          ),
      
          const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              RadioButton(title: 'Income', type: CategoryType.income),
              RadioButton(title: 'Expense', type: CategoryType.expense),
            ],
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(onPressed: (){
              final categoryName = categoryNameController.text;
              final categoryType = selectedCategoryNotifier.value;
              if(_formKey.currentState?.validate() ?? false){
                final categoryModel = CategoryModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: categoryName,
                type: categoryType);
                CategoryDb().addCategory(categoryModel);
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(225, 33, 149, 243)
            ), 
            child: const Text('ADD', style: TextStyle(
              color: Colors.white
            ),)),
          )
        ],
      ),
    );
  });
}

class RadioButton extends StatelessWidget {

  final String title;
  final CategoryType type;
  // final CategoryType selectedType;

  const RadioButton({super.key,
  required this.title,
  required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder:  (BuildContext context, CategoryType newType, Widget? _){
            return Radio<CategoryType>(
              activeColor: Colors.blue,
              value: type,
              groupValue: newType,
              onChanged: (value){
                if(value == null){
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              });
          }
        ),
        Text(title),
      ],
    );
  }
}