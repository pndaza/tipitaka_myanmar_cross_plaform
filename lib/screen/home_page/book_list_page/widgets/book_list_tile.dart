import 'package:flutter/material.dart';

import '../../../../models/book.dart';


class BookListTile extends StatelessWidget {
  const BookListTile({Key? key, required this.book, this.onTap}) : super(key: key);
  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      shadowColor: Colors.brown,
      elevation: 4.0,
      child: ListTile(
        title: Text(
          book.name,
          style: const TextStyle(fontSize: 22),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        onTap: onTap,
      ),
    );
  }
}
