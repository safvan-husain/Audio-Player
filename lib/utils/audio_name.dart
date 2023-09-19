import 'dart:async';
import 'dart:developer';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/audio_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

//extract the audio name from the file path
String extractFileName(String filePath) {
  final fileNameWithExtension = path.basename(filePath);
  final fileName = path.basenameWithoutExtension(fileNameWithExtension);
  return fileName;
}

Future<void> getFilePath() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'ogg'],
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        log(file.path!);
        DataBaseService dataBaseService = DataBaseService();
        await dataBaseService.insertMusicPath(file.path!);
      }
      // file = result.files.first;
      // final AudioPlayer audioPlayer = AudioPlayer();
      // await audioPlayer.play(DeviceFileSource(file.path!));
      // AudioLogger.logLevel = AudioLogLevel.info;
    } else {
      log('User canceled the picker');
    }
  } catch (e) {
    print("Error picking file: " + e.toString());
  }
}
