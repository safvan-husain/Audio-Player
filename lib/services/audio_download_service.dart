import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AudioDownloadService {
  void fetchData(String ytId, Function(String url) onMp3Generated,
      Function() onFailure) async {
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
      onFailure();
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  String _extractVideoId(String url) {
    var uri = Uri.parse(url);
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
