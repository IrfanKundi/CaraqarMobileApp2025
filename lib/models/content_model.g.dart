// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppContentAdapter extends TypeAdapter<AppContent> {
  @override
  final int typeId = 0;

  @override
  AppContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppContent()
      ..id = fields[0] as int
      ..screen = fields[1] as String
      ..createAt = fields[2] as dynamic;
  }

  @override
  void write(BinaryWriter writer, AppContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.screen)
      ..writeByte(2)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
