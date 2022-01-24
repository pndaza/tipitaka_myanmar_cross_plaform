import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:tipitaka_myanmar/data/shared_pref_client.dart';

import '../../data/basic_state.dart';
import '../../data/constants.dart';
import '../../dialogs/goto_dialog.dart';
import '../../dialogs/toc_dialog.dart';
import '../../models/book.dart';
import '../../models/toc.dart';
import '../../repositories/book_dao.dart';
import '../../repositories/book_repo.dart';
import '../../repositories/database.dart';
import '../../repositories/paragraph_repo.dart';
import '../../repositories/toc_repo.dart';

class ReaderViewController {
  ReaderViewController({required this.bookId, required this.initialPage}) {
    _init();
  }
  final String bookId;
  final int initialPage;

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

  void _init() async {
    _currentPage = ValueNotifier(initialPage);
    // pageview index starts at 0
    pageController = PageController(initialPage: initialPage - 1);

    await _loadBookInfo();
    await _loadParagraphInfo();
    pages.addAll(await _loadPages());
    _fontSize = ValueNotifier(SharedPreferenceClient.fontSize);
    _state.value = StateStaus.data;
  }

  Future<void> _loadBookInfo() async {
    final BookRepository repository =
        DatabaseBookRepository(DatabaseHelper(), BookDao());
    book = await repository.fetchBookInfo(bookId);
  }

  Future<List<String>> _loadPages() async {
    String pageBreakMarker = '--';
    final content = await rootBundle.loadString(join(
        AssetsInfo.baseAssetsPath, AssetsInfo.bookAssetPath, bookId + '.html'));
    return content.split(pageBreakMarker);
  }

  Future<void> _loadParagraphInfo() async {
    final repo = ParagraphDatabaseRepository(DatabaseHelper());
    _firstParagraph = await repo.getFirstParagraph(bookId);
    _lastParagraph = await repo.getLastParagraph(bookId);
  }

  Future<int> _getPageNumber({required int paragraphNumber}) async {
    final repo = ParagraphDatabaseRepository(DatabaseHelper());
    return await repo.getPageNumber(bookId, paragraphNumber);
  }

  void onPageChanged(int value) {
    _currentPage.value = value + 1;
  }

  void onSliderPageChanged(double value) {
    _currentPage.value = value.round();
    debugPrint('current page: ${_currentPage.value}');
    // pageview start at index 0
    pageController.jumpToPage(_currentPage.value - 1);
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
      pageController.jumpToPage(_currentPage.value - 1);
    }
  }

  Future<List<Toc>> _fetchToc() async {
    final databaseHelper = DatabaseHelper();
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
      pageController.jumpToPage(_currentPage.value - 1);
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

  void onAddBookmarkButtonClicked() {
    // todo
    /*
        final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return ThemeConsumer(
          child: SimpleInputDialog(
            hintText: 'မှတ်လိုသောစာသား ထည့်ပါ',
            cancelLabel: 'မမှတ်တော့ဘူး',
            okLabel: 'မှတ်မယ်',
          ),
        );
      },
    );
    print(note);
    if (note != null) {
      vm.saveToBookmark(note);
    }
    */
  }
}
