import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:heathy_teacher/main.dart';

import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  Future<String> login(
    String phone,
    String password,
    String fingerprint,
  ) async {
    final dio = await DioClient.getInstance();
    dio.options.headers['Token'] = 'Healthy1234567890APP';
    Response response;

    try {
      response = await dio.post(
        ApiPath.login,
        data: jsonEncode({
          'phone': phone,
          'password': password,
          'fingerprint': (isShow == 'true') ? fingerprint : '106acc9d',
        }),
      );
    } on DioException catch (e) {
      print(e);
      return 'Đăng nhập thất bại';
    }

    // Lấy data ra biến riêng cho code gọn gàng
    final data = response.data;

    if (data['type'] == 'error') {
      // Thêm .toString() để ép kiểu an toàn
      return data['message']?.toString() ?? 'Đăng nhập thất bại';
    }

    if (data['type'] == 'success') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Thêm .toString() cho các value lưu vào SharedPreferences
      // (Phòng trường hợp customer_id trả về là int thay vì String)
      await prefs.setString('token', data["refresh_token"]?.toString() ?? '');
      await prefs.setString('id_user', data["customer_id"]?.toString() ?? '');

      return data['message']?.toString() ?? 'Đăng nhập thành công';
    }

    return data['message']?.toString() ?? 'Đăng nhập thành công';
  }

  Future<String> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id_user');
    return 'Đăng xuất thành công';
  }

  Future<String> signUp(
    String phone,
    String password,
    String name,
    String fingerprint,
  ) async {
    final dio = await DioClient.getInstance();
    dio.options.headers['Token'] = 'Healthy1234567890APP';
    Response response;

    try {
      response = await dio.post(
        ApiPath.signup,
        data: jsonEncode({
          'phone': phone,
          'password': password,
          'name': name,
          'fingerprint': fingerprint,
        }),
      );
    } on DioException {
      return 'Đăng ký thất bại';
    }

    final data = response.data;

    if (data['type'] == 'error') {
      return data['message']?.toString() ?? 'Đăng ký thất bại';
    }

    if (data['type'] == 'success') {
      return data['message']?.toString() ?? 'Đăng ký thành công';
    }

    return data['message']?.toString() ?? 'Đăng ký thành công';
  }
}
