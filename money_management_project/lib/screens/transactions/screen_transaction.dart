import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management_project/database/category/categorydb_impl.dart';
import 'package:money_management_project/database/transaction/transactiondb_impl.dart';
import 'package:money_management_project/models/category/category_type.dart';
import 'package:money_management_project/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key}); 

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUI();
    TransactionDb.instance.refreshTransationUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionModelList, 
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _){
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            final value = newList[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: const DrawerMotion(), 
                children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDb.instance.deleteTransaction(value.id!);
                    },
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ]
              ),
              key: Key(value.id!),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: value.type == CategoryType.expense 
                      ? const Color.fromARGB(80, 244, 67, 54) 
                      : const Color.fromARGB(105, 76, 175, 79),
                    child: Text(
                      parseDate(value.date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  title: Text(
                    '${value.amount} ₹', 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${value.model.name}\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          )
                        ),
                        TextSpan(
                          text: '${value.purpose}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ]
                    ),
                  ),
                  trailing: Text(
                    displayCategoryType(value.type),
                    style: TextStyle(
                      color: value.type == CategoryType.expense ? Colors.red : Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(height: 10);
          },
          itemCount: newList.length
        );
      }
    );
  }

  String parseDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '${splittedDate.last}\n${splittedDate.first}';
  }

  String displayCategoryType(CategoryType type) {
    return type == CategoryType.income ? 'Income' : 'Expense';
  }
}
