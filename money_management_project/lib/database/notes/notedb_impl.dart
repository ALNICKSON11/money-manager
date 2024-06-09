import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_project/database/notes/notedb_functions.dart';
import 'package:money_management_project/models/notes/notes_model.dart';

const noteDbName = 'notes-db';
class NoteDb implements NotedbFunctions{

  NoteDb.internal();
  static final NoteDb instance = NoteDb.internal();
  factory NoteDb() => instance;

  ValueNotifier<List<NotesModel>> unCompletedNotesNotifier = ValueNotifier([]);
  ValueNotifier<List<NotesModel>> completedNotedNotifier = ValueNotifier([]);


  @override
  Future<void> addNote(NotesModel noteModel) async{
    final notesDb = await Hive.openBox<NotesModel>(noteDbName);
    await notesDb.put(noteModel.id, noteModel);
  }

  @override
  Future<void> deleteNote(String noteId) async{
    final notesDb = await Hive.openBox<NotesModel>(noteDbName);
    await notesDb.delete(noteId);
  }

  @override
  Future<List<NotesModel>> getAllNotes() async{
    final notesDb = await Hive.openBox<NotesModel>(noteDbName);
    return notesDb.values.toList();
  }

  Future<void> refresNotesUI() async{
    final allNotes = await getAllNotes();
    allNotes.sort((first, second)=>second.id.compareTo(first.id));
    unCompletedNotesNotifier.value.clear();
    completedNotedNotifier.value.clear();
    for(var noteModel in allNotes){
      if(!noteModel.isCompleted){
        unCompletedNotesNotifier.value.add(noteModel);
      }else{
        completedNotedNotifier.value.add(noteModel);
      }
    }

    unCompletedNotesNotifier.notifyListeners();
    completedNotedNotifier.notifyListeners();
  }
  
  @override
  Future<void> convertToCompleted(NotesModel noteModel) async{
    final notesDb = await Hive.openBox<NotesModel>(noteDbName);
    final convertedNote = NotesModel(
      id: noteModel.id, 
      note: noteModel.note, 
      isCompleted: true);
    await notesDb.put(noteModel.id, convertedNote);
  }
}