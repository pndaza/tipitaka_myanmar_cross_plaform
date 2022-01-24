import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ReaderAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return AppBar(
      title: Text(title),
      // centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: context.read<ReaderViewController>().onIncreaseButtonClicked),
        IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: context.read<ReaderViewController>().onDecreaseButtonClicked),
        IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: context.read<ReaderViewController>().onAddBookmarkButtonClicked),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

}
