import 'package:shared_preferences/shared_preferences.dart';

// const _scrollDirectionKey = 'scroll_direction';
// const _defaultScrollDirection = Axis.vertical;

const _isInitializeddKey = 'is_initialized';
const _defaultIsInitialized = false;

const _databaseVersion = 'database_version';
const _defaultDatabaseVersion = 1;

class SharedPreferenceClient {
  SharedPreferenceClient._();
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static bool get isInitialized =>
      instance.getBool(_isInitializeddKey) ?? _defaultIsInitialized;
  static set isInitialized(bool value) =>
      instance.setBool(_isInitializeddKey, value);

  static int get databaseVerion =>
      instance.getInt(_databaseVersion) ?? _defaultDatabaseVersion;
  static set databaseVerion(int value) =>
      instance.setInt(_databaseVersion, value);

}
