import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

void openFavorite(Box<songshive> songsBox, int index) async {
  final boxFavoriteSongs = await Hive.openBox<Songfavorite>('favoritesongsBox');

  final song = songsBox.getAt(index);
  if (song != null) {
    final songFavorite = Songfavorite(favoritesong: song.name);
    await boxFavoriteSongs.add(songFavorite);
  }
}

Future<bool> isFavorite(Box<songshive> songsBox, int index) async {
  final boxFavoriteSongs = await Hive.openBox<Songfavorite>('favoritesongsBox');
  final song = songsBox.getAt(index);
  if (song != null) {
    final isFav = boxFavoriteSongs.values
        .any((element) => element.favoritesong == song.name);
    return isFav;
  }
  return false;
}

void toggleFavorite(
    BuildContext context, Box<songshive> songsBox, int index) async {
  final boxFavoriteSongs = await Hive.openBox<Songfavorite>('favoritesongsBox');
  final song = songsBox.getAt(index);

  if (song != null) {
    final favoriteSongIndex = boxFavoriteSongs.values.toList().indexWhere(
          (element) => element.favoritesong == song.name,
        );

    if (favoriteSongIndex != -1) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(' Favorite?'),
            content: const Text('Song already exists in favorites'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      final songFavorite = Songfavorite(favoritesong: song.name);
      await boxFavoriteSongs.add(songFavorite);
    }
  }
}
