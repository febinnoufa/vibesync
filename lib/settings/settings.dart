import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibesync/settings/pryvacy.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double rating = 0;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 16, 5, 1),
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              leading: Text(
                'General Settings',
                style: TextStyle(
                  color: Color.fromARGB(255, 187, 183, 183),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pryvacypage(),
                    ),
                  );
                },
                child: const ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color.fromARGB(255, 237, 63, 63),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    'Read our terms and contitions carefully',
                    style: TextStyle(
                      color: Color.fromARGB(255, 109, 108, 108),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Rate Us'),
                        content: SizedBox(
                          width: 250,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Would you like to rate our app?'),
                              const SizedBox(height: 20),
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 1,
                                itemSize: 35,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                onRatingUpdate: (value) {
                                  setState(() {
                                    rating = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              _storeRating(rating);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const ListTile(
                  title: Text(
                    'Rate Us',
                    style: TextStyle(
                      color: Color.fromARGB(255, 237, 63, 63),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Please take a moment to rate it',
                      style: TextStyle(
                        color: Color.fromARGB(255, 109, 108, 108),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )),
          const SizedBox(height: 20,),
           const ListTile(
         title: Text(
                'Acceptance',
                 style: TextStyle(
                      color: Color.fromARGB(255, 237, 63, 63),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 10),
                child: ReadMoreText(
                  "Downloading our app, playing music, sharing files, playing video, or otherwise accessing or using our services will constitute your accepting this Agreement and consent to contract with us electronically. We may revise and update this Agreement, in our sole direction. And we will notify you that we have updated our terms. If you continue to use our services, it means you accept the updated version of this Agreement.",
                  trimLines: 3,
                  style: TextStyle(
                    color: Color.fromARGB(255, 109, 108, 108),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ) ,
        ),
            const SizedBox(height: 30),
           const ListTile(title: Text(
                'Our Services',
                style: TextStyle(
                  color: Color.fromARGB(255, 237, 63, 63),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle:  Padding(
                padding: EdgeInsets.only(top: 10),
                child: ReadMoreText(
                "We grant you access to our services. You can use our app to play music, share files, create your stickers or any other functionality that we may provide.",
                trimLines: 3,
                style: TextStyle(
                  color: Color.fromARGB(255, 109, 108, 108),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
              ),
              ),
            
           
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rating = prefs.getDouble('userRating') ?? 0;
    });
  }

  Future<void> _storeRating(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('userRating', value);
  }
}
