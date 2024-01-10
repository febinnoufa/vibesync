import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

Future<void> registerAdapter() async{
   Hive.registerAdapter(SongplaylistAdapter());
  Hive.registerAdapter(videoplaylistAdapter());
  Hive.registerAdapter(songshiveAdapter());
  Hive.registerAdapter(videohiveAdapter());
  Hive.registerAdapter(SongfavoriteAdapter());
  Hive.registerAdapter(VideofavoriteAdapter());
}