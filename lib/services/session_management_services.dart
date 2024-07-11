import 'package:food_saver/res/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagementService {

  static Future<void> createSession(
      {required String email,
      required String password,
      required UserRoles userRole}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('userType', userRole.name);
  }

  static Future<Map<String, dynamic>> checkSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    final String? userType = prefs.getString('userType');

    return {
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  static Future<void> destroySession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
