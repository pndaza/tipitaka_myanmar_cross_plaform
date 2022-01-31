import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/data/basic_state.dart';
import 'package:tipitaka_myanmar/repositories/database.dart';
import 'package:tipitaka_myanmar/widgets/loading_view.dart';

import 'bookmark_list_view.dart';
import 'bookmark_page_view_controller.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<BookmarkPageViewController>(
        create: (_) =>
            BookmarkPageViewController(databaseHelper: DatabaseHelper()),
        builder: (context, __) => Scaffold(
              appBar: AppBar(
                title: const Text('မှတ်စုများ'),
                actions: [
                  IconButton(
                      onPressed: ()=>context
                          .read<BookmarkPageViewController>()
                          .onClickedDeleteButton(context),
                      icon: const Icon(Icons.delete))
                ],
              ),
              body: ValueListenableBuilder<StateStaus>(
                  valueListenable:
                      context.watch<BookmarkPageViewController>().state,
                  builder: (_, state, __) {
                    if (state == StateStaus.loading) {
                      return const LoadingView();
                    }

                    if (state == StateStaus.nodata) {
                      return const Center(
                        child: Text('မှတ်စုများ မရှိသေးပါ'),
                      );
                    }
                    return BookmarklistView(
                        bookmarks: context
                            .watch<BookmarkPageViewController>()
                            .bookmarks);
                  }),
            ));
  }
}
