import 'package:flutter/services.dart';
import 'package:path/path.dart';

class AssetBookReader {
  static const String _assetsPath = 'assets';
  static const String _bookFolderPath = 'books';
  static Future<String> loadContent({required String bookID}) async {
    final path = join(_assetsPath, _bookFolderPath, '$bookID.html');
    return await rootBundle.loadString(path);
  }
}
