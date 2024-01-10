import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';







Future<List<videoplaylist>> getvideo() async {
  final boxvideoplaylist =
      await Hive.openBox<videoplaylist>('videoplaylistBox');
  return boxvideoplaylist.values.toList();
}

void addVideoToPlaylist(BuildContext context, videohive video, int id) async {
  // ignore: unused_local_variable
  final videoplaylists = await Hive.openBox<videoplaylist>('videoplaylistBox');
  final playlist = await getvideo();
  bool videoalreadyexisist = false;

  Future.forEach(playlist, (element) async {
    if (element.id == id) {
      if (element.videos != null && element.videos!.contains(video.name)) {
        videoalreadyexisist = true;
      } else {
        List<dynamic> temp = element.videos ?? [];
        temp.add(video.name);
        final data =
            videoplaylist(name: element.name, id: element.id, videos: temp);
        await boxvideoplaylist.put(data.id, data);
      }
    }
  });
  if (videoalreadyexisist) {
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
