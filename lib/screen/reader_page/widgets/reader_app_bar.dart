import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_page/home_page.dart';
import '../reader_view_controller.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({
    Key? key,
    required this.title,
    required this.isOpenFromDeepLink,
  }) : super(key: key);

  final String title;
  final bool isOpenFromDeepLink;

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return AppBar(
      leading: IconButton(
        onPressed: () {
          if (isOpenFromDeepLink) {
            Navigator.pop(context);
            // back to homepage
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const HomePage()));
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(title),
      // centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed:
                context.read<ReaderViewController>().onIncreaseButtonClicked),
        IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed:
                context.read<ReaderViewController>().onDecreaseButtonClicked),
        IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () => context
                .read<ReaderViewController>()
                .onAddBookmarkButtonClicked(context)),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
