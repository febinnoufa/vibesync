import 'package:hive/hive.dart';

import 'package:vibesync/database/model/model.dart';

late Box<songshive> recentlyPlayedsongBox;

Future<void> openRecentlyPlayedBox() async {
  recentlyPlayedsongBox =
      await Hive.openBox<songshive>('recentlyPlayedsongBox');
}

void addToRecentlyPlayed(String songs, String artist) async {
  final song = songshive(name: songs, artist: artist);
  await recentlyPlayedsongBox.add(song);
}
