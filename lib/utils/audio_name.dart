import 'package:path/path.dart' as path;

String extractFileName(String filePath) {
  final fileNameWithExtension = path.basename(filePath);
  final fileName = path.basenameWithoutExtension(fileNameWithExtension);
  return fileName;
}
