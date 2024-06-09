import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:money_management_project/database/balance/balancedb_impl.dart';
import 'package:money_management_project/database/category/categorydb_impl.dart';
import 'package:money_management_project/database/transaction/transactiondb_impl.dart';
import 'package:money_management_project/models/category/category_model.dart';
import 'package:money_management_project/models/category/category_type.dart';
import 'package:intl/intl.dart';
import 'package:money_management_project/models/transaction/transaction_model.dart';

class AddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';

  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDates;
  CategoryType? selectedCategoryType;
  CategoryModel? selectedCategoryModel;
  String displayDate = 'Date';
  String? categoryId;

  final purposeTextController = TextEditingController();
  final amountTextController = TextEditingController();

  @override
  void initState() {
    selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add a transaction',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: purposeTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a reason';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Purpose',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: amountTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the amount';
                  }
                  final tryParse = double.tryParse(value);
                  if (tryParse == null) {
                    return 'Only numbers are allowed';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blue,
                  )),
                  hintText: 'Amount',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(
                  onPressed: () async {
                    selectedDates = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now());
                    if (selectedDates == null) {
                      return;
                    }

                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(selectedDates!);
                    setState(() {
                      displayDate = formattedDate;
                    });
                  },
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  label: Text(
                    displayDate,
                    style: TextStyle(color: displayDate == 'Select a date' ? Colors.red : Colors.blue),
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                          activeColor: Colors.blue,
                          value: CategoryType.income,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.income;
                              categoryId = null;
                            });
                          }),
                      const Text('Income')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          activeColor: Colors.blue,
                          value: CategoryType.expense,
                          groupValue: selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryType = CategoryType.expense;
                              categoryId = null;
                            });
                          }),
                      const Text('Expense')
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                  hint: const Text('Select category'),
                  value: categoryId,
                  items: (selectedCategoryType == CategoryType.income
                          ? CategoryDb().incomeCategoryList.value
                          : CategoryDb().expenseCategoryList.value)
                      .map((e) {
                    return DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name),
                      onTap: () {
                        selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      categoryId = selectedValue;
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(
                    Icons.add_card,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (selectedDates == null) {
                        setState(() {
                          displayDate = 'Select a date';
                        });
                        return;
                      }
                      addTransaction();
                    }
                  },
                  label: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final purposeValue = purposeTextController.text;
    final amountValue = amountTextController.text;

    final parsedAmount = double.tryParse(amountValue);

    if(CategoryDb.instance.incomeCategoryList.value.isEmpty && CategoryDb.instance.expenseCategoryList.value.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please go back and create a category'),
        duration: Duration(seconds: 3),)
      );
      return;
    }

    if(selectedCategoryModel == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a category'),
        duration: Duration(seconds: 3),)
      );
    }

    final model = TransactionModel(
      purpose: purposeValue,
      amount: parsedAmount!,
      date: selectedDates!,
      type: selectedCategoryType!,
      model: selectedCategoryModel!,
    );

    if (selectedCategoryType == CategoryType.income) {
      await BalanceDb.instance.addBalance(parsedAmount);
    } else {
      await BalanceDb.instance.substractBalance(parsedAmount);
    }
    await TransactionDb.instance.addTransactions(model);

    Navigator.of(context).pop();
  }
}

