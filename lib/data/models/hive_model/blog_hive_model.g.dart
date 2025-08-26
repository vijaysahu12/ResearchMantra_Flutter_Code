// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogsHiveModelAdapter extends TypeAdapter<BlogsHiveModel> {
  @override
  final int typeId = 1;

  @override
  BlogsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogsHiveModel(
      objectId: fields[0] as String,
      enableComments: fields[7] as bool,
      postedAgo: fields[6] as String,
      content: fields[1] as String,
      hashtag: fields[3] as String,
      createdBy: fields[4] as String,
      gender: fields[2] as String,
      createdOn: fields[5] as String,
      likesCount: fields[8] as int,
      commentsCount: fields[9] as int,
      image: (fields[10] as List?)?.cast<String>(),
      userFullName: fields[11] as String?,
      userHasLiked: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BlogsHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.hashtag)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.createdOn)
      ..writeByte(6)
      ..write(obj.postedAgo)
      ..writeByte(7)
      ..write(obj.enableComments)
      ..writeByte(8)
      ..write(obj.likesCount)
      ..writeByte(9)
      ..write(obj.commentsCount)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.userFullName)
      ..writeByte(12)
      ..write(obj.userHasLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
