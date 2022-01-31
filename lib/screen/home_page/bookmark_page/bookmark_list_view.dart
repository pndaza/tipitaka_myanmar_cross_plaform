import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_myanmar/models/bookmark.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/widgets/multi_value_listenable_builder.dart';
import 'bookmark_list_tile.dart';
import 'bookmark_page_view_controller.dart';

class BookmarklistView extends StatelessWidget {
  const BookmarklistView({Key? key, required this.bookmarks}) : super(key: key);
  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookmarkPageViewController>();
    final bookmarks = controller.bookmarks;
    return ValueListenableBuilder2<bool, List<int>>(
        first: controller.isSelectionMode,
        second: controller.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              itemCount: bookmarks.length,
              itemBuilder: (_, index) => BookmarkListTile(
                bookmark: bookmarks.elementAt(index),
                isSelectingMode: isSelectionMode,
                isSelected: selectedItems.contains(index),
                onTap: () => controller.onBookmarkItemClicked(context, index),
                onLongPress: () =>
                    controller.onBookmarktemPressed(context, index),
                onDelete: () => controller
                    .onDeleteActionClicked(index),
              ),
              separatorBuilder: (_, __) => const Divider(),
            ),
          );
        });
      
  }
}
