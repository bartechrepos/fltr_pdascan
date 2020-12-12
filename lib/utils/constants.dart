import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static SharedPreferences prefs;
  static const String PDASCR_LOGGED_IN = "PDASCR_LOGGED_IN";
  static const String PDASCR_LOGGED_USER = "PDASCR_LOGGED_USER";
  static const String PDASCR_CODES = "PDASCR_CODES";
  static const API_URL = "http://20.36.212.104:8080/imisback/public/api";
}
