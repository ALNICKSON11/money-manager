// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depts_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeptModelAdapter extends TypeAdapter<DeptModel> {
  @override
  final int typeId = 4;

  @override
  DeptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeptModel(
      id: fields[0] as String?,
      purpose: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      type: fields[4] as DeptType,
      isSettled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DeptModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purpose)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isSettled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
