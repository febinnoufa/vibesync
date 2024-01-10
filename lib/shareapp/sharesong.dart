import 'package:share/share.dart';
import 'package:vibesync/database/model/model.dart';

void shareSong(songshive song) {
    Share.shareFiles([song.name], text: 'Sharing ${song.name}');
  }