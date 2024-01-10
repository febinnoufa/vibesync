import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/home.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:vibesync/videos/fetchvideo/fetchvideo.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const Homescreen(),
      ),
    );
  }










  

  // functions ************************ //

  Future<void> initializeData() async {
    await openSongsBox();
    await openVideosBox();

    if (songsBox.isEmpty) {
      await fetchSongsAndSaveToHive();
    }

    if (videosBox.isEmpty) {
      fetchVideos();
    }

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

  Future<void> fetchSongsAndSaveToHive() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      List<SongModel> fetchedSongs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      for (var song in fetchedSongs) {
        final songToSave =
            songshive(name: song.data, artist: song.artist.toString());
        await songsBox.add(songToSave);
      }

      setState(() {
        songs = fetchedSongs;
      });
    } else {}
  }
}
