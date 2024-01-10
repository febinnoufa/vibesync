import 'package:flutter/material.dart';

import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/addplaylist/playlist_function.dart';
import 'package:vibesync/musics/dbfunctionsmusic/addplaylistdb.dart';

// ignore: must_be_immutable
class Songlistaddplaylist extends StatefulWidget {
  songshive song;
  Songlistaddplaylist({super.key, required this.song});

  @override
  State<Songlistaddplaylist> createState() => _SonglistaddplaylistState();
}

class _SonglistaddplaylistState extends State<Songlistaddplaylist> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
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
                  return InkWell(
                    onTap: () {
                      addSongToPlaylist(context, widget.song, data.id);
                      Navigator.pop(context);
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
                                data.songs == null
                                    ? '0 Songs'
                                    : '${data.songs?.length}  Songs'.toString(),
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 9, 9, 9)
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            onSelected: (value) {},
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
}
