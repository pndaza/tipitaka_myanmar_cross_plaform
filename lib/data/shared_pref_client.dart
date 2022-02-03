import 'package:shared_preferences/shared_preferences.dart';

// const _scrollDirectionKey = 'scroll_direction';
// const _defaultScrollDirection = Axis.vertical;

const _keyIsInitialized = 'is_initialized';
const _defaultIsInitialized = false;

const _keyDatabaseVersion = 'database_version';
const _defaultDatabaseVersion = 0;

const _keyFontSize = 'font_size';
const _defaultFontSize = 18.0;

const _keyThemeModeIndex = 'theme_mode_index';
const _defaultThemeModeIndex = 0;

class SharedPreferenceClient {
  SharedPreferenceClient._();
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static bool get isInitialized =>
      instance.getBool(_keyIsInitialized) ?? _defaultIsInitialized;
  static set isInitialized(bool value) =>
      instance.setBool(_keyIsInitialized, value);

  static int get databaseVerion =>
      instance.getInt(_keyDatabaseVersion) ?? _defaultDatabaseVersion;
  static set databaseVerion(int value) =>
      instance.setInt(_keyDatabaseVersion, value);

  static double get fontSize =>
      instance.getDouble(_keyFontSize) ?? _defaultFontSize;
  static set fontSize(double value) => instance.setDouble(_keyFontSize, value);

  static int get themeModeIndex =>
      instance.getInt(_keyThemeModeIndex) ?? _defaultThemeModeIndex;
  static set themeModeIndex(int value) =>
      instance.setInt(_keyThemeModeIndex, value);
}
