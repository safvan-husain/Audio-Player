import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AudioDownloadService {
  void fetchData({
    required ytId,
    required Function(String url) onMp3Generated,
    required Function(String s) onFailure,
  }) async {
    String? videoId = _extractVideoId(ytId);
    if (videoId != null) {
      var url = Uri.parse(
          'https://youtube-mp3-download1.p.rapidapi.com/dl?id=${_extractVideoId(ytId)}');
      var response = await http.get(url, headers: {
        'X-RapidAPI-Key': 'db4481324bmshcf9f9042b18dde8p19c282jsn915257766019',
        'X-RapidAPI-Host': 'youtube-mp3-download1.p.rapidapi.com'
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        onMp3Generated(jsonResponse['link']);
        log(jsonResponse['link']);
      } else {
        onFailure('Could not Covert to Mp3');
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      onFailure('Url should be from youtube');
    }
  }

//extract video id
//if url is not from youtube return [null].
  String? _extractVideoId(String url) {
    log(url);
    var uri = Uri.parse(url);
    if (!(uri.host.contains('youtube.com') || uri.host.contains('youtu.be'))) {
      return null;
    }
    var videoId = uri.queryParameters['v'];

    if (videoId == null && uri.pathSegments.isNotEmpty) {
      videoId = uri.pathSegments[0];
    }
    if (videoId != null) {
      log(videoId);
      return videoId;
    } else {
      throw ('url id null');
    }
  }
}
