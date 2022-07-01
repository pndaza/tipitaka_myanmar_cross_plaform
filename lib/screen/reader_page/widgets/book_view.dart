import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'dart:io' show Platform;
import '../reader_view_controller.dart';
import 'book_page.dart';

class BookView extends StatefulWidget {
  const BookView({Key? key, required this.pages, this.textToHighlight = ''})
      : super(key: key);
  final List<String> pages;
  final String textToHighlight;

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  late final ItemPositionsListener itemPositionsListener;

  @override
  void initState() {
    super.initState();

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    itemPositionsListener = ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      // final firstIndex = itemPositionsListener.itemPositions.value.first.index;
      final lastIndex = itemPositionsListener.itemPositions.value.last.index;
      final currentPage =
          context.read<ReaderViewController>().currentPage.value;

      if (currentPage != lastIndex) {
        debugPrint('scrolled to next or previous page');
        context.read<ReaderViewController>().onPageChanged(lastIndex);
      }
    });
    }

  }

  @override
  Widget build(BuildContext context) {
    debugPrint('page count: ${widget.pages.length}');

    final viewController = context.read<ReaderViewController>();

    // desktop

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return ScrollablePositionedList.builder(
        itemScrollController: viewController.itemScrollController,
        itemPositionsListener: itemPositionsListener,
        initialScrollIndex: viewController.currentPage.value - 1,
        itemCount: widget.pages.length,
        itemBuilder: (_, index) {
          return BookPage(
            pageContent: widget.pages[index],
            pageNumber: index + 1,
            textToHighlight: widget.textToHighlight,
          );
        },
      );
    }

    // mobile
    return PageView.builder(
      physics: const PageScrollPhysics(),
      itemCount: widget.pages.length,
      itemBuilder: (_, index) {
        return BookPage(
          pageContent: widget.pages[index],
          pageNumber: index + 1,
          textToHighlight: widget.textToHighlight,
        );
      },
      controller: context.read<ReaderViewController>().pageController,
      onPageChanged: context.read<ReaderViewController>().onPageChanged,
    );
  }
}
