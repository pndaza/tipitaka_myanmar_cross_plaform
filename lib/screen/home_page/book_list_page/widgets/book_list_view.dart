import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:tipitaka_myanmar/models/book.dart';
import 'package:tipitaka_myanmar/screen/home_page/book_list_page/book_list_view_controller.dart';

import 'book_list_tile.dart';
import 'header_view.dart';

class BookListView extends StatelessWidget {
  const BookListView({Key? key, required this.books}) : super(key: key);
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Book, String>(
      elements: books,
      groupBy: (element) =>
          '${element.categoryId}--${element.categoryName}',
      itemComparator: (element1, element2) =>
          element1.id.compareTo(element2.id),
      groupSeparatorBuilder: (String groupByValue) =>
          HeaderView(categoryName: groupByValue),
      itemBuilder: (context, element) => BookListTile(
        book: element,
        onTap: () {
          context.read<BookListViewController>().onBookItemClicked(context, element);
        },
      ),
    );
  }
}
