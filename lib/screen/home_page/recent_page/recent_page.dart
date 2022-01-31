import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/screen/home_page/recent_page/recent_page_app_bar.dart';

import '../../../data/basic_state.dart';
import '../../../repositories/database.dart';
import '../../../widgets/loading_view.dart';
import 'recent_list.dart';
import 'recent_page_view_controller.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<RecentPageViewController>(
        create: (_) =>
            RecentPageViewController(databaseHelper: DatabaseHelper()),
        builder: (context, __) => Scaffold(
              appBar: const RecentPageAppBar(),
              body: ValueListenableBuilder<StateStaus>(
                  valueListenable:
                      context.watch<RecentPageViewController>().state,
                  builder: (_, state, __) {
                    if (state == StateStaus.loading) {
                      return const LoadingView();
                    }
                    if (state == StateStaus.nodata) {
                      return const Center(
                        child: Text('ဖတ်ဆဲစာအုပ်များ မရှိသေးပါ'),
                      );
                    }
                    return const RecentlistView();
                  }),
            ));
  }
}
