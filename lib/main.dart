import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tipitaka_myanmar/data/shared_pref_client.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart';

import 'app.dart';

void main() async {
  // https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/using_ffi_instead_of_sqflite.md
  // sqflite only supports iOS/Android/MacOS
  // so  sqflite_common_ffi will be used for windows and linux

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.

  // deep link for windows
  if (Platform.isWindows) {
    registerProtocol('tipitakamyanmar');
  }
  
  await SharedPreferenceClient.init();
  runApp(const MyApp());
}
