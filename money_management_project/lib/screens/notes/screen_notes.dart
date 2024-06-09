import 'package:flutter/material.dart';
import 'package:money_management_project/database/notes/notedb_impl.dart';
import 'package:money_management_project/screens/notes/completed_list.dart';
import 'package:money_management_project/screens/notes/task_list.dart';

class ScreenNotes extends StatefulWidget {
  const ScreenNotes({super.key});

  @override
  State<ScreenNotes> createState() => _ScreenNotesState();
}

class _ScreenNotesState extends State<ScreenNotes> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    NoteDb().refresNotesUI();
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
          Tab(text: 'TASK'),
          Tab(text: 'COMPLETED')
        ]),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              TaskList(),
              CompletedList(),
          ]),
        )
      ],
    );
  }
}