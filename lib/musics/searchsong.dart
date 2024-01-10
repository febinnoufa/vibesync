import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/dbfunctionsmusic/dbfunction.dart';
import 'package:vibesync/musics/dbfunctionsmusic/favoritedb.dart';
import 'package:vibesync/musics/seekbar.dart';
import 'package:vibesync/musics/songlistaddtoplaylist.dart';
import 'package:vibesync/shareapp/sharesong.dart';

class Searchsong extends StatefulWidget {
  const Searchsong({Key? key}) : super(key: key);

  @override
  State<Searchsong> createState() => SearchsongState();
}

class SearchsongState extends State<Searchsong> {
  late Box<songshive>? songsBox;
  late TextEditingController searchController;
  List<dynamic> _searchedSongs = [];
  late Box<songshive> recentlyPlayedsongBox;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    initializeBoxes();
  }

  Future<void> initializeBoxes() async {
    try {
      songsBox = await Hive.openBox<songshive>('songsBox');
      openRecentlyPlayedBox();
      fetchAllSongs();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing boxes: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: _filterSongs,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      _filterSongs('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: _searchedSongs.isEmpty
                      ? const Center(child: Text('No songs available'))
                      : ListView.builder(
                          itemCount: _searchedSongs.length,
                          itemBuilder: (context, index) {
                            final song = _searchedSongs[index];
                            final songs = songsBox!.getAt(index);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MusicPlayerPage(
                                      songFilePath: song.name,
                                    ),
                                  ),
                                );
                                addToRecentlyPlayed(songs!.name, songs.artist);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 239, 235, 235),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.music_note,
                                      color: Color.fromARGB(255, 226, 220, 220),
                                    ),
                                  ),
                                  title: Text(
                                    getsongName(song),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 19, 18, 18),
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MusicPlayerPage(
                                                songFilePath: song.name,
                                              ),
                                            ),
                                          );
                                          addToRecentlyPlayed(
                                              songs!.name, songs.artist);
                                        },
                                        child: const Text('Play'),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          toggleFavorite(
                                              context, songsBox!, index);
                                        },
                                        child: const Text('Favorite'),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Songlistaddplaylist(
                                                song: song,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Add to Playlist'),
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
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> fetchAllSongs() async {
    _searchedSongs = songsBox!.values.toList();
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        fetchAllSongs(); // If query is empty, display all songs again
      } else {
        _searchedSongs = songsBox!.values
            .where(
                (song) => song.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String getsongName(songshive song) {
    List<String> pathSegments = song.name.split('/');
    String songName = pathSegments.last;
    return songName;
  }
}
