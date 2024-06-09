import 'package:money_management_project/models/notes/notes_model.dart';

abstract class NotedbFunctions{

  Future<List<NotesModel>> getAllNotes();

  Future<void> addNote (NotesModel noteModel);

  Future<void> deleteNote(String id);

  Future<void> convertToCompleted(NotesModel noteModel);

}