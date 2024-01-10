import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/seekbar.dart';

// ignore: camel_case_types
class Song_Fav extends StatefulWidget {
  const Song_Fav({Key? key}) : super(key: key);

  @override
  State<Song_Fav> createState() => _Song_FavState();
}

// ignore: camel_case_types
class _Song_FavState extends State<Song_Fav> {
  Box<Songfavorite>? songfavbox;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
    _openBox();
  }

  @override
  Widget build(BuildContext context) {
    if (songfavbox == null || !songfavbox!.isOpen) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      body: ValueListenableBuilder<Box<Songfavorite>>(
        valueListenable: songfavbox!.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No songs available'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final songFavorite = box.getAt(index);
              if (songFavorite != null) {
                return Container(
                  height: 75,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 235, 235),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromARGB(255, 17, 17, 17),
                        child: Icon(
                          Icons.music_note,
                          color: Color.fromARGB(255, 226, 220, 220),
                        ),
                      ),
                      title: Text(
                        getsongName(songFavorite),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 19, 18, 18),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          deleteSongFromFavorites(index);
                        },
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPlayerPage(
                            songFilePath: songFavorite.favoritesong,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }

  //  Functions ****************
  // * _______________________________*

  String getsongName(Songfavorite song) {
    List<String> pathSegments = song.favoritesong.split('/');
    String songName = pathSegments.last;
    return songName;
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing) {
      } else {}
    });
  }

  void _openBox() async {
    songfavbox = await Hive.openBox<Songfavorite>('favoritesongsBox');
    setState(() {}); // Trigger a rebuild after box is initialized
  }

  void deleteSongFromFavorites(int index) {
    songfavbox!.deleteAt(index);
    setState(() {});
  }
}
