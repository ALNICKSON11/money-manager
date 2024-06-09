import 'package:flutter/material.dart';
import 'package:money_management_project/database/notes/notedb_impl.dart';
import 'package:money_management_project/models/notes/notes_model.dart';

class CompletedList extends StatelessWidget {
  const CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: NoteDb().completedNotedNotifier,
      builder: (BuildContext ctx, List<NotesModel> newList, Widget? _){
      return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, index){
        final currentNote = newList[index];
        return Card(
          color: Colors.white,
          child: ListTile(
            title: Text(currentNote.note),
            trailing: IconButton(onPressed: (){
              NoteDb.instance.deleteNote(currentNote.id);
              NoteDb.instance.refresNotesUI();
            }, icon: const Icon(Icons.delete_outline, color: Colors.blue,)),
          ),
        );
      },
      separatorBuilder: (ctx, index){
        return const SizedBox(height: 10,);
      },
      itemCount: newList.length);
      });
  }
}