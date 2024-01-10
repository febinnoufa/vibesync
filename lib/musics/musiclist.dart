import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/dbfunctionsmusic/dbfunction.dart';
import 'package:vibesync/musics/dbfunctionsmusic/favoritedb.dart';
import 'package:vibesync/musics/seekbar.dart';
import 'package:vibesync/musics/songlistaddtoplaylist.dart';
import 'package:vibesync/shareapp/sharesong.dart';

class MusicList extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MusicList({Key? key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  late List<SongModel> songs = [];
  late AudioPlayer _audioPlayer;
  final databasesong = Hive.openBox<songshive>('songsBox');
  late Box<songshive> recentlyPlayedsongBox;
  late Box<songshive> songsBox;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    openRecentlyPlayedBox();
    openSongsBox();
  }

  @override
  Widget build(BuildContext context) {
    final songsBox = Hive.box<songshive>('songsBox');

    return Scaffold(
      body: Scrollbar(
        thickness: 10,
        interactive: true,
        child: ListView.builder(
          itemCount: songsBox.length,
          itemBuilder: (context, index) {
            final song = songsBox.getAt(index);
            if (song != null) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 235, 235),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                        getsongName(song),
                        //song.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 19, 18, 18),
                        ),
                      ),
                      subtitle: Text(
                        song.artist,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 27, 25, 25),
                        ),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                addToRecentlyPlayed(song.name, song.artist);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MusicPlayerPage(
                                      songFilePath: song.name,
                                      //audioPlayer: _audioPlayer,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Play')),
                          PopupMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Songlistaddplaylist(song: song),
                                    ));
                              },
                              child: const Text('Add to playlist')),
                          PopupMenuItem(
                            onTap: () {
                              toggleFavorite(context, songsBox, index);
                            },
                            child: const Text('Favorite'),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              shareSong(song);
                            },
                            child: const Text('Share'),
                          ),
                        ],
                        child: const Icon(
                          Icons.more_vert,
                          color: Color.fromARGB(255, 18, 17, 17),
                        ),
                      ),
                      onTap: () {
                        addToRecentlyPlayed(song.name, song.artist);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPlayerPage(
                              songFilePath: song.name,
                              //audioPlayer: _audioPlayer,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();

    super.dispose();
  }

  //  Functions  ************ //

  //_____________________________ //

  Future<void> openSongsBox() async {
    songsBox = await Hive.openBox<songshive>('songsBox');
    setState(() {});
  }

  void playSong(int index) async {
    try {
      if (_audioPlayer.playerState.playing) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.setUrl(songs[index].data);
      await _audioPlayer.play();
      // ignore: empty_catches
    } catch (e) {}
  }

  String getsongName(songshive song) {
    List<String> pathSegments = song.name.split('/');
    String songName = pathSegments.last;
    // String name = songName.substring(0, 22);
    return songName;
  }
}
