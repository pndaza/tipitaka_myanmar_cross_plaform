import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '../../data/basic_state.dart';
import '../../data/constants.dart';
import '../../models/book.dart';
import '../../repositories/book_repo.dart';
import '../../repositories/database.dart';

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

  late final Book book;
  final List<String> pages = [];

  late final PageController pageController;

  void _init() async {
    _currentPage = ValueNotifier(initialPage);
    // pageview index starts at 0
    pageController = PageController(initialPage: initialPage - 1);

    await _loadBookInfo();
    _loadPages().then((value) {
      pages.addAll(value);
      _state.value = StateStaus.data;
    });
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
    // todo
  }

  Future<void> onTocButtonClicked(BuildContext context) async {
    // todo
  }

  void onIncreaseButtonClicked() {
    // todo
  }

  void onDecreaseButtonClicked() {
    // todo
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

  /*
    void _openGotoDialog(BuildContext context, ReaderViewModel vm) async {
    final firstParagraph = await vm.getFirstParagraph();
    final lastParagraph = await vm.getLastParagraph();
    final gotoResult = await showDialog<GotoDialogResult>(
      context: context,
      builder: (BuildContext context) => GotoDialog(
        firstPage: vm.book.firstPage,
        lastPage: vm.book.lastPage,
        firstParagraph: firstParagraph,
        lastParagraph: lastParagraph,
      ),
    );
    if (gotoResult != null) {
      final int pageNumber = gotoResult.type == GotoType.page
          ? gotoResult.number
          : await vm.getPageNumber(gotoResult.number);
      vm.gotoPage(pageNumber.toDouble());
    }
  }
  */
}
