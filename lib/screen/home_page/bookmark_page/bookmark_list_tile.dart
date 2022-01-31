import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_myanmar/models/bookmark.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';

class BookmarkListTile extends StatelessWidget {
  // final BookmarkPageViewModel bookmarkViewmodel;
  // final int index;

  const BookmarkListTile(
      {Key? key, required this.bookmark, this.onTap, this.onDelete})
      : super(key: key);
  final Bookmark bookmark;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              //label: 'Archive',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                if (onDelete != null) onDelete!();
              },
            ),
          ],
        ),
        child: Builder(
            builder: (context) => ListTile(
                  onTap: () {
                    if (onTap != null) onTap!();
                  },
                  title: Text(bookmark.note, style: const TextStyle(fontSize: 20),),
                  subtitle: Text(bookmark.bookName!),
                  trailing: SizedBox(
                    width: 100,
                    child: Text(
                      MmNumber.get(bookmark.pageNumber),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                )));
  }
}
