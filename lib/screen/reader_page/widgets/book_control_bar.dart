import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';

import 'book_slider.dart';

class BookControlBar extends StatelessWidget {
  const BookControlBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readerViewController = context.watch<ReaderViewController>();
    return SizedBox(
      height: 56.0,
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              icon: const Icon(Icons.arrow_forward),
              onPressed: () =>
                  readerViewController.onGotoButtonClicked(context)),
          ValueListenableBuilder<int>(
              valueListenable: readerViewController.currentPage,
              builder: (_, currentPage, __) {
                return Expanded(
                    child: BookSlider(
                      key: Key(currentPage.toString()),
                  firstPage: readerViewController.book.firstPage!,
                  lastPage: readerViewController.book.lastPage!,
                  currentPage: currentPage,
                ));
              }),
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              icon: const Icon(Icons.toc),
              onPressed: () => readerViewController.onTocButtonClicked(context))
        ],
      ),
    );
  }
}
