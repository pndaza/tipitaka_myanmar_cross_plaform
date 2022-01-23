import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/basic_state.dart';
import '../../../widgets/loading_view.dart';
import 'book_list_view_controller.dart';
import 'widgets/book_list_view.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<BookListViewController>(
      create: (_) => BookListViewController(),
      builder: (_, __) =>
          //use builder to obtain a BuildContext descendant of the provider
          Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('တိပိဋကမြန်မာ'),
            centerTitle: true,
          ),
          body: ValueListenableBuilder<StateStaus>(
            valueListenable: context.read<BookListViewController>().state,
            builder: (_, value, __) {
              if (value == StateStaus.loading) {
                return const LoadingView();
              }
              return BookListView(
                  books: context.read<BookListViewController>().books);
            },
          ),
        ),
      ),
    );
  }
}
