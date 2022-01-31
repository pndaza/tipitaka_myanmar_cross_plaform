import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/dialogs/confirm_dialog.dart';

import '../../../data/basic_state.dart';
import '../../../models/bookmark.dart';
import '../../../repositories/bookmark_dao.dart';
import '../../../repositories/bookmark_repo.dart';
import '../../../repositories/database.dart';
import '../../reader_page/reader_page.dart';

class BookmarkPageViewController {
  BookmarkPageViewController({
    required this.databaseHelper,
  }) {
    _init();
  }
  final DatabaseHelper databaseHelper;
  late final BookmarkRepository repo;

  late final ValueNotifier<StateStaus> _state;
  ValueNotifier<StateStaus> get state => _state;

  final List<Bookmark> _bookmarks = [];
  List<Bookmark> get bookmarks => _bookmarks;

  void _init() async {
    repo = BookmarkDatabaseRepository(databaseHelper, BookmarkDao());
    _state = ValueNotifier(StateStaus.loading);
    bookmarks.addAll(await _fetchBookmarks());
    if (bookmarks.isEmpty) {
      _state.value = StateStaus.nodata;
    }
    {
      _state.value = StateStaus.data;
    }
  }

  void dispose() {
    _state.dispose();
  }

  Future<List<Bookmark>> _fetchBookmarks() async {
    return await repo.getBookmarks();
  }

  Future<void> _refresh() async {
    _state.value = StateStaus.loading;
    _bookmarks.clear();
    _bookmarks.addAll(await _fetchBookmarks());
    if (bookmarks.isEmpty) {
      _state.value = StateStaus.nodata;
    }
    {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onBookmarkItemClicked(
      BuildContext context, Bookmark bookmark) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                bookId: bookmark.bookID,
                initialPage: bookmark.pageNumber))).then((_) {
      _refresh();
    });
  }

  Future<void> onDeleteActionOfBookmarkItem(Bookmark bookmark) async {
    await repo.delete(bookmark);
  }

  Future<void> onClickedDeleteButton(BuildContext context) async {
    final userActions = await _getComfirmation(context);
    if (userActions != null && userActions == OkCancelAction.ok) {
      _state.value = StateStaus.loading;
      await repo.deleteAll();
      _bookmarks.clear();
      _state.value = StateStaus.nodata;
    }
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: 'မှတ်သားထားသမျှ အားလုံးကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
