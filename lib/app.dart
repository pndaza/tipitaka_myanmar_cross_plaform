import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/controllers/theme_controller.dart';

import 'screen/home_page/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<ThemeController>(
        create: (_) => ThemeController(),
        builder: (context, __) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: context.read<ThemeController>().themeMode,
            builder: (_, themeMode,__) {
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
                home: const HomePage(),
              );
            }
          );
        });
  }
}
