import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_project/database/dept/deptdb_impl.dart';
import 'package:money_management_project/models/depts/dept_type.dart';
import 'package:money_management_project/models/depts/depts_model.dart';

class SettledList extends StatelessWidget {
  const SettledList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DeptDb.instance.isSettledList,
      builder: (BuildContext ctx, List<DeptModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final dept = newList[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(156, 33, 149, 243),
                  child: Text(
                    parseDate(dept.date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                title: Text(
                  '${dept.amount.toString()} ₹',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
                subtitle: Text('${dept.purpose}\nOwed ${dept.type == DeptType.byMe ? "by me":"to me"}'),
                trailing: IconButton(
                  onPressed: () {
                    DeptDb().deleteDept(dept.id!);
                    DeptDb().refreshDeptUI();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '${splittedDate.last}\n${splittedDate.first}';
  }
}
