import 'dart:convert';
import 'dart:developer';
import 'package:al_downloader/al_downloader.dart';
import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;

class AudioDownloadService {
  void fetchData(String ytId, Function(String url) onMp3Generated) async {
    // ALDownloader.initialize();
    // ALDownloader.configurePrint(true, frequentEnabled: false);
    var url = Uri.parse(
        'https://youtube-mp3-download1.p.rapidapi.com/dl?id=${extractVideoId(ytId)}');
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': 'db4481324bmshcf9f9042b18dde8p19c282jsn915257766019',
      'X-RapidAPI-Host': 'youtube-mp3-download1.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      onMp3Generated(jsonResponse['link']);
      log(jsonResponse['link']);
      // ALDownloader.download(
      //   jsonResponse['link'],
      //   directoryPath: ('/data/user/0/').replaceAll("'", "''"),
      //   fileName: '${jsonResponse['title']}',
      //   downloaderHandlerInterface:
      //       ALDownloaderHandlerInterface(progressHandler: (progress) {
      //     log('ALDownloader | download progress = $progress, url = $url\n');
      //   }, succeededHandler: () {
      //     DataBaseService().insertMusicPath(AudioModel(
      //       audioPath: ('/data/user/0/${jsonResponse['title']}.mp3')
      //           .replaceAll("'", "''"),
      //       waveformWrapper: null,
      //     ));
      //     log('ALDownloader | download succeeded, url = $url\n');
      //   }, failedHandler: () {
      //     log('ALDownloader | download failed, url = $url\n');
      //   }, pausedHandler: () {
      //     log('ALDownloader | download paused, url = $url\n');
      //   }),
      // );
      // print(jsonResponse['link']);
      // var file = await FileDownloader.downloadFile(
      //     notificationType: NotificationType.all,
      //     url: jsonResponse['link'],
      //     onProgress: (String? fileName, double progress) {
      //       print('FILE $fileName HAS PROGRESS $progress');
      //     },
      //     onDownloadCompleted: (String path) {
      //       print('FILE DOWNLOADED TO PATH: $path');
      //     },
      //     onDownloadError: (String error) {
      //       print('DOWNLOAD ERROR: $error');
      //     });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  String extractVideoId(String url) {
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
