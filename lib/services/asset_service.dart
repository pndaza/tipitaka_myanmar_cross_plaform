import 'package:flutter/services.dart';

class AssetBookReader {
  static const String _assetsPath = 'assets';
  static const String _bookFolderPath = 'books';
  static Future<String> loadContent({required String bookID}) async {
    final path = '$_assetsPath/$_bookFolderPath/$bookID.html';
    return await rootBundle.loadString(path);
  }
}
