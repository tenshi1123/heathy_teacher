import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heathy_teacher/app.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

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
    debugPrint(
      '[initApiConfig] ⚠️ Không tải được cấu hình API: $e – dùng fallback URL',
    );
  }
}
