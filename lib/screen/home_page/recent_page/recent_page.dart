import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        builder: (_, __) {
          return Builder(builder: (context) {
            //use builder to obtain a BuildContext descendant of the provider
            return Scaffold(
              appBar: AppBar(
                title: const Text('ဖတ်ဆဲစာအုပ်များ'),
              ),
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
                    
                    return RecentlistView(
                        recents:
                            context.watch<RecentPageViewController>().recents);
                  }),
            );
          });
        });
  }
}
