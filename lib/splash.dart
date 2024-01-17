//import 'package:fetch_all_videos/fetch_all_videos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:list_all_videos/model/video_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibesync/videos/dbfunctions/addtohive.dart';
import 'package:list_all_videos/list_all_videos.dart';


class Screensplash extends StatefulWidget {
  const Screensplash({Key? key}) : super(key: key);

  @override
  State<Screensplash> createState() => _ScreensplashState();
}

class _ScreensplashState extends State<Screensplash> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late List<SongModel> songs = [];
  late Box<songshive> songsBox;
  late Box<videohive> videosBox;
  Widget? permissionResult;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/mylogo.jpg',
          height: 450,
        ),
      ),
    );
  }

  Future<void> gotohome() async {
    if (permissionResult == null) {
      // Permission is granted, show for 10 seconds
      await Future.delayed(const Duration(seconds: 10));
    } else {
      // Permission is not granted, show for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const Homescreen(),
      ),
    );
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Storage permission granted, proceed with fetching videos.
      await fetchVideos();
      List<SongModel> fetchedSongs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      for (var song in fetchedSongs) {
        final songToSave =
            songshive(name: song.data, artist: song.artist ?? '');
        await songsBox.add(songToSave);
      }

      // await fetchVideos(); // Call fetchVideos here

      setState(() {
        songs = fetchedSongs;
      });
    } else {
      await requestStoragePermission();
      await fetchVideos();
      // Storage permission denied, show a message or take appropriate action.
    }
  }

  // functions ************************ //

  Future<void> initializeData() async {
    await openSongsBox();
    await openVideosBox();

    if (videosBox.isEmpty||songsBox.isEmpty) {
      requestPermissions();
      //   await fetchVideos(); // Call fetchVideos here
    }
    //  if (songsBox.isEmpty) {
    //   await requestStoragePermission();
    // }

    gotohome();
  }

  Future<void> openVideosBox() async {
    videosBox = await Hive.openBox<videohive>('videosBox');
    setState(() {});
  }

  Future<void> openSongsBox() async {
    songsBox = await Hive.openBox<songshive>('songsBox');
    setState(() {});
  }

  Future<void> requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();

      setState(() {
        permissionResult = const Center(
          child: CircularProgressIndicator(),
        );
      });

      if (permissionStatus) {
        List<SongModel> fetchedSongs = await _audioQuery.querySongs(
          sortType: SongSortType.TITLE,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
        );

        for (var song in fetchedSongs) {
          final songToSave =
              songshive(name: song.data, artist: song.artist ?? '');
          await songsBox.add(songToSave);
        }

        // await fetchVideos(); // Call fetchVideos here

        setState(() {
          songs = fetchedSongs;
        });
      } else {
        // ignore: use_build_context_synchronously
        showPermissionSettingsDialog(context);
      }
    }
  }

Future<void> fetchVideos() async {
  try {
    List<VideoDetails> videoPaths = await ListAllVideos().getAllVideosPath();

    if (videoPaths.isEmpty) {
    } else {
      List<dynamic> paths = [];
      for (var element in videoPaths) {
        paths.add(element.videoPath);
      }

      // Now, 'paths' contains all the video paths from 'videoPaths'

      // Assuming addVideosToHive expects a List<dynamic>
      addVideosToHive(paths);
    }
  // ignore: empty_catches
  } catch (e) {
  }
}

}

void showPermissionSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Please enable storage permission in app settings to fetch songs.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              openAppSettings(); // Open app settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      );
    },
  );
}
