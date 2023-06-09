import 'package:path/path.dart' as path;

//extract the audio name from the file path
String extractFileName(String filePath) {
  final fileNameWithExtension = path.basename(filePath);
  final fileName = path.basenameWithoutExtension(fileNameWithExtension);
  return fileName;
}
