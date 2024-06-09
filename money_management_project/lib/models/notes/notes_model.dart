import 'package:hive_flutter/hive_flutter.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 6)
class NotesModel{

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String note;

  @HiveField(2)
  final bool isCompleted;

  NotesModel({required this.id, required this.note, required this.isCompleted});
}