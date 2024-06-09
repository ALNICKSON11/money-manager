import 'package:flutter/material.dart';
import 'package:money_management_project/database/notes/notedb_impl.dart';
import 'package:money_management_project/models/notes/notes_model.dart';

Future<void> addNoteSheet(BuildContext context) async {

  final noteController = TextEditingController();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add a Note or Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final noteModel = NotesModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(), 
                      note: noteController.text, 
                      isCompleted: false);
                    if(noteModel.id.isEmpty || noteModel.note.isEmpty || noteModel.isCompleted){
                      return;
                    }else{
                      NoteDb.instance.addNote(noteModel);
                      Navigator.of(ctx).pop();
                      NoteDb().refresNotesUI();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'ADD NOTE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

