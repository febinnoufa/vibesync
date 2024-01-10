import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/dbfunctionsmusic/addplaylistdb.dart';
import 'package:vibesync/musics/playlistpage.dart';

class SongsAddPlaylist extends StatefulWidget {
  final Songplaylist data;
  final int id;

  SongsAddPlaylist({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<SongsAddPlaylist> createState() => _SongsAddPlaylistState();
}

class _SongsAddPlaylistState extends State<SongsAddPlaylist> {
  Box<songshive>? songsBox;
  late TextEditingController searchController;
  List<songshive> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    initializeSongsBox();
    searchController = TextEditingController();
  }

  Future<void> initializeSongsBox() async {
    songsBox = await Hive.openBox<songshive>('songsBox');
    filterSongs('');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (songsBox == null) {
      return Scaffold(
        appBar: AppBar(
          // App bar details...
        ),
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Songs Playlist'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Musicplaylistpage(
                      data: widget.data,
                      id: widget.id,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                onChanged: filterSongs,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Search',
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            filterSongs('');
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: songsBox == null || songsBox!.isEmpty
                  ? const Center(child: Text('No songs available'))
                  : ListView.builder(
                      itemCount: filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = filteredSongs[index];
                        return song != null
                            ? Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 239, 235, 235),
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
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      addSongToPlaylist(context, song, widget.id);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
            ),
          ],
        ),
      );
    }
  }

  String getsongName(songshive song) {
    List<String> pathSegments = song.name.split('/');
    String songName = pathSegments.last;

    return songName;
  }

  void filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSongs = songsBox!.values.toList();
      } else {
        filteredSongs = songsBox!.values
            .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
