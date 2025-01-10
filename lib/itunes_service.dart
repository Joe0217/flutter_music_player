import 'package:dio/dio.dart';
import 'dart:convert';
import 'song.dart';

class ItunesService {
  final Dio dio = Dio();

  Future<List<Song>> fetchSongs(String searchTerm) async {
    try {
      Response response = await dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term': searchTerm,
          'limit': '100',
          'media': 'music',
        },
      );
      if (response.data != null) {
        Map data = json.decode(response.data);
        List<dynamic> dataList = data!['results'];
        return dataList.map((e) => Song.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      // Handle network errors
      throw e;
    }
  }
}
