import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/dbfunctionsmusic/dbfunction.dart';
import 'package:vibesync/musics/dbfunctionsmusic/favoritedb.dart';
import 'package:vibesync/musics/seekbar.dart';
import 'package:vibesync/musics/songlistaddtoplaylist.dart';
import 'package:vibesync/shareapp/sharesong.dart';

class Recentlyplaysong extends StatefulWidget {
  const Recentlyplaysong({Key? key}) : super(key: key);

  @override
  State<Recentlyplaysong> createState() => _RecentlyplaysongState();
}

class _RecentlyplaysongState extends State<Recentlyplaysong> {
  late Box<songshive>? recentlyPlayedsongBox;
  bool _isLoading = true;
  Set<String> displayedSongs = {};

  @override
  void initState() {
    super.initState();
    openRecentlyPlayedBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Wrap with MaterialApp
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Recently Played Songs'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildMusicList(),
      ),
    );
  }

  Widget buildMusicList() {
    if (recentlyPlayedsongBox == null || recentlyPlayedsongBox!.isEmpty) {
      return const Center(
        child: Text('No songs available'),
      );
    } else {
      List<songshive?> songs = recentlyPlayedsongBox!.values.toList();
      songs = songs.reversed.toList();
      return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          if (song != null) {
            if (displayedSongs.contains(song.name)) {
              return const SizedBox();
            }
            displayedSongs.add(song.name);
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 235, 235),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                     addToRecentlyPlayed(song.name, song.artist);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerPage(
                                    songFilePath: song.name,
                                  ),
                                ),
                              );
                    },
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color.fromARGB(255, 17, 17, 17),
                      child: Icon(
                        Icons.music_note,
                        color: Color.fromARGB(255, 226, 220, 220),
                      ),
                    ),
                    title: Text(getsongsName(song)),
                    subtitle: Text(song.artist),
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
                            toggleFavorite(
                                context, recentlyPlayedsongBox!, index);
                            // openFavorite(songsBox, index);
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
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      );
    }
  }

  // functions*********************//

  String getsongsName(songshive song) {
    if (song.name.length >= 22) {
      List<String> pathSegments = song.name.split('/');
      String songName = pathSegments.last;
      String name = songName.substring(0, 22);
      return name;
    } else {
      return song.name;
    }
  }

  Future<void> openRecentlyPlayedBox() async {
    recentlyPlayedsongBox =
        await Hive.openBox<songshive>('recentlyPlayedsongBox');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
