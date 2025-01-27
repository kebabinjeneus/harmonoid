import 'dart:convert' as convert;
import 'package:harmonoid/language/constants.dart';
import 'package:http/http.dart' as http;

import 'package:harmonoid/scripts/collection.dart';
import 'package:harmonoid/scripts/configuration.dart';


Discover discover;


class Discover {
  String homeAddress;

  Discover(this.homeAddress);

  static Future<void> init({String homeAddress}) async {
    discover = new Discover(homeAddress);
  }

  Future<List<dynamic>> search(String keyword, String mode) async {
    List<dynamic> result = <dynamic>[];
    Uri uri = Uri.https(
      this.homeAddress,
      '/search', {
        'keyword': keyword,
        'mode': mode,
      },
    );
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        (convert.jsonDecode(response.body)[mode] as List).forEach((objectMap) {
          if (mode == Constants.STRING_ALBUM) result.add(Album.fromMap(objectMap));
          if (mode == Constants.STRING_TRACK) result.add(Track.fromMap(objectMap));
          if (mode == Constants.STRING_ARTIST) result.add(Artist.fromMap(objectMap));
        });
      }
      List<dynamic> searchRecents = configuration.discoverSearchRecent;
      if (searchRecents.length > 5) searchRecents.removeLast();
      await configuration.save(discoverSearchRecent: searchRecents);
      return result;
    }
    catch(exception) {
      throw 'Please check your internet connection';
    }
  }

  Future<List<Track>> albumInfo(Album album) async {
    List<Track> result = <Track>[];
    Uri uri = Uri.https(
      this.homeAddress,
      '/albumInfo', {
        'albumId': album.albumId,
      },
    );
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        (convert.jsonDecode(response.body)['tracks'] as List).forEach((objectMap) {
          result.add(Track.fromMap(objectMap));
        });
      }
      return result;
    }
    catch(exception) {
      throw 'Please check your internet connection';
    }
  }
}
