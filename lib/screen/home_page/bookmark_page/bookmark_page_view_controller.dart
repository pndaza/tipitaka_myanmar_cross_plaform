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

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

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
    _isSelectionMode.dispose();
    _selectedItems.dispose();
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

  Future<void> onBookmarkItemClicked(BuildContext context, int index) async {
    if (!_isSelectionMode.value) {
      // opening book
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReaderPage(
                  bookId: _bookmarks[index].bookID,
                  initialPage: _bookmarks[index].pageNumber))).then((_) {
        _refresh();
      });
      return;
    }
    if (!_selectedItems.value.contains(index)) {
      _selectedItems.value = [..._selectedItems.value, index];
      return;
    }

    // remove form selected items
    _selectedItems.value.remove(index);
    _selectedItems.value = [..._selectedItems.value];
    // update selection mode
    if (_selectedItems.value.isEmpty) {
      _isSelectionMode.value = false;
    }
  }

  void onBookmarktemPressed(BuildContext context, int index) {
    if (!_isSelectionMode.value) {
      _isSelectionMode.value = true;
      _selectedItems.value = [index];
    }
  }

  void onCancelButtonClicked() {
    // chnage mode
    _isSelectionMode.value = false;
    // clear selected items
    _selectedItems.value = [];
  }

  void onSelectAllButtonClicked() {
    if (_bookmarks.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value = List.generate(_bookmarks.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await repo.delete(_bookmarks[index]);
    // deleting from loaded
    _bookmarks.removeAt(index);
    if (_bookmarks.isEmpty) {
      _state.value = StateStaus.nodata;
    } else {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onDeleteButtonClicked(BuildContext context) async {
    final userActions = await _getComfirmation(context);
    if (userActions == null || userActions == OkCancelAction.cancel) {
      return;
    }

    // chanage state to loading
    _state.value = StateStaus.loading;
    if (_bookmarks.length == _selectedItems.value.length) {
      await repo.deleteAll();
      _bookmarks.clear();
      _state.value = StateStaus.nodata;
    } else {
      await repo.deletes(
          _getSelectedBookmarksFrom(selectedItems: _selectedItems.value));
      _bookmarks.clear();
      _bookmarks.addAll(await repo.getBookmarks());
      _state.value = StateStaus.data;
    }
  }

  List<Bookmark> _getSelectedBookmarksFrom({required List<int> selectedItems}) {
    return selectedItems.map((index) => _bookmarks[index]).toList();
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: 'မှတ်သားထားသော မှတ်စုများကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
