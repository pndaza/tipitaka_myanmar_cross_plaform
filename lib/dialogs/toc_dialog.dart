import 'package:flutter/material.dart';

import '../models/toc.dart';

class TocDialog extends StatelessWidget {
  final List<Toc> tocs;

  const TocDialog({Key? key, required this.tocs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            const Text(
              'မာတိကာ',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ))
          ]),
          const Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: tocs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: tocs[index].toTocItem().build(context),
                  onTap: () => Navigator.pop(context, tocs[index]),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1, indent: 8.0, endIndent: 8.0);
              },
            ),
          )
        ],
      ),
    );
  }
}
