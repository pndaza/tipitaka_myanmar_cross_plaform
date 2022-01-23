import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/data/basic_state.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';
import 'package:tipitaka_myanmar/screen/reader_page/widgets/book_control_bar.dart';
import 'package:tipitaka_myanmar/screen/reader_page/widgets/book_view.dart';
import 'package:tipitaka_myanmar/screen/reader_page/widgets/reader_app_bar.dart';
import 'package:tipitaka_myanmar/widgets/loading_view.dart';

class ReaderPage extends StatelessWidget {
  final String bookId;
  final int initialPage;
  final String textToHightlight;
  const ReaderPage(
      {Key? key,
      required this.bookId,
      required this.initialPage,
      this.textToHightlight = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ReaderViewController>(
        create: (_) =>
            ReaderViewController(bookId: bookId, initialPage: initialPage),
        builder: (_, __) {
          return Builder(builder: (context) {
            final viewController = context.watch<ReaderViewController>();
            return ValueListenableBuilder(
                valueListenable: viewController.state,
                builder: (_, state, ___) {
                  if (state == StateStaus.loading) {
                    return const Material(child: LoadingView());
                  }
                  debugPrint('data loaded');
                  return Scaffold(
                    appBar: ReaderAppBar(title: viewController.book.name),
                    body: BookView(pages: viewController.pages),
                    bottomNavigationBar: const BookControlBar(),
                  );
                });
          });
        });
  }
}
