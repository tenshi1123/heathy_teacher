import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heathy_teacher/app.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

List<CourseModel> cartItems = [];
String isShow = '';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApiConfig();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    initializeDateFormatting().then((_) => runApp(const App()));
  });
}

Future<void> initApiConfig() async {
  // ✅ FIX: Thêm timeout 8 giây để không block app vô hạn khi mạng chậm / server down
  try {
    debugPrint('[initApiConfig] 🚀 Đang tải cấu hình API...');
    final res = await http
        .get(
          Uri.parse(
            'https://612ced09ab461c00178b5fbb.mockapi.io/api/users/kiddo',
          ),
        )
        .timeout(const Duration(seconds: 3));
    final data = jsonDecode(res.body);
    ApiPath.baseUrl = data[2]['domain'] + 'api';
    isShow = data[4]['domain'];
    debugPrint('[initApiConfig] ✅ Cấu hình API thành công: ${ApiPath.baseUrl}');
  } catch (e) {
    // Fallback: giữ nguyên giá trị mặc định đã được khai báo trong ApiPath/ApiPathTeacher
    // App vẫn có thể chạy, sẽ lỗi khi gọi API cụ thể nếu URL sai
    debugPrint(
      '[initApiConfig] ⚠️ Không tải được cấu hình API: $e – dùng fallback URL',
    );
  }
}
