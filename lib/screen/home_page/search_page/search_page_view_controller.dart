import 'package:flutter/material.dart';

import '../../../data/basic_state.dart';
import '../../../models/search_result.dart';
import '../../../services/search_service.dart';
import '../../../utils/mm_number.dart';
import '../../../utils/mm_string_normalizer.dart';
import '../../reader_page/reader_page.dart';

class SearchPageViewController {
  final ValueNotifier<StateStaus> _state =
      ValueNotifier<StateStaus>(StateStaus.initial);
  ValueNotifier<StateStaus> get state => _state;

  final ValueNotifier<String> _title = ValueNotifier<String>('စာရှာ');
  ValueNotifier<String> get title => _title;

  final List<SearchResult> _searchResults = [];
  List<SearchResult> get searchResults => _searchResults;

  String _textToHightLight = '';
  String get textToHIghLight => _textToHightLight;

  void init() async {
    // todo
  }

  void dispose() {
    _state.dispose();
    _title.dispose();
  }

  void onSearchTextChanged(String text) {
    if (text.isEmpty) {
      _state.value = StateStaus.initial;
      _title.value = 'စာရှာ';
      _searchResults.clear();
    }
  }

  Future<void> onSearchSubmitted(String searchWord) async {
    if (searchWord.isEmpty) {
      return;
    }
    _textToHightLight = searchWord;
    searchWord = MMStringNormalizer.normalize(searchWord);
    _state.value = StateStaus.loading;
    final results = await SearchService.getResults(searchWord);
    debugPrint('search results: ${results.length}');
    if (results.isEmpty) {
      _title.value = 'စာရှာ';
      _state.value = StateStaus.nodata;
    } else {
      _searchResults.clear();
      _searchResults.addAll(results);
      _title.value =
          'တွေ့ရှိမှု - ${MmNumber.get(_searchResults.length)} ကြိမ်';
      _state.value = StateStaus.data;
    }
  }

  void onSearchItemClicked(
      {required BuildContext context, required SearchResult searchResult}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReaderPage(
                  bookId: searchResult.book.id,
                  initialPage: searchResult.pageNumber,
                  textToHightlight: _textToHightLight,
                )));
  }
}
