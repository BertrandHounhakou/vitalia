// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PharmacyModelAdapter extends TypeAdapter<PharmacyModel> {
  @override
  final int typeId = 4;

  @override
  PharmacyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PharmacyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      distance: fields[3] as double,
      isOnDuty: fields[4] as bool,
      phone: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PharmacyModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.isOnDuty)
      ..writeByte(5)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PharmacyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
