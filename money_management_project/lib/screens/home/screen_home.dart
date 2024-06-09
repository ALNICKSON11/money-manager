import 'package:flutter/material.dart';
import 'package:money_management_project/screens/add_transaction/add_transaction.dart';
import 'package:money_management_project/screens/category/category_add_popup.dart';
import 'package:money_management_project/screens/category/screen_category.dart';
import 'package:money_management_project/screens/dept/dept_add_popup.dart';
import 'package:money_management_project/screens/home/widgets/bottom_navigation.dart';
import 'package:money_management_project/screens/dept/screen_dept.dart';
import 'package:money_management_project/screens/notes/add_note_sheet.dart';
import 'package:money_management_project/screens/notes/screen_notes.dart';
import 'package:money_management_project/screens/transactions/tab_transaction.dart'; // Import the new screen

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> selectedBottomIndex = ValueNotifier(0);

  final pages = [
    const TabTransaction(),
    const ScreenCategory(),
    const ScreenDebt(),
    const ScreenNotes(), // Add the new screen to the list
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Money Manager',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedBottomIndex,
          builder: (BuildContext ctx, int updatedIndex, Widget? _) {
            return pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(selectedBottomIndex.value == 0){
            Navigator.of(context).pushNamed(AddTransaction.routeName);
            
          }
          if(selectedBottomIndex.value == 1){
            categoryAddPopup(context);
          }
          if(selectedBottomIndex.value == 2){
            deptAddPopup(context);
          }
          if(selectedBottomIndex.value == 3){
            addNoteSheet(context);
          }
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}