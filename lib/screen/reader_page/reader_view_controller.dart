import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/basic_state.dart';
import '../../data/constants.dart';
import '../../data/shared_pref_client.dart';
import '../../dialogs/goto_dialog.dart';
import '../../dialogs/simple_input_dialog.dart';
import '../../dialogs/toc_dialog.dart';
import '../../models/book.dart';
import '../../models/bookmark.dart';
import '../../models/recent.dart';
import '../../models/toc.dart';
import '../../repositories/book_dao.dart';
import '../../repositories/book_repo.dart';
import '../../repositories/bookmark_dao.dart';
import '../../repositories/bookmark_repo.dart';
import '../../repositories/database.dart';
import '../../repositories/paragraph_repo.dart';
import '../../repositories/recent_dao.dart';
import '../../repositories/recent_repo.dart';
import '../../repositories/toc_repo.dart';

class ReaderViewController {
  ReaderViewController(
      {required this.bookId,
      required this.initialPage,
      required this.databaseHelper}) {
    _init();
  }
  final String bookId;
  final int initialPage;
  final DatabaseHelper databaseHelper;

  final _state = ValueNotifier<StateStaus>(StateStaus.loading);
  ValueNotifier<StateStaus> get state => _state;

  late final ValueNotifier<int> _currentPage;
  ValueNotifier<int> get currentPage => _currentPage;

  late final ValueNotifier<double> _fontSize;
  ValueNotifier<double> get fontSize => _fontSize;

  late final Book book;
  final List<String> pages = [];
  late final int _firstParagraph;
  late final int _lastParagraph;

  late final PageController pageController;
  late final ItemScrollController itemScrollController;

  void _init() async {
    _currentPage = ValueNotifier(initialPage);
    // pageview index starts at 0
    pageController = PageController(initialPage: initialPage - 1);
    itemScrollController = ItemScrollController();

    await _loadBookInfo();
    await _loadParagraphInfo();
    pages.addAll(await _loadPages());
    _fontSize = ValueNotifier(SharedPreferenceClient.fontSize);
    _state.value = StateStaus.data;
    await _saveToRecent();
  }

  void dispose() {
    _state.dispose();
    _currentPage.dispose();
    _fontSize.dispose();
  }

  Future<void> _loadBookInfo() async {
    final BookRepository repository =
        DatabaseBookRepository(databaseHelper, BookDao());
    book = await repository.fetchBookInfo(bookId);
  }

  Future<List<String>> _loadPages() async {
    final pageBreakMarker = RegExp(r'--+');
    var content = await rootBundle.loadString(join(
        AssetsInfo.baseAssetsPath, AssetsInfo.bookAssetPath, bookId + '.html'));
    content = _removetTitleTag(content);
    return content.split(pageBreakMarker);
  }

  String _removetTitleTag(String content) {
    return content.replaceAll(RegExp(r'<title>.+</title>'), '');
  }

  Future<void> _loadParagraphInfo() async {
    final repo = ParagraphDatabaseRepository(databaseHelper);
    _firstParagraph = await repo.getFirstParagraph(bookId);
    _lastParagraph = await repo.getLastParagraph(bookId);
  }

  Future<int> _getPageNumber({required int paragraphNumber}) async {
    final repo = ParagraphDatabaseRepository(databaseHelper);
    return await repo.getPageNumber(bookId, paragraphNumber);
  }

  void onPageChanged(int value) async {
    _currentPage.value = value + 1;
    await _saveToRecent();
  }

  void onSliderPageChanged(double value) async {
    _currentPage.value = value.round();
    debugPrint('current page: ${_currentPage.value}');
    // pageview start at index 0
    if (Platform.isAndroid || Platform.isIOS) {
      pageController.jumpToPage(_currentPage.value - 1);
    } else {
      itemScrollController.jumpTo(index: _currentPage.value - 1);
    }
    await _saveToRecent();
  }

  Future<void> onGotoButtonClicked(BuildContext context) async {
    final response = await showDialog<GotoDialogResult>(
      context: context,
      builder: (BuildContext context) => GotoDialog(
        firstPage: book.firstPage!,
        lastPage: book.lastPage!,
        firstParagraph: _firstParagraph,
        lastParagraph: _lastParagraph,
      ),
    );

    if (response != null) {
      final int pageNumber = response.type == GotoType.page
          ? response.number
          : await _getPageNumber(paragraphNumber: response.number);
      _currentPage.value = pageNumber;
      if (Platform.isAndroid || Platform.isIOS) {
        pageController.jumpToPage(_currentPage.value - 1);
      } else {
        itemScrollController.jumpTo(index: _currentPage.value - 1);
      }
    }
  }

  Future<List<Toc>> _fetchToc() async {
    final tocRepository = TocDatabaseRepository(databaseHelper);
    return await tocRepository.getTocs(bookId);
  }

  Future<void> onTocButtonClicked(BuildContext context) async {
    final tocs = await _fetchToc();
    final toc = await showBarModalBottomSheet<Toc>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context) {
          return TocDialog(tocs: tocs);
        });
    if (toc != null) {
      _currentPage.value = toc.pageNumber;
      if (Platform.isAndroid || Platform.isIOS) {
        pageController.jumpToPage(_currentPage.value - 1);
      } else {
        itemScrollController.jumpTo(index: _currentPage.value - 1);
      }
    }
  }

  void onIncreaseButtonClicked() {
    _fontSize.value++;
    _saveFontSize(_fontSize.value);
  }

  void onDecreaseButtonClicked() {
    _fontSize.value--;
    _saveFontSize(_fontSize.value);
  }

  void _saveFontSize(double value) {
    SharedPreferenceClient.fontSize = value;
  }

  Future<void> _saveToRecent() async {
    final RecentRepository recentRepository =
        RecentDatabaseRepository(databaseHelper, RecentDao());
    await recentRepository
        .insertOrReplace(Recent(bookID: bookId, pageNumber: currentPage.value));
  }

  void onAddBookmarkButtonClicked(BuildContext context) async {
    // todo

    final note = await _showAddBookmarkDialog(context);
    if (note != null && note.isNotEmpty) {
      _saveToBookmarks(note);
    }
  }

  Future<String?> _showAddBookmarkDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleInputDialog(
          hintText: 'မှတ်လိုသောစာသား ထည့်ပါ',
          cancelLabel: 'မမှတ်တော့ဘူး',
          okLabel: 'မှတ်မယ်',
        );
      },
    );
  }

  Future<void> _saveToBookmarks(String note) async {
    final repo = BookmarkDatabaseRepository(databaseHelper, BookmarkDao());
    final bookmark =
        Bookmark(bookID: bookId, pageNumber: _currentPage.value, note: note);
    await repo.insert(bookmark);
  }
}
