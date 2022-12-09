import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/basic_state.dart';
import '../../repositories/database.dart';
import '../../widgets/loading_view.dart';
import 'reader_view_controller.dart';
import 'widgets/book_control_bar.dart';
import 'widgets/book_view.dart';
import 'widgets/reader_app_bar.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({
    Key? key,
    required this.bookId,
    required this.initialPage,
    this.textToHightlight = '',
    this.isOpenFromDeepLink = false,
  }) : super(key: key);

  final String bookId;
  final int initialPage;
  final String textToHightlight;
  final bool isOpenFromDeepLink;

  @override
  Widget build(BuildContext context) {
    return Provider<ReaderViewController>(
        create: (_) => ReaderViewController(
            bookId: bookId,
            initialPage: initialPage,
            databaseHelper: DatabaseHelper()),
        builder: (_, __) {
          //use builder to obtain a BuildContext descendant of the provider
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
                    appBar: ReaderAppBar(
                      title: viewController.book.name,
                      isOpenFromDeepLink: isOpenFromDeepLink,
                    ),
                    body: BookView(
                      pages: viewController.pages,
                      textToHighlight: textToHightlight,
                    ),
                    bottomNavigationBar: const BookControlBar(),
                  );
                });
          });
        });
  }
}
