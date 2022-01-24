import 'package:flutter/material.dart';

import 'package:tipitaka_myanmar/data/basic_state.dart';
import 'package:tipitaka_myanmar/models/recent.dart';
import 'package:tipitaka_myanmar/repositories/database.dart';
import 'package:tipitaka_myanmar/repositories/recent_dao.dart';
import 'package:tipitaka_myanmar/repositories/recent_repo.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_page.dart';

class RecentPageViewController {
  RecentPageViewController({
    required this.databaseHelper,
  }) {
    _init();
  }
  final DatabaseHelper databaseHelper;
  late final RecentRepository repo;

  late final ValueNotifier<StateStaus> _state;
  ValueNotifier<StateStaus> get state => _state;

  final List<Recent> _recents = [];
  List<Recent> get recents => _recents;

  void _init() async {
    repo = RecentDatabaseRepository(databaseHelper, RecentDao());
    _state = ValueNotifier(StateStaus.loading);
    recents.addAll(await _fetchRecents());
    if (recents.isEmpty) {
      _state.value = StateStaus.nodata;
    }
    {
      _state.value = StateStaus.data;
    }
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

  Future<void> onRecentItemClicked(BuildContext context, Recent recent) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                bookId: recent.bookID,
                initialPage: recent.pageNumber))).then((value) {
      _refresh();
    });
  }

  Future<void> onDeleteActionOfRecentItem(Recent recent) async {
    await repo.delete(recent);
  }
}
