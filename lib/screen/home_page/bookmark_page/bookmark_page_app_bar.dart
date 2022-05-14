import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';
import 'package:tipitaka_myanmar/widgets/multi_value_listenable_builder.dart';

import 'bookmark_page_view_controller.dart';

class BookmarkPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookmarkPageAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookmarkPageViewController>();
    return ValueListenableBuilder2<bool, List<int>>(
        first: controller.isSelectionMode,
        second: controller.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          if (!isSelectionMode || controller.selectedItems.value.isEmpty) {
            return AppBar(
              title: const Text('မှတ်စုများ'),
              centerTitle: true,
            );
          } else {
            return AppBar(
              leading: IconButton(
                  onPressed: controller.onCancelButtonClicked,
                  icon: const Icon(Icons.cancel_outlined)),
              title: Text('${MmNumber.get(selectedItems.length)} ခု မှတ်ထား'),
              actions: <Widget>[
                // select all button
                IconButton(
                    onPressed: controller.onSelectAllButtonClicked,
                    icon: Icon(
                      Icons.select_all_outlined,
                      color: controller.bookmarks.length == selectedItems.length
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary,
                    )),
                // delete button
                IconButton(
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () => controller.onDeleteButtonClicked(context),
                    icon: const Icon(Icons.delete_outline_outlined)),
              ],
            );
          }
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
