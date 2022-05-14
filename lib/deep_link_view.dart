import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/repositories/database.dart';
import 'package:tipitaka_myanmar/repositories/paragraph_repo.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_page.dart';

import 'screen/home_page/home_page.dart';

class DeepLinkView extends StatefulWidget {
  const DeepLinkView({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  _DeepLinkViewState createState() => _DeepLinkViewState();
}

class _DeepLinkViewState extends State<DeepLinkView> {
  String? bookId;
  String? paragraphNumber;
  late int pageNumber;

  @override
  void initState() {
    super.initState();
    bookId = parseBookId(widget.url);
    paragraphNumber = parseParagraphNumber(widget.url);

    //

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint(bookId);
      debugPrint(paragraphNumber);
      if (bookId != null && paragraphNumber != null) {
        ParagraphRepository repository =
            ParagraphDatabaseRepository(DatabaseHelper());
        final pageNumber = await repository.getPageNumber(
            bookId!, int.parse(paragraphNumber!));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    ReaderPage(bookId: bookId!, initialPage: pageNumber)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building deep link view');
    // use home so that user can go back to home screen
    // desire page will be route after building by using of
    // WidgetsBinding.instance?.addPostFrameCallback
    return const HomePage();
  }

  String? parseBookId(String url) {
    RegExp regexId = RegExp(r'\w+_\w+_\d+(_\d+)?');
    final matchId = regexId.firstMatch(url);
    return matchId?.group(0);
  }

  String? parseParagraphNumber(String url) {
    RegExp regexPage = RegExp(r'\d+$');
    final matchPage = regexPage.firstMatch(url);
    return matchPage?.group(0);
  }
}
