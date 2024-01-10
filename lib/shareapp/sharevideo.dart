import 'package:share/share.dart';

void shareVideo(String videoPath) {
  Share.shareFiles(
    [videoPath],
  );
}
