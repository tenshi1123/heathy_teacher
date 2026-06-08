import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio? _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal();

  Future<Dio> get dio async {
    if (_dio != null) return _dio!;
    _dio = await _initDio();
    return _dio!;
  }

  static Future<Dio> getInstance() async {
    if (_dio != null) return _dio!;
    _dio = await _instance._initDio();
    return _dio!;
  }

  Future<Dio> _initDio() async {
    final dio = Dio();
    
    // Set default configs
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Preserve existing headers if any (e.g. 'Token' header used in some repos)
          return handler.next(options); 
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
