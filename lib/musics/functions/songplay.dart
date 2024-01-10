import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibesync/database/model/model.dart';

late AudioPlayer audioPlayer;
final songBox = Hive.box<songshive>('songsBox');
songshive? foundSong;

void toggleLoopMode() async {
  final currentLoopMode = audioPlayer.loopMode;
  if (currentLoopMode == LoopMode.off) {
    await audioPlayer.setLoopMode(LoopMode.one); // Enable looping
  } else {
    await audioPlayer.setLoopMode(LoopMode.off); // Disable looping
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StreamBuilder<double>(
              stream: stream,
              builder: (context, snapshot) {
                return Slider(
                  min: min,
                  max: max,
                  divisions: divisions,
                  value: snapshot.hasData ? snapshot.data! : value,
                  onChanged: onChanged,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

int findCurrentSongIndexInBox(song) {
  for (int i = 0; i < songBox.length; i++) {
    if (songBox.getAt(i)?.name == song) {
      return i;
    }
  }
  return -1;
}

String getsongName(String songoPath) {
  List<String> pathSegments = songoPath.split('/');
  String songName = pathSegments.last;

  if (songName.contains('.')) {
    songName = songName.split('.').first;
  }

  return songName;
}

Future<void> checkSongBoxForFilePath(String filePath) async {
  for (var song in songBox.values) {
    if (song.name == filePath) {
      foundSong = song;
      continue;
    }
  }
}

Future<void> addToFavorites(String songPath) async {
  final favoritesBox = await Hive.openBox<Songfavorite>('favoritesongsBox');
  final songFavorite = Songfavorite(favoritesong: songPath);

  if (!favoritesBox.values.any((element) => element.favoritesong == songPath)) {
    await favoritesBox.add(songFavorite); // Add the song to favorites
  } else {}
}
