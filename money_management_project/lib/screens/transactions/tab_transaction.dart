import 'package:flutter/material.dart';
import 'package:money_management_project/database/transaction/transactiondb_impl.dart';
import 'package:money_management_project/screens/transactions/screen_transaction.dart';
import 'package:money_management_project/screens/transactions/transaction_report.dart';

class TabTransaction extends StatefulWidget {
  const TabTransaction({super.key});

  @override
  State<TabTransaction> createState() => _TabTransactionState();
}

class _TabTransactionState extends State<TabTransaction> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    TransactionDb.instance.refreshTransationUI();
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
          Tab(text: 'TRANSACTIONS'),
          Tab(text: 'REPORT')
        ]),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              ScreenTransaction(),
              TransactionReport()
          ]),
        )
      ],
    );
  }
}