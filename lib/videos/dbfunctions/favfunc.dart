import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';

openfavorite(Box<videohive> videosBox, int index) async {
  final boxfavoritevideos =
      await Hive.openBox<Videofavorite>('favoritevideosBox');

  final video = videosBox.getAt(index);
  if (video != null) {
    final videofavorite = Videofavorite(favoritevideo: video.name);
    await boxfavoritevideos.add(videofavorite);
    // ignore: avoid_print
    print('Added to favorites: ${videofavorite.favoritevideo}');
  }
}

void toggleFavorite(
    BuildContext context, Box<videohive> videoBox, int index) async {
  final boxfavoritevideos =
      await Hive.openBox<Videofavorite>('favoritevideosBox');
  final video = videoBox.getAt(index);

  if (video != null) {
    final favoritevideoIndex = boxfavoritevideos.values.toList().indexWhere(
          (element) => element.favoritevideo == video.name,
        );

    if (favoritevideoIndex != -1) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(' Favorite?'),
            content: const Text('video already exists in favorites'),
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
      final videoFavorite = Videofavorite(favoritevideo: video.name);
      await boxfavoritevideos.add(videoFavorite);
    }
  }
}
