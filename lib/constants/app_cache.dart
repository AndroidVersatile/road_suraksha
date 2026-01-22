import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static final AppCache _appCache = AppCache._internal();
  static const isLogin = "isLogin";
  static const name = "name";
  static const email = "email";
  static const mobile = "mobile";
  static const id = "id";
  static const userType = "userType";
  var isInit = false;
  static const userFormNo = 'userFormNo';
  static const userPass = 'userPass';
  static const kFCMToken = 'FCMToken';
  SharedPreferences? _prefs;

  factory AppCache() {
    return _appCache;
  }

  Future<bool> checkInit() async {
    if (isInit) {
      return true;
    } else {
      _prefs = await SharedPreferences.getInstance();
      isInit = true;

      return true;
    }
  }

  AppCache._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      isInit = true;
    });
  }

  isUserLoggedIn() {
    return _prefs?.getBool(isLogin) ?? false;
  }

  clearCache() async {
    await _prefs?.setBool(isLogin, false);
    await _prefs?.clear();
  }

  setLoggedIn() async {
    await _prefs!.setBool(isLogin, true);
  }


  setUserName(user) async {
    await _prefs!.setString(name, user);
  }

  getUserName() async {
    var username =await _prefs!.getString(name);
    return username;
  }

  setUserEmail(user) async {
    await _prefs!.setString(email, user);
  }

  getUserEmail() async {
    return await _prefs!.getString(email);
  }

  setUserId(user) async {
    await _prefs!.setString(id, user);
  }

  getUserId() async {
    return await _prefs!.getString(id);
  }

  setUserMobile(user) async {
    await _prefs!.setString(mobile, user);
  }

  getUserMobile() async {
    return await _prefs!.getString(mobile);
  }

  void logout() async {
    await clearCache();
    await _prefs?.setBool(isLogin, false);
  }

  saveUserPass(String pass) async {
    await _prefs?.setString(userPass, pass);
  }

  getUserPass() async {
    return await _prefs?.getString(userPass);
  }


  Future<void> saveFCMToken(String token) async {
    await _prefs?.setString(kFCMToken, token);
  }

  Future<String> getFCMToken() async {
    var token = _prefs?.getString(kFCMToken) ?? '';
    return token;
  }
}
