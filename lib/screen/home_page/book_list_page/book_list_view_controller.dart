import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path/path.dart';

import '../../../data/basic_state.dart';
import '../../../models/book.dart';
import '../../../repositories/book_dao.dart';
import '../../../repositories/book_repo.dart';
import '../../../repositories/database.dart';
import '../../reader_page/reader_page.dart';

class BookListViewController {
  BookListViewController() {
    _init();
  }

  final _state = ValueNotifier<StateStaus>(StateStaus.loading);
  ValueNotifier<StateStaus> get state => _state;

  final List<Book> _books = [];
  List<Book> get books => _books;

  void _init() {
    _loadBooks().then((value) {
      _books.addAll(value);
      _state.value = StateStaus.data;
    });
  }

  void dispose() {
    _state.dispose();
  }

  Future<List<Book>> _loadBooks() async {
    BookRepository repository =
        DatabaseBookRepository(DatabaseHelper(), BookDao());
    return await repository.fetchBooks();
  }

  void onBookItemClicked(BuildContext context, Book book) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                  bookId: book.id,
                  initialPage: book.firstPage!,
                )));
  }

  Future<void> onInfoIconClicked({required BuildContext context}) async {
    final infoText = await _loadInfoText();
    showAboutDialog(
        context: context,
        applicationName: 'ပိဋကတ်သုံးပုံ ပါဠိတော် မြန်မာပြန်',
        applicationVersion: 'ဗားရှင်း။ ။ ၂.၁.၀',
        children: [
          HtmlWidget(infoText)
        ]);
  }

  Future<String> _loadInfoText() async {
    return await rootBundle.loadString(join('assets', 'info.html'));
  }
}
