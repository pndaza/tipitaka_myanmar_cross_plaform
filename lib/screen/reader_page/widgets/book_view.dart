import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'dart:io' show Platform;
import '../reader_view_controller.dart';
import 'book_page.dart';

class BookView extends StatefulWidget {
  const BookView({
    Key? key,
    required this.pages,
  }) : super(key: key);
  final List<String> pages;
  // final String textToHighlight;

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
      itemPositionsListener.itemPositions.addListener(_listenItemPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('page count: ${widget.pages.length}');

    final viewController = context.read<ReaderViewController>();

    // desktop

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: null),
        child: ScrollablePositionedList.builder(
          minCacheExtent: 500,
          itemScrollController: viewController.itemScrollController,
          itemPositionsListener: itemPositionsListener,
          initialScrollIndex: viewController.currentPage.value - 1,
          itemCount: widget.pages.length,
          itemBuilder: (_, index) {
            return BookPage(
              pageContent: widget.pages[index],
              pageNumber: index + 1,
              textToHighlight: viewController.textToHighlight,
            );
          },
        ),
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
          textToHighlight: viewController.textToHighlight,
        );
      },
      controller: context.read<ReaderViewController>().pageController,
      onPageChanged: context.read<ReaderViewController>().onPageChanged,
    );
  }

  void _listenItemPosition() {
        // if only one page exist in view, there in no need to update current page
    if (itemPositionsListener.itemPositions.value.length == 1) return;

        final currentPage =
            context.read<ReaderViewController>().currentPage.value;
    final upperPageInView = itemPositionsListener.itemPositions.value.first;
    final pageNumberOfUpperPage = upperPageInView.index + 1;
    final lowerPageInView = itemPositionsListener.itemPositions.value.last;
    final pageNumberOfLowerPage = lowerPageInView.index + 1;

    // scrolling down ( natural scrolling )
    //update lower page as current page
    if (lowerPageInView.itemLeadingEdge < 0.4 &&
        pageNumberOfLowerPage != currentPage) {
      debugPrint('recorded current page: $currentPage');
      debugPrint('lower page-height is over half');
      debugPrint('page number of it: $pageNumberOfLowerPage');
      context.read<ReaderViewController>().onPageChanged(pageNumberOfLowerPage -1 );
      return;
    }

    // scrolling up ( natural scrolling )
    if (upperPageInView.itemTrailingEdge > 0.6 &&
        pageNumberOfUpperPage != currentPage) {
      debugPrint('recorded current page: $currentPage');
      debugPrint('upper page-height is over half');
      debugPrint('page number of it: $pageNumberOfUpperPage');
      context.read<ReaderViewController>().onPageChanged(pageNumberOfUpperPage - 1);
      return;
    }
/*
        if (currentPage != lastIndex) {
          debugPrint('scrolled to next or previous page');
          context.read<ReaderViewController>().onPageChanged(lastIndex);
        }

*/
  }
}
