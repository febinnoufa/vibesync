import 'package:flutter/material.dart';

import 'package:vibesync/home.dart';
import 'package:vibesync/musics/favpagemusic.dart';
import 'package:vibesync/musics/musiclist.dart';
import 'package:vibesync/musics/musicplaylist.dart';
import 'package:vibesync/musics/searchsong.dart';

import 'package:vibesync/videos/homevideo.dart';

// ignore: camel_case_types
class Music_Home extends StatefulWidget {
  const Music_Home({super.key});

  @override
  State<Music_Home> createState() => _Music_HomeState();
}

// ignore: camel_case_types
class _Music_HomeState extends State<Music_Home> {
  bool issearchclicked = false;

  final TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 83, 214, 193),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: ListTile(
                  title: issearchclicked
                      ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: searchcontroller,
                            onChanged: (context) {},
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 20, 16, 12),
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                                border: InputBorder.none,
                                hintText: 'Search'),
                          ),
                        )
                      : const Text(
                          'SONGS',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color.fromARGB(255, 15, 15, 15)),
                        ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Searchsong(),
                            ));
                      },
                      icon: Icon(
                        issearchclicked ? Icons.close : Icons.search,
                        color: Colors.white,
                      )),
                ),
              ),
              const TabBar(
                labelColor: Colors.black,
                dividerColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Songs',
                  ),
                  Tab(text: 'Playlist'),
                  Tab(text: 'Favorite'),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 170, 166, 166),
                thickness: 1,
              ),
              Expanded(
                child: TabBarView(children: [
                  const MusicList(),
                  Playlist_music(
                    selectedSongs: const [],
                  ),
                  const Song_Fav()
                ]),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_sharp),
              label: 'Musics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ondemand_video_sharp),
              label: 'Videos',
            ),
          ],
          selectedItemColor: const Color.fromARGB(255, 232, 6, 6),
          unselectedItemColor: const Color.fromARGB(255, 22, 22, 22),
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homescreen(),
                  ));
            }
            if (index == 2) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeVideo(),
                  ));
            }
          },
        ),
      ),
    );
  }
}
