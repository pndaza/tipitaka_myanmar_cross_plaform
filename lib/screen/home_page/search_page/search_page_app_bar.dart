import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_page_view_controller.dart';

class SearchPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchPageAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: context.watch<SearchPageViewController>().title,
      builder: (_, title,__) {
        return AppBar(
          title: Text(title),
        );
      }
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

}
