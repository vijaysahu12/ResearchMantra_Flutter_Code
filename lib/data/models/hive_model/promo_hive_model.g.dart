// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromoHiveModelAdapter extends TypeAdapter<PromoHiveModel> {
  @override
  final int typeId = 3;

  @override
  PromoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromoHiveModel(
      id: fields[0] as int,
      mediaType: fields[1] as String,
      shouldDisplay: fields[2] as bool,
      maxDisplayCount: fields[3] as int,
      displayFrequency: fields[4] as int,
      lastShownAt: fields[5] as String,
      globalButtonAction: fields[6] as bool,
      target: fields[7] as String,
      productName: fields[8] as String,
      productId: fields[9] as int,
      startDate: fields[10] as String,
      endDate: fields[11] as String,
      mediaItems: (fields[12] as List).cast<MediaHiveItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PromoHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mediaType)
      ..writeByte(2)
      ..write(obj.shouldDisplay)
      ..writeByte(3)
      ..write(obj.maxDisplayCount)
      ..writeByte(4)
      ..write(obj.displayFrequency)
      ..writeByte(5)
      ..write(obj.lastShownAt)
      ..writeByte(6)
      ..write(obj.globalButtonAction)
      ..writeByte(7)
      ..write(obj.target)
      ..writeByte(8)
      ..write(obj.productName)
      ..writeByte(9)
      ..write(obj.productId)
      ..writeByte(10)
      ..write(obj.startDate)
      ..writeByte(11)
      ..write(obj.endDate)
      ..writeByte(12)
      ..write(obj.mediaItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaHiveItemAdapter extends TypeAdapter<MediaHiveItem> {
  @override
  final int typeId = 4;

  @override
  MediaHiveItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaHiveItem(
      mediaUrl: fields[0] as String,
      buttons: (fields[1] as List).cast<ButtonHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaHiveItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mediaUrl)
      ..writeByte(1)
      ..write(obj.buttons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaHiveItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ButtonHiveModelAdapter extends TypeAdapter<ButtonHiveModel> {
  @override
  final int typeId = 5;

  @override
  ButtonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ButtonHiveModel(
      buttonName: fields[0] as String,
      actionUrl: fields[1] as String,
      productName: fields[2] as String,
      productId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ButtonHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.buttonName)
      ..writeByte(1)
      ..write(obj.actionUrl)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
