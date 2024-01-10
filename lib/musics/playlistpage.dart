import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/musics/addsongsplaylist.dart';
import 'package:vibesync/musics/dbfunctionsmusic/dbfunction.dart';
import 'package:vibesync/musics/dbfunctionsmusic/delteplaylistvideo.dart';

import 'package:vibesync/musics/seekbar.dart';

// ignore: must_be_immutable
class Musicplaylistpage extends StatefulWidget {
  Songplaylist data;
  int id;

  Musicplaylistpage({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  State<Musicplaylistpage> createState() => MusicplaylistpageState();
}

class MusicplaylistpageState extends State<Musicplaylistpage> {
  final songplaylistbox = Hive.openBox<Songplaylist>('songplaylistBox');

  @override
  void initState() {
    super.initState();
    checkSongsInDatabase(widget.data.songs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 43, 42, 42).withOpacity(0.6),
            const Color.fromARGB(255, 36, 33, 33).withOpacity(0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 70, 70, 68),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Color.fromARGB(255, 137, 134, 134),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/mylogo.jpg',
                    width: 150,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      widget.data.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: FutureBuilder<Box<Songplaylist>>(
                      future: Hive.openBox<Songplaylist>('songplaylist'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final box = snapshot.data!;
                          final playlistKey = 'key_${widget.data.name}';
                          // ignore: unused_local_variable
                          final song = box.get(playlistKey)?.songs ?? [];

                          // ignore: unnecessary_null_comparison
                          return widget.data.songs!.isNotEmpty
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.data.songs?.length,
                                  // ignore: body_might_complete_normally_nullable
                                  itemBuilder: (context, index) {
                                    final songs = widget.data.songs?[index];

                                    if (songs != null) {
                                      return InkWell(
                                        onTap: () {
                                          addToRecentlyPlayed(
                                              songs, fountsongplaylist.name);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MusicPlayerPage(
                                                        songFilePath: songs),
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    Icons.music_note,
                                                    color: Color.fromARGB(
                                                        255, 226, 220, 220),
                                                  ),
                                                ),
                                                title: Text(
                                                  getsongName(songs),
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 17, 17, 17),
                                                      fontSize: 18,
                                                      overflow: TextOverflow
                                                          .ellipsis),
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
                                                                        songFilePath:
                                                                            songs),
                                                              ));
                                                          addToRecentlyPlayed(
                                                              songs!.name,
                                                              songs.artist);
                                                        },
                                                        child:
                                                            const Text('Play')),
                                                    const PopupMenuItem(
                                                        child: Text(
                                                            'Add favorite')),
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Delete Song'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this song from the playlist?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      fountsongplaylist
                                                                          .songs!
                                                                          .removeAt(
                                                                              index);
                                                                      final Box<
                                                                              Songplaylist>
                                                                          boxsongplaylist =
                                                                          Hive.box<Songplaylist>(
                                                                              'songplaylistBox');
                                                                      boxsongplaylist.put(
                                                                          widget
                                                                              .id,
                                                                          fountsongplaylist);
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          const Text('Delete'),
                                                    ),
                                                  ],
                                                  child: const Icon(
                                                    Icons.more_vert,
                                                    color: Color.fromARGB(
                                                        255, 20, 20, 20),
                                                  ),
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    'ADD SONGS IN PLAY LIST',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SongsAddPlaylist(data: widget.data, id: widget.id),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String getsongName(String song) {
    List<String> pathSegments = song.split('/');
    String songName = pathSegments.last;
    return songName;
  }
}
