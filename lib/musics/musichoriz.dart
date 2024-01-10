import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/seekbar.dart';

// ignore: camel_case_types
class Music_hor_list extends StatefulWidget {
  const Music_hor_list({Key? key}) : super(key: key);

  @override
  State<Music_hor_list> createState() => _Music_listState();
}

// ignore: camel_case_types
class _Music_listState extends State<Music_hor_list> {
  late Box<songshive>? recentlyPlayedsongBox;
  bool _isLoading = true;
  // ignore: prefer_collection_literals
  Set<String> displayedSongs = Set();

  @override
  void initState() {
    super.initState();
    openRecentlyPlayedBox();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : buildMusicList();
  }

  Widget buildMusicList() {
    if (recentlyPlayedsongBox == null || recentlyPlayedsongBox!.isEmpty) {
      // ignore: prefer_const_constructors
      return Center(
        child: const Text('No songs available'),
      );
    } else {
      List<songshive?> songs = recentlyPlayedsongBox!.values.toList();
      songs = songs.reversed.toList();
      return ListView.builder(
        itemCount: songs.length > 5 ? 5 : songs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final song = songs[index];
          if (song != null) {
            if (displayedSongs.contains(song.name)) {
              return const SizedBox();
            }
            displayedSongs.add(song.name);

            return Column(
              children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 253, 253),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      height: 140,
                      width: 170,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color.fromARGB(255, 17, 17, 17),
                            child: Icon(
                              Icons.music_note,
                              color: Color.fromARGB(255, 226, 220, 220),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            getsongsName(song),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerPage(
                          songFilePath: song.name,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }

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
