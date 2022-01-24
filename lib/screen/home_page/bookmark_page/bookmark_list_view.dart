import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/models/bookmark.dart';
import 'package:provider/provider.dart';
import 'bookmark_list_tile.dart';
import 'bookmark_page_view_controller.dart';

class BookmarklistView extends StatelessWidget {
  const BookmarklistView({Key? key, required this.bookmarks}) : super(key: key);
  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (_, index) => BookmarkListTile(
        bookmark: bookmarks.elementAt(index),
        onTap: () => context
            .read<BookmarkPageViewController>()
            .onBookmarkItemClicked(context, bookmarks.elementAt(index)),
        onDelete: () => context
            .read<BookmarkPageViewController>()
            .onDeleteActionOfBookmarkItem(bookmarks.elementAt(index)),
      ),
    );
  }
}