import 'package:flutter/material.dart';
import 'package:money_management_project/database/category/categorydb_impl.dart';
import 'package:money_management_project/screens/category/expense_list_view.dart';
import 'package:money_management_project/screens/category/income_list_view.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.blue,
          dividerColor: Colors.white,
          indicatorColor: Colors.blue,
          controller: tabController,
          tabs: const [
          Tab(text: 'INCOME'),
          Tab(text: 'EXPENSE')
        ]),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              IncomeListView(),
              ExpenseListView()
          ]),
        )
      ],
    );
  }
}