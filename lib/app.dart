import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'controllers/theme_controller.dart';
import 'deep_link_handler.dart';
import 'repositories/database.dart';
import 'repositories/paragraph_repo.dart';
import 'screen/home_page/home_page.dart';
import 'screen/reader_page/reader_page.dart';
import 'utils/platform_helper.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final DeepLinkHandler _mobileDeepLink;
  StreamSubscription<String>? _mobilelinkSubscription;
  StreamSubscription<Uri?>? _desktoplinkSubscription;

  @override
  void initState() {
    super.initState();
    if (isMobile) {
      // _mobileDeepLinkBloc = DeepLinkHandler();
      initMobileDeepLinks();
    }
    if (isDesktop) {
      _handleIncomingLinks();
      _handleInitialUri();
    }
  }

  @override
  void dispose() {
    _mobilelinkSubscription?.cancel();
    _desktoplinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Provider<ThemeController>(
        create: (_) => ThemeController(),
        builder: (context, __) {
          return ValueListenableBuilder<ThemeMode>(
              valueListenable: context.read<ThemeController>().themeMode,
              builder: (_, themeMode, __) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Tipitaka Myanmar',
                    // theme: FlexColorScheme.light(scheme: FlexScheme.espresso).toTheme,
                    // darkTheme: FlexColorScheme.dark(scheme: FlexScheme.indigo, appBarElevation: 2).toTheme,
                    themeMode: themeMode,
                    theme: ThemeData().copyWith(
                        colorScheme: const ColorScheme.light().copyWith(
                            primary: Colors.brown,
                            secondary: Colors.brown[400])),
                    darkTheme: ThemeData.dark(),
                    navigatorKey: _navigatorKey,
                    home: const HomePage());
              });
        });
  }

  Future<void> initMobileDeepLinks() async {
    _mobileDeepLink = DeepLinkHandler();
    _mobilelinkSubscription = _mobileDeepLink.state.listen((uri) {
      debugPrint('onAppLink: $uri');
      openMobileAppLink(uri);
    });
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _desktoplinkSubscription = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          debugPrint('onAppLink: $uri');
          openDesktopAppLink(uri);
        }
      }, onError: (Object err) {
//
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).

    try {
      final uri = await getInitialUri();
      if (uri != null) {
        debugPrint('onAppLink: $uri');
        openDesktopAppLink(uri);
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      debugPrint('falied to get initial uri');
    } on FormatException catch (err) {
      debugPrint(err.toString());
    }
  }

  void openMobileAppLink(String url) async {
    final bookId = parseBookId(url);
    final paragraphNumber = parseParagraphNumber(url);
    if (bookId != null && paragraphNumber != null) {
      // get pagenumber from paragraph
      ParagraphRepository repository =
          ParagraphDatabaseRepository(DatabaseHelper());
      final pageNumber =
          await repository.getPageNumber(bookId, int.parse(paragraphNumber));

      final route = readerRoute(
        bookId: bookId,
        pageNumber: pageNumber,
      );
      _navigatorKey.currentState
          ?.pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    }
  }

  void openDesktopAppLink(Uri uri) async {
    final url = uri.toString();
    final bookId = parseBookId(url);
    final paragraphNumber = parseParagraphNumber(url);
    debugPrint(bookId);
    debugPrint(paragraphNumber);
    if (bookId != null && paragraphNumber != null) {
      // get pagenumber from paragraph
      ParagraphRepository repository =
          ParagraphDatabaseRepository(DatabaseHelper());
      final pageNumber =
          await repository.getPageNumber(bookId, int.parse(paragraphNumber));
      debugPrint('page number: $pageNumber');
      final route = readerRoute(
        bookId: bookId,
        pageNumber: pageNumber,
      );

      _navigatorKey.currentState
          ?.pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    }
  }

  MaterialPageRoute readerRoute(
          {required String bookId, required int pageNumber}) =>
      MaterialPageRoute(
        builder: (_) => ReaderPage(
          bookId: bookId,
          initialPage: pageNumber,
          isOpenFromDeepLink: true,
        ),
      );

  String? parseBookId(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['id'];
    /*
    RegExp regexId = RegExp(r'\w+_\w+_\d+(_\d+)?');
    final matchId = regexId.firstMatch(url);
    return matchId?.group(0);
    */
  }

  String? parseParagraphNumber(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['paragraph'];
    /*
    RegExp regexPage = RegExp(r'\d+$');
    final matchPage = regexPage.firstMatch(url);
    return matchPage?.group(0);
    */
  }
}
