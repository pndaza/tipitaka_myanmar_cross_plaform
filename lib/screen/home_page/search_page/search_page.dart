import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_bar.dart';
import 'search_page_app_bar.dart';
import 'search_page_view_controller.dart';
import 'search_result_view.dart';

class SerachPage extends StatelessWidget {
  const SerachPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SearchPageViewController>(
        create: (_) => SearchPageViewController(),
        builder: (context, __) => Scaffold(
                appBar: const SearchPageAppBar(),
                body: Column(
                  children: [
                    const Expanded(child: SearchResultView()),
                    SearchBar(
                        onChanged: context
                            .read<SearchPageViewController>()
                            .onSearchTextChanged,
                        onSummited: context
                            .read<SearchPageViewController>()
                            .onSearchSubmitted)
                  ],
                ),
              )
            );
  }
}
