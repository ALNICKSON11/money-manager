// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dept_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeptTypeAdapter extends TypeAdapter<DeptType> {
  @override
  final int typeId = 5;

  @override
  DeptType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeptType.forMe;
      case 1:
        return DeptType.byMe;
      default:
        return DeptType.forMe;
    }
  }

  @override
  void write(BinaryWriter writer, DeptType obj) {
    switch (obj) {
      case DeptType.forMe:
        writer.writeByte(0);
        break;
      case DeptType.byMe:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeptTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
