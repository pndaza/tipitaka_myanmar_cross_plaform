import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';
import 'package:provider/provider.dart';
import 'book_page.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key, required this.pages}) : super(key: key);
  final List<String> pages;

  @override
  Widget build(BuildContext context) {
    debugPrint('page count: ${pages.length}');
    return PageView.builder(
      itemCount: pages.length,
      itemBuilder: (_, index) => BookPage(
        content: pages[index],
      ),
      controller: context.read<ReaderViewController>().pageController,
      onPageChanged: context.read<ReaderViewController>().onPageChanged,
    );
  }
}
