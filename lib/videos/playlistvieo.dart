import 'package:flutter/material.dart';

import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';

import 'package:vibesync/videos/dbfunctions/playlist_function_v.dart';
import 'package:vibesync/videos/videoplaylist.dart';

class Playlistvideo extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Playlistvideo({
    Key? key,
  });

  @override
  State<Playlistvideo> createState() => PlaylistvideoState();
}

class PlaylistvideoState extends State<Playlistvideo> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 220, 220, 220),
        child: boxvideoplaylist.isEmpty
            ? const Center(
                child: Text('No PLaylist'),
              )
            : ListView.builder(
                itemCount: boxvideoplaylist.length,
                itemBuilder: (context, index) {
                  videoplaylist data = boxvideoplaylist.getAt(index);
                  // playlistVideos = data.videos;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Videoplaylistpage(
                            data: data,
                            id: data.id,
                          ),
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
                              Text(
                                data.videos == null
                                    ? '0 Videos'
                                    : '${data.videos?.length}  Videos'
                                        .toString(), // Checking for null and displaying length or a default value
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
                              // const PopupMenuItem(
                              //     value: 'open', child: Text('Open Playlist')),
                              // const PopupMenuItem(
                              //     value: 'add', child: Text('Add New Videos')),
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
        _openPlaylist(index);
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
        videoplaylist data = boxvideoplaylist.getAt(index);
        return AlertDialog(
          title: const Text('Rename Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
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
                          boxvideoplaylist.putAt(
                            index,
                            videoplaylist(
                                name: updatedPlaylistName,
                                videos: data.videos,
                                id: data.id),
                          );
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
                  boxvideoplaylist.deleteAt(index);
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
                        await addPlayListNamevedeo(playlistName);
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
