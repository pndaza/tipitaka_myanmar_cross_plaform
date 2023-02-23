import 'dart:io';

bool get isMobile => Platform.isAndroid || Platform.isIOS;

bool get isDesktop =>
    Platform.isMacOS || Platform.isWindows || Platform.isLinux;
