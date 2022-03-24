import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String auth_token = "auth_token";

//set data into shared preferences like this
  Future<void> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }

//get value from shared preferences
  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_token;
    auth_token = (pref.getString(this.auth_token) ?? null)!;
    return auth_token;
  }

  //set data into shared preferences like this
  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  //get value from shared preferences
  Future<String> getStringValue(String key, String defValue) async {
    final SharedPreferences? _prefs = await SharedPreferences.getInstance();
    return _prefs == null ? defValue : _prefs.getString(key) ?? "";
    //return pref.getString(key) ;
  }

//get value from shared preferences
  Future<String> getString(String key, String defValue) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs == null ? defValue : _prefs.getString(key) ?? "";

    //return pref.getString(key) ?? defValue ?? "";
  }

  //set data into shared preferences like this
  Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

//get value from shared preferences
  Future<int> getInt(String key, int defValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? defValue;
  }

  //remove value from shared preferences
  Future<bool> removeString(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}
