import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vibesync/database/adapterregister.dart';
import 'package:vibesync/database/opendb.dart';
import 'package:vibesync/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await registerAdapter();
  await openBoxes();
  runApp(const VibeSync());
} 

class VibeSync extends StatelessWidget {
  const VibeSync({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screensplash(),
    );
  }
}
