import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_project/database/dept/deptdb_impl.dart';
import 'package:money_management_project/models/depts/dept_type.dart';
import 'package:money_management_project/models/depts/depts_model.dart';

//This notifier is used to notify the type of the category to the add category popup
ValueNotifier<DeptType> deptNotifier = ValueNotifier(DeptType.forMe);

Future<void> deptAddPopup(BuildContext context) async{

  //This Controller is used to store the value in the TextFormField
  final deptPurposeController = TextEditingController();
  final deptAmountController = TextEditingController();

  ValueNotifier<String> dateNotifier = ValueNotifier('Date');

  DateTime? selectedDates;

  final _formKey = GlobalKey<FormState>();

  showDialog(context: context, builder: (ctx){
    return Form(
      key: _formKey,
      child: SimpleDialog(
        backgroundColor: Colors.white,
        title: const Text('Add a Debt'),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter a reason';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              controller: deptPurposeController,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                label: Text('Debt reason'),
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
      
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter the Amount';
                }
                final parseAmount = double.tryParse(value);
                if(parseAmount == null){
                  return 'Only numbers are allowed';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: deptAmountController,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                label: Text('Amount'),
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
      
          TextButton.icon(
            onPressed: () async {
              selectedDates = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
              );
      
              if (selectedDates == null) {
                return;
              }
      
              dateNotifier.value = DateFormat('dd-MM-yyyy').format(selectedDates!);
              dateNotifier.notifyListeners;
            },
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            label: ValueListenableBuilder(
              valueListenable: dateNotifier,
              builder: (context, value, child) {
                return Text(value,
                style: TextStyle(color: dateNotifier.value == 'Select a date' ? Colors.red : Colors.blue),);
              },
            ),
          ),
          
      
          const Padding(
          padding: EdgeInsets.symmetric(horizontal: 39),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RadioButton(title: 'To me', type: DeptType.forMe),
              RadioButton(title: 'By me', type: DeptType.byMe),
            ],
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(onPressed: (){
              
              final debtPurpose = deptPurposeController.text;
              final deptType = deptNotifier.value;
              final debtAmount = deptAmountController.text;

              final parsedAmount = double.tryParse(debtAmount);

              if(_formKey.currentState?.validate() ?? false){
                if(selectedDates == null){
                  dateNotifier.value = 'Select a date';
                  dateNotifier.notifyListeners();
                }

                if(selectedDates != null){
                  final debtModel = DeptModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  purpose: debtPurpose, 
                  amount: parsedAmount!, 
                  date: selectedDates!, 
                  type: deptType, 
                  isSettled: false);
                
                  DeptDb().addDept(debtModel);
                  DeptDb().refreshDeptUI();
                  Navigator.of(ctx).pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
            ),
            child: const Text('ADD', style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  });
}

class RadioButton extends StatelessWidget {

  final String title;
  final DeptType type;
  // final CategoryType selectedType;

  const RadioButton({super.key,
  required this.title,
  required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: deptNotifier,
          builder:  (BuildContext context, DeptType newType, Widget? _){
            return Radio<DeptType>(
              activeColor: Colors.blue,
              value: type,
              groupValue: newType,
              onChanged: (value){
                if(value == null){
                  return;
                }
                deptNotifier.value = value;
                deptNotifier.notifyListeners();
              });
          }
        ),
        Text(title),
      ],
    );
  }
}