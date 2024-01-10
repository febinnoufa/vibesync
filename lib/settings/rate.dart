import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Ratepage extends StatefulWidget {
  const Ratepage({super.key});

  @override
  State<Ratepage> createState() => _RatepageState();
}

class _RatepageState extends State<Ratepage> {
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Rating'),
      ),
      body: Center(
        child: RatingBar.builder(
          minRating: 1,
          itemSize: 45,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (value) => setState(() {
            rating = rating;
          }),
        ),
      ),
    );
  }
}
