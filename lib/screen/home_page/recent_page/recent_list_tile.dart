import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_myanmar/models/recent.dart';

class RecentListTile extends StatelessWidget {
  const RecentListTile(
      {Key? key, required this.recent, this.onTap, this.onDelete})
      : super(key: key);
  final Recent recent;
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
                  title: Text(recent.bookName!),
                  trailing: SizedBox(
                    width: 105,
                    child: Text(
                      recent.pageNumber.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                )));
  }
}
