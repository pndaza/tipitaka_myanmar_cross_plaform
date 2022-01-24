import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/models/recent.dart';
import 'package:tipitaka_myanmar/screen/home_page/recent_page/recent_list_tile.dart';
import 'package:tipitaka_myanmar/screen/home_page/recent_page/recent_page_view_controller.dart';

class RecentlistView extends StatelessWidget {
  const RecentlistView({Key? key, required this.recents}) : super(key: key);
  final List<Recent> recents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recents.length,
      itemBuilder: (_, index) => RecentListTile(
        recent: recents.elementAt(index),
        onTap: () => context
            .read<RecentPageViewController>()
            .onRecentItemClicked(context, recents.elementAt(index)),
        onDelete: () => context
            .read<RecentPageViewController>()
            .onDeleteActionOfRecentItem(recents.elementAt(index)),
      ),
    );
  }
}
