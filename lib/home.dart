import 'package:flutter/material.dart';
import 'package:vibesync/musics/homemsuic.dart';
import 'package:vibesync/musics/musichoriz.dart';
import 'package:vibesync/musics/resentlyplayed.dart';
import 'package:vibesync/settings/pryvacy.dart';
import 'package:vibesync/settings/settings.dart';
import 'package:vibesync/shareapp/share.dart';
import 'package:vibesync/videos/homevideo.dart';
import 'package:vibesync/videos/horizlist.dart';
import 'package:vibesync/videos/recentlyplayed.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    LinearGradient myGradient = const LinearGradient(
      colors: [
        Color.fromRGBO(13, 167, 156, 0.659),
        Color.fromRGBO(134, 168, 231, 88),
        Color.fromRGBO(226, 124, 182, 100)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: myGradient,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/vibelogo.png',
                    height: 30,
                  ),
                  trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomeVideo(),
                                      ));
                                },
                                child: const Text('Go to Video')),
                            PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Music_Home(),
                                      ));
                                },
                                child: const Text('Go to Music')),
                            PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Pryvacypage(),
                                      ));
                                },
                                child: const Text('Terms and policy')),
                            PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Settings(),
                                      ));
                                },
                                child: const Text('Settings')),
                            PopupMenuItem(
                              onTap: () {
                                shareApp();
                              },
                              child: const Text('Share App'),
                            ),
                          ],
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recently Played Songs',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color.fromARGB(255, 45, 57, 62),
                    ),
                  ),
                  const SizedBox(width: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Recentlyplaysong(),
                          ));
                    },
                    child: const Text('View More'),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Expanded(child: Music_hor_list()),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recently Played Video',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color.fromARGB(255, 45, 57, 62)),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Resentlyplayedvideo(),
                            ));
                      },
                      child: const Text('View More'))
                ],
              ),
              const Expanded(child: VideohorList()),
              const SizedBox(
                height: 100,
              )
            ],
          ),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Music_Home(),
                ));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeVideo(),
                ));
          }
        },
      ),
    );
  }
}
