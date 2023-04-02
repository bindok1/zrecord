import 'dart:convert';

import 'package:get/get.dart';
import 'package:moneyrecord/data/model/user_model.dart';
import 'package:moneyrecord/presentation/controller/c_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences
        .getInstance(); // Mendapatkan instance SharedPreferences
    Map<String, dynamic> mapUser = user
        .toJson(); // Mengkonversi objek User menjadi map dengan method toJson()
    String stringUser = jsonEncode(
        mapUser); // Mengkonversi map menjadi string JSON dengan jsonEncode()
    bool success = await pref.setString(
        'user', stringUser); // Menyimpan string JSON ke SharedPreferences
    if (success) {
      final cUser = Get.put(CUser());
      cUser.setData(user);
    }
    return success; // Mengembalikan boolean true jika penyimpanan berhasil
  }

  static Future<User> getUser() async {
    User user = User(); // Membuat objek User baru
    final pref = await SharedPreferences
        .getInstance(); // Mendapatkan instance SharedPreferences
    String? stringUser = pref
        .getString('user'); // Mendapatkan string JSON dari SharedPreferences
    if (stringUser != null) {
      // Jika string JSON tidak null
      Map<String, dynamic> mapUser = jsonDecode(
          stringUser); // Mengkonversi string JSON menjadi map dengan jsonDecode()
      user = User.fromJson(
          mapUser); // Mengkonversi map menjadi objek User dengan method fromJson()
    }
    final cUser = Get.put(CUser());
    cUser.setData(user);
    return user; // Mengembalikan objek User, jika tidak ada objek User yang tersimpan maka objek baru akan dikembalikan
  }

  static Future<bool> clearUser() async {
    final pref = await SharedPreferences
        .getInstance(); // Mendapatkan instance SharedPreferences
    bool success = await pref
        .remove('user'); // Menghapus data 'user' dari SharedPreferences
        final cUser = Get.put(CUser());
      cUser.setData(User());
    return success; // Mengembalikan boolean true jika penghapusan berhasil
  }
}
