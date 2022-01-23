import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants.dart';
import '../data/shared_pref_client.dart';

class DatabaseHelper {

  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

// Open Assets Database
  _initDatabase() async {
    // print('initializing Database');
    var dbPathToStore = await getDatabasesPath();
    var dbFilePath = join(dbPathToStore, DatabaseInfo.dbName);

    var exists = await databaseExists(dbFilePath);

    if (exists &&
        SharedPreferenceClient.isInitialized &&
        SharedPreferenceClient.databaseVerion == DatabaseInfo.dbVersion) {
      // database is upto date
      return await openDatabase(dbFilePath);
    }

    if (exists &&
        SharedPreferenceClient.isInitialized &&
        SharedPreferenceClient.databaseVerion < DatabaseInfo.dbVersion) {
      // database is outdated

      // deleting old database
      await deleteDatabase(dbFilePath);
      // saving new database
      await _saveDatabaseFromAssets(dbFilePath: dbFilePath);

      return await openDatabase(dbFilePath);
    }

    // database is not initialized

    // make sure destination path is created
    try {
      await Directory(dirname(dbPathToStore)).create(recursive: true);
    } catch (_) {}
    // saving database
    await _saveDatabaseFromAssets(dbFilePath: dbFilePath);

    return await openDatabase(dbFilePath);
  }

  Future<void> _saveDatabaseFromAssets({required String dbFilePath}) async {
    // Copy from asset
    final dbFileAssetsPath = join(DatabaseInfo.assetsPath, DatabaseInfo.dbName);
    await _copyDatabase(assetsPath: dbFileAssetsPath, destination: dbFilePath);

    // save to pref
    SharedPreferenceClient.isInitialized = true;
    SharedPreferenceClient.databaseVerion = DatabaseInfo.dbVersion;
  }

  Future<void> _copyDatabase(
      {required String assetsPath, required String destination}) async {
    ByteData data = await rootBundle.load(assetsPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(destination).writeAsBytes(bytes, flush: true);
  }

  Future close() async {
    return _database?.close();
  }
}
