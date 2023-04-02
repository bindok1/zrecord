import 'package:moneyrecord/config/api.dart';
import 'package:moneyrecord/config/app_request.dart';
import 'package:moneyrecord/config/session.dart';
import 'package:moneyrecord/data/model/user_model.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    try {
      String url = '${Api.user}/login.php';
      Map? responseBody =
          await AppRequest.post(url, {'email': email, 'password': password});
      if (responseBody == null) {
        return false;
      }
      if (responseBody.containsKey('success') &&
          responseBody['success'] != null &&
          responseBody['success'] is bool &&
          responseBody['success']) {
        var mapUser = responseBody['data'];
        Session.saveUser(User.fromJson(mapUser));
      }
      if (await responseBody['success'] == null) {
        return false;
      } else {
        return responseBody['success'];
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> register(
      String name, String email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    return responseBody['success'];
  }
}
