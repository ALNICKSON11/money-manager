import 'package:flutter/material.dart';
import 'package:money_management_project/database/dept/deptdb_impl.dart';
import 'package:money_management_project/screens/dept/by_me_list.dart';
import 'package:money_management_project/screens/dept/to_me_list.dart';
import 'package:money_management_project/screens/dept/settled_list.dart';

class ScreenDebt extends StatefulWidget {
  const ScreenDebt({super.key});

  @override
  State<ScreenDebt> createState() => _ScreenDebtState();
}

class _ScreenDebtState extends State<ScreenDebt> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    DeptDb().refreshDeptUI();
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
          Tab(text: 'OWE TO ME',),
          Tab(text: 'OWE BY ME',),
          Tab(text: 'SETTELED')
        ]),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              ToMeList(),
              ByMeList(),
              SettledList(),
          ]),
        )
      ],
    );
  }
}