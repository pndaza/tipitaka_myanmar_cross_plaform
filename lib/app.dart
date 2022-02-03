import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/theme_controller.dart';
import 'deep_link_handler.dart';
import 'deep_link_view.dart';
import 'screen/home_page/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _deepLinkBloc = DeepLinkHandler();

    return Provider<ThemeController>(
        create: (_) => ThemeController(),
        builder: (context, __) {
          return ValueListenableBuilder<ThemeMode>(
              valueListenable: context.read<ThemeController>().themeMode,
              builder: (_, themeMode, __) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  // theme: FlexColorScheme.light(scheme: FlexScheme.espresso).toTheme,
                  // darkTheme: FlexColorScheme.dark(scheme: FlexScheme.indigo, appBarElevation: 2).toTheme,
                  themeMode: themeMode,
                  theme: ThemeData().copyWith(
                      colorScheme: const ColorScheme.light().copyWith(
                          primary: Colors.brown, secondary: Colors.brown[400])),
                  darkTheme: ThemeData.dark(),
                  home: StreamBuilder<String>(
                      stream: _deepLinkBloc.state,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          debugPrint(snapshot.data);
                          debugPrint('opening from deep link');
                          return DeepLinkView(
                              key: Key(snapshot.data!), url: snapshot.data!);
                        } else {
                          return const HomePage();
                        }
                      }),
                );
              });
        });
  }
}
