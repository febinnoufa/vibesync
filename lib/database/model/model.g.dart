// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongplaylistAdapter extends TypeAdapter<Songplaylist> {
  @override
  final int typeId = 1;

  @override
  Songplaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Songplaylist(
      name: fields[0] as String,
      songs: (fields[1] as List?)?.cast<dynamic>(),
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Songplaylist obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.songs)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongplaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class videoplaylistAdapter extends TypeAdapter<videoplaylist> {
  @override
  final int typeId = 2;

  @override
  videoplaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return videoplaylist(
      name: fields[0] as String,
      videos: (fields[1] as List?)?.cast<dynamic>(),
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, videoplaylist obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.videos)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is videoplaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class songshiveAdapter extends TypeAdapter<songshive> {
  @override
  final int typeId = 3;

  @override
  songshive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return songshive(
      name: fields[0] as String,
      artist: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, songshive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.artist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is songshiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class videohiveAdapter extends TypeAdapter<videohive> {
  @override
  final int typeId = 4;

  @override
  videohive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return videohive(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, videohive obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is videohiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SongfavoriteAdapter extends TypeAdapter<Songfavorite> {
  @override
  final int typeId = 5;

  @override
  Songfavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Songfavorite(
      favoritesong: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Songfavorite obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.favoritesong);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongfavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideofavoriteAdapter extends TypeAdapter<Videofavorite> {
  @override
  final int typeId = 6;

  @override
  Videofavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Videofavorite(
      favoritevideo: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Videofavorite obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.favoritevideo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideofavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
