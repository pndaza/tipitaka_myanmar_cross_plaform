import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../models/search_result.dart';
import '../../../utils/mm_number.dart';

class SearchListTile extends StatelessWidget {
  final SearchResult result;
  final String textToHighlight;
  final VoidCallback? onClikded;

  const SearchListTile(
      {Key? key,
      required this.result,
      required this.textToHighlight,
      this.onClikded})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClikded,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${result.book.name}၊ နှာ - ${MmNumber.get(result.pageNumber)}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SubstringHighlight(
                text: result.description,
                textStyle: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyText2?.color!),
                term: textToHighlight,
                textStyleHighlight: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary),
              )
            ],
          ),
        ),
      ),
    );
  }
}
