import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/basic_state.dart';
import 'search_list_tile.dart';
import 'search_page_view_controller.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final searchPageViewController = context.read<SearchPageViewController>();
    return ValueListenableBuilder(
        valueListenable: searchPageViewController.state,
        builder: (_, state, __) {
          if (state == StateStaus.initial) {
            return Container();
          }
          if (state == StateStaus.loading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [Text('ရှာနေဆဲ'), CircularProgressIndicator()],
            );
          }
          if (state == StateStaus.nodata) {
            return Center(
              child: Text(
                '${searchPageViewController.textToHIghLight}ဟူသော စကားလုံး\nရှာမတွေ့ပါ။\n စာသားအပြောင်းအလဲ ပြုလုပ်၍ ထပ်မံရှာကြည့်ပါ။',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
              itemBuilder: (_, index) => SearchListTile(
                  onClikded: () => searchPageViewController.onSearchItemClicked(
                      context: context,
                      searchResult: searchPageViewController.searchResults
                          .elementAt(index)),
                  result:
                      searchPageViewController.searchResults.elementAt(index),
                  textToHighlight: searchPageViewController.textToHIghLight));
        });
  }
}
