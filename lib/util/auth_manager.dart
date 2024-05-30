import 'package:flutter/cupertino.dart';
import 'package:hess_app/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final SharedPreferences _sharedpref = locator.get();
  static ValueNotifier valueNotifier = ValueNotifier(null);
  static void saveToken(String token) {
    _sharedpref.setString('userToken', token);
    valueNotifier.value = token;
  }

  static String readAuth() {
    return _sharedpref.getString('userToken') ?? '';
  }

  static void saveActionCode(int code) {
    _sharedpref.setInt('actionCode', code);
    valueNotifier.value = code;
  }

  static int readActionCode() {
    return _sharedpref.getInt('actionCode') ?? 10;
  }

  static void logout() {
    _sharedpref.clear();
    valueNotifier.value = null;
  }

  static void saveId(String id) {
    _sharedpref.setString('user_id', id);
  }

  static String getId() {
    return _sharedpref.getString('user_id') ?? '';
  }
}
