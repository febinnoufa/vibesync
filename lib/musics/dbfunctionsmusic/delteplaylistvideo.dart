import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

late Songplaylist fountsongplaylist;

Future<void> checkSongsInDatabase(song) async {
  final Box<Songplaylist> songPlaylistBox =
      await Hive.openBox<Songplaylist>('songplaylistBox');

  if (songPlaylistBox.isNotEmpty) {
    final List songsInWidget = song ?? [];
    final List<Songplaylist> playlists = songPlaylistBox.values.toList();

    for (String songPath in songsInWidget) {
      for (Songplaylist playlist in playlists) {
        if (playlist.songs != null && playlist.songs!.contains(songPath)) {
          fountsongplaylist = playlist;

          break;
        }
      }
    }
  }
}
