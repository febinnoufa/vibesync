import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibesync/database/boxx.dart';
import 'package:vibesync/database/model/model.dart';
import 'package:vibesync/tumbnail.dart';
import 'package:vibesync/videos/addplaylistvideo.dart';
import 'package:vibesync/videos/dbfunctions/recentlyfunc.dart';
import 'package:vibesync/videos/flick.dart';

// ignore: must_be_immutable
class Videoplaylistpage extends StatefulWidget {
  videoplaylist data;
  int id;

  Videoplaylistpage({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  State<Videoplaylistpage> createState() => VideoplaylistpageState();
}

class VideoplaylistpageState extends State<Videoplaylistpage> {
  final videoplaylistbox = Hive.openBox<videoplaylist>('videoplaylist');
  late videoplaylist foundvideoplaylist = videoplaylist(
      id: widget.id, name: widget.data.name, videos: widget.data.videos);

  @override
  void initState() {
    super.initState();

    chekevideoinplaylist();
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
            const Color.fromARGB(255, 36, 33, 33).withOpacity(0.9)
          ])),
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
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: FutureBuilder<Box<videoplaylist>>(
                      future: Hive.openBox<videoplaylist>('videoplaylist'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final box = snapshot.data!;
                          final playlistKey = 'key_${widget.data.name}';
                          // ignore: unused_local_variable
                          final videos = box.get(playlistKey)?.videos ?? [];
                          return widget.data.videos!.isNotEmpty
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.videos?.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final video = widget.data.videos?[index];

                                    if (video != null) {
                                      return Container(
                                        height: 65,
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: InkWell(
                                          child: ListTile(
                                            leading: ValueListenableBuilder<
                                                Uint8List?>(
                                              valueListenable:
                                                  generateThumbnailNotifier(
                                                      video),
                                              builder: (context, thumbnailData,
                                                  child) {
                                                if (thumbnailData != null) {
                                                  return Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.memory(
                                                        thumbnailData,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 50,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            title: Text(
                                              getvideoName(video),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: PopupMenuButton(
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                    child: Text('Play')),
                                                PopupMenuItem(
                                                    onTap: () {
                                                      //  toggleFavorite(context, , index);
                                                    },
                                                    child: const Text(
                                                        'Add favorite')),
                                                PopupMenuItem(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Delete video'),
                                                            content: const Text(
                                                                'Are you sure you  want to delete  this video from the playlist? '),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      foundvideoplaylist
                                                                          .videos!
                                                                          .removeAt(
                                                                              index);
                                                                      boxvideoplaylist.put(
                                                                          widget
                                                                              .id,
                                                                          foundvideoplaylist);
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Delete')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel'))
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child:
                                                        const Text('Delete')),
                                              ],
                                              child: const Icon(
                                                Icons.more_vert,
                                                color: Color.fromARGB(
                                                    255, 20, 20, 20),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            addToRecentlyPlayed(
                                                widget.data.videos![index]);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayer_Page(
                                                  videoUrl: video,
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
                                )
                              : const Center(
                                  child: Text(
                                    'Playlist Videos Is empty',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),

                  //   child:Video_List()
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
                builder: (context) => Videoaddplaylist(
                  data: widget.data,
                  id: widget.id,
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> chekevideoinplaylist() async {
    final Box<videoplaylist> videoplaylistbox =
        await Hive.openBox<videoplaylist>('videoplaylist');

    if (videoplaylistbox.isNotEmpty) {
      final List videoinwidget = widget.data.videos ?? [];
      final List<videoplaylist> playlist = videoplaylistbox.values.toList();

      for (String videpath in videoinwidget) {
        for (videoplaylist playlists in playlist) {
          if (playlists.videos != null &&
              playlists.videos!.contains(videpath)) {
            foundvideoplaylist = playlists;
            break;
          }
        }
      }
    }
  }

  String getvideoName(video) {
    List<String> pathSegments = video.split('/');
    String videoName = pathSegments.last;

    return videoName;
  }
}
