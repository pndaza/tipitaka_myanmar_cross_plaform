import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../dialogs/confirm_dialog.dart';
import '../../../models/recent.dart';
import '../../../repositories/database.dart';
import '../../../repositories/recent_dao.dart';
import '../../../repositories/recent_repo.dart';
import '../../reader_page/reader_page.dart';

class RecentPageViewController {
  RecentPageViewController({
    required this.databaseHelper,
  }) {
    _init();
  }
  final DatabaseHelper databaseHelper;
  late final RecentRepository repo;

  final _state = ValueNotifier(StateStaus.loading);
  ValueNotifier<StateStaus> get state => _state;

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

  final List<Recent> _recents = [];
  List<Recent> get recents => _recents;

  void _init() async {
    repo = RecentDatabaseRepository(databaseHelper, RecentDao());

    recents.addAll(await _fetchRecents());
    if (recents.isEmpty) {
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

  Future<List<Recent>> _fetchRecents() async {
    return await repo.getRecents();
  }

  Future<void> _refresh() async {
    _state.value = StateStaus.loading;
    _recents.clear();
    _recents.addAll(await _fetchRecents());
    if (recents.isEmpty) {
      _state.value = StateStaus.nodata;
    }
    {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onRecentItemClicked(BuildContext context, int index) async {
    if (!_isSelectionMode.value) {
      // opening book
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReaderPage(
                  bookId: _recents[index].bookID,
                  initialPage: _recents[index].pageNumber))).then((value) {
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

  void onRecentItemPressed(BuildContext context, int index) {
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
    if (_recents.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value = List.generate(_recents.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await repo.delete(_recents[index]);
    // deleting from loaded
    _recents.removeAt(index);
    if (_recents.isEmpty) {
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
    if (_recents.length == _selectedItems.value.length) {
      await repo.deleteAll();
      _recents.clear();
      _state.value = StateStaus.nodata;
    } else {
      await repo.deletes(
          _getSelectedRecentsFrom(selectedItems: _selectedItems.value));
      _recents.clear();
      _recents.addAll(await repo.getRecents());
      _state.value = StateStaus.data;
    }
  }

  List<Recent> _getSelectedRecentsFrom({required List<int> selectedItems}) {
    return selectedItems.map((index) => _recents[index]).toList();
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: '??????????????? ???????????????????????????????????? ????????????????????? ????????????????????? ?????????????????????????????????',
            okLabel: '?????????????????????',
            cancelLabel: '????????????????????????????????????',
          );
        });
  }
}
