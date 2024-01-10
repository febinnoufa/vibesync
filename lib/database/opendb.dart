import 'package:hive/hive.dart';
import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';

Future<void> openBoxes() async {
  boxsongplaylist = await Hive.openBox<Songplaylist>('songplaylistBox');
  boxvideoplaylist = await Hive.openBox<videoplaylist>('videoplaylistBox');
  boxsongs = await Hive.openBox<songshive>('songshiveBox');
  boxvideo = await Hive.openBox<videohive>('videosBox');
  boxfavoritesongs = await Hive.openBox<Songfavorite>('favoritesongs');
  boxfavoritevideos = await Hive.openBox<Videofavorite>('favoritevideos');
}
