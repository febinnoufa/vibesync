import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/addplaylist/playlist_function.dart';
import 'package:vibesync/musics/playlistpage.dart';

// ignore: camel_case_types, must_be_immutable
class Playlist_music extends StatefulWidget {
  final List<SongModel> selectedSongs;
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  Playlist_music({Key? key, required this.selectedSongs});

  @override
  State<Playlist_music> createState() => _Playlist_musicState();
}

// ignore: camel_case_types
class _Playlist_musicState extends State<Playlist_music> {
  final TextEditingController _textFieldController = TextEditingController();
  late Box<Songplaylist> songplaylistBox;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 220, 220, 220),
        child: boxsongplaylist.isEmpty
            ? const Center(
                child: Text('No Playlist'),
              )
            : ListView.builder(
                itemCount: boxsongplaylist.length,
                itemBuilder: (context, index) {
                  Songplaylist data = boxsongplaylist.getAt(index);
                  int songCount = data.songs?.length ?? 0;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Musicplaylistpage(data: data, id: data.id),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, right: 20, left: 5),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 235, 235),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/playlistfolder.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 15, 14, 14),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$songCount Songs',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 9, 9, 9)
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            onSelected: (value) {
                              _handlePopupMenuSelection(value, index);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                  value: 'rename', child: Text('Rename')),
                              const PopupMenuItem(
                                  value: 'delete', child: Text('Delete')),
                            ],
                            child: const Icon(
                              Icons.more_vert,
                              color: Color.fromARGB(255, 20, 20, 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPlaylistDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handlePopupMenuSelection(String value, int index) {
    switch (value) {
      case 'open':
        break;
      case 'add':
        _addNewVideos(index);
        break;
      case 'rename':
        _showRenameDialog(index);
        break;
      case 'delete':
        _deletePlaylist(index);
        break;
    }
  }

  // ignore: unused_element
  void _openPlaylist(int index) {
    // Handle 'Open Playlist' action
  }

  void _addNewVideos(int index) {
    // Handle 'Add New Videos' action
  }

  void _showRenameDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Songplaylist data = boxsongplaylist.getAt(index);
        return AlertDialog(
          title: const Text('Rename Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelText: 'New Playlist Name',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String updatedPlaylistName = _textFieldController.text;
                      if (updatedPlaylistName.isNotEmpty) {
                        setState(() {
                          boxsongplaylist.putAt(
                              index,
                              Songplaylist(
                                  name: updatedPlaylistName,
                                  songs: data.songs,
                                  id: data.id
                                  //songname: selectedSongs ,
                                  // songname: []
                                  ));
                        });
                        _textFieldController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Rename'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _textFieldController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _deletePlaylist(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Corrected typo here
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  boxsongplaylist.deleteAt(index);
                  Navigator.pop(context); // Corrected typo here
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPlaylistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(labelText: 'Playlist Name'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String playlistName = _textFieldController.text;
                      if (playlistName.isNotEmpty) {
                        await addPlayListName(playlistName);
                        setState(() {});

                        _textFieldController.clear();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('OK'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _textFieldController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openBox() async {
    songplaylistBox = await Hive.openBox<Songplaylist>('songplaylistBox');
    setState(() {});
  }
}
