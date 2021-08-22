import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async =>
    _sharedPreferences = await SharedPreferences.getInstance();


  static SharedPreferences get sharedPreferences => _sharedPreferences;
}