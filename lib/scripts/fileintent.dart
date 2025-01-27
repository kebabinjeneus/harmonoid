import 'dart:io';
import 'package:flutter/services.dart';
import 'package:media_metadata_retriever/media_metadata_retriever.dart';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart' as path;

import 'package:harmonoid/scripts/collection.dart';
import 'package:harmonoid/main.dart';
import 'package:harmonoid/screens/home.dart';


FileIntent fileIntent;


const _methodChannel = const MethodChannel('com.alexmercerind.harmonoid/openFile');


class FileIntent {
  Screen startScreen;
  File openedFile;

  FileIntent({this.startScreen, this.openedFile});

  static Future<void> init() async {
    try {
      File file = await FileIntent._getOpenFile();
      fileIntent = new FileIntent(
        startScreen: Screen.nowPlaying,
        openedFile: file,
      );
    }
    catch(exception) {
      fileIntent = new FileIntent(
        startScreen: Screen.collection,
      );
    }
  }

  static Future<File> _getOpenFile() async {
    dynamic fileUri = await _methodChannel.invokeMethod('getOpenFile');
    File file = new File(
      path.join(
        '/storage/emulated/0/',
        fileUri.split(':').last,
      ),
    );
    print(file.path);
    if (await file.exists()) return file;
    else throw 'ERROR: No file openened.';
  }

  Future<void> play() async {
    MediaMetadataRetriever retriever = new MediaMetadataRetriever();
    await retriever.setFile(this.openedFile);
    Track track = Track.fromMap((await retriever.metadata).toMap());
    track.filePath = this.openedFile.path;
    track.albumArtId = -1;
    File albumArtFile = new File(path.join((await path.getExternalStorageDirectory()).path, 'albumArt${track.albumArtId}.png'));
    await albumArtFile.writeAsBytes(retriever.albumArt);
    await AudioService.start(
      backgroundTaskEntrypoint: backgroundTaskEntryPoint,
      androidNotificationChannelName: 'Harmonoid',
      androidNotificationColor: 0xFFFFFFFF,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidStopForegroundOnPause: true,
      androidNotificationChannelDescription: 'Harmonoid' 
    );
    List<MediaItem> queue = <MediaItem>[
      MediaItem(
        id: track.filePath,
        title: track.trackName,
        album: track.albumName,
        artist: track.trackArtistNames.join(', '),
        artUri: 'file://${albumArtFile.path}',
        extras: track.toMap(),
      ),
    ];
    AudioService.updateQueue(queue);
    AudioService.playFromMediaId(queue[0].id);
  }
}