import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../reader_view_controller.dart';
import 'book_page.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key, required this.pages, this.textToHighlight = ''})
      : super(key: key);
  final List<String> pages;
  final String textToHighlight;

  @override
  Widget build(BuildContext context) {
    debugPrint('page count: ${pages.length}');
    return PageView.builder(
      physics: const PageScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (_, index) {
        return BookPage(
          pageContent: pages[index],
          pageNumber: index + 1,
          textToHighlight: textToHighlight,
        );
      },
      controller: context.read<ReaderViewController>().pageController,
      onPageChanged: context.read<ReaderViewController>().onPageChanged,
    );
  }
}
