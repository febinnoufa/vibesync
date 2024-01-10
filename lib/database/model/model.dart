// ignore_for_file: camel_case_types

import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class Songplaylist {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<dynamic>? songs = [];

  @HiveField(2)
  int id;

  Songplaylist({required this.name, this.songs, required this.id});
}

@HiveType(typeId: 2)
class videoplaylist {
  @HiveField(0)
  String name;

  @HiveField(1)
  List? videos;
  @HiveField(2)
  int id;

  videoplaylist({required this.name, this.videos, required this.id});
}

@HiveType(typeId: 3)
class songshive {
  @HiveField(0)
  String name;
  @HiveField(1)
  String artist;

  songshive({required this.name, required this.artist});
}

@HiveType(typeId: 4)
class videohive {
  @HiveField(0)
  String name;

  videohive({required this.name});
}

@HiveType(typeId: 5)
class Songfavorite {
  @HiveField(0)
  String favoritesong;

  Songfavorite({required this.favoritesong});
}

@HiveType(typeId: 6)
class Videofavorite {
  @HiveField(0)
  String favoritevideo;

  Videofavorite({required this.favoritevideo});
}
