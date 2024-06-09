import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_project/database/dept/deptdb_impl.dart';
import 'package:money_management_project/models/depts/depts_model.dart';

class ByMeList extends StatelessWidget {
  const ByMeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ValueListenableBuilder(
            valueListenable: DeptDb.instance.totalOwedByMeNotifier, 
            builder: (BuildContext ctx, double totalAmount, Widget? _){
              return Text('Total Amount Owed By Me: ${totalAmount.toString()} ₹', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),);
            }),
        ),

        Expanded(
          child: ValueListenableBuilder(
            valueListenable: DeptDb.instance.byMeDeptList, 
            builder: (BuildContext ctx, List<DeptModel> newList, Widget? _) {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index){
                  final dept = newList[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(156, 33, 149, 243),
                        child: Text(
                          parseDate(dept.date),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      title: Text('${dept.amount.toString()} ₹', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      subtitle: Text(dept.purpose),
                      trailing: IconButton(onPressed: (){
                      DeptDb().convertToSettled(dept);
                      DeptDb().refreshDeptUI();
                      }, icon: const Icon(Icons.check_circle_outline_outlined, color: Colors.blue,)),
                    ),
                  );
                }, 
                separatorBuilder: (context, index){
                  return const SizedBox(height: 10,);
                }, 
                itemCount: newList.length);
            }),
        ),
      ],
    );
   }

    String parseDate(DateTime date){
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '${splittedDate.last}\n${splittedDate.first}';
  }
}