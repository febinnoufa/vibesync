import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

void addSongToPlaylist(BuildContext context, songshive song, int id) async {
  final boxsongplaylist = await Hive.openBox<Songplaylist>('songplaylistBox');
  final playList = await getSongs();
  bool songAlreadyExists = false;

  // ignore: avoid_function_literals_in_foreach_calls
  playList.forEach((element) async {
    if (element.id == id) {
      if (element.songs != null && element.songs!.contains(song.name)) {
        songAlreadyExists = true;
      } else {
        List<dynamic> temp = element.songs ?? [];
        temp.add(song.name);
        final data =
            Songplaylist(name: element.name, id: element.id, songs: temp);
        await boxsongplaylist.put(data.id, data);
      }
    }
  });

  if (songAlreadyExists) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Duplicate Song'),
          content: const Text('This song already exists in the playlist.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void deleteSongFromPlaylist(
    BuildContext context, songName, int playlistId) async {
  final Box<Songplaylist> boxsongplaylist =
      await Hive.openBox<Songplaylist>('songplaylistBox');
  final Songplaylist? playlist = boxsongplaylist.get(playlistId);

  if (playlist != null) {
    List<dynamic> updatedSongs = List.from(playlist.songs ?? []);
    if (updatedSongs.contains(songName)) {
      updatedSongs.remove(songName);

      final updatedPlaylist = Songplaylist(
        name: playlist.name,
        id: playlist.id,
        songs: updatedSongs,
      );

      await boxsongplaylist.put(playlistId, updatedPlaylist);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Song Deleted'),
            content: const Text('The song has been removed from the playlist.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Song Not Found'),
            content: const Text('This song does not exist in the playlist.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

Future<List<Songplaylist>> getSongs() async {
  final boxsongplaylist = await Hive.openBox<Songplaylist>('songplaylistBox');
  return boxsongplaylist.values.toList();
}
