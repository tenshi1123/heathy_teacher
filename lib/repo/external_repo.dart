import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/payment_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class ExternalRepo {
  //repo lấy data từ trang web ngoài
  Future<List<CourseModel>> getListCourse({int page = 1, int show = 10}) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.listCourse,
        data: jsonEncode({"page": page.toString(), "show": show.toString()}),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  //danh sách khóa học free
  Future<List<CourseModel>> getListFreeCourse({
    int page = 1,
    int show = 10,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.listCourse,
        data: jsonEncode({
          "page": page.toString(),
          "show": show.toString(),
          "is_trial": 1,
        }),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<List<CourseOffModel>> getListCourseOff({
    int page = 1,
    int show = 10,
    String? place,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final Map<String, dynamic> requestData = {
        "page": page.toString(), 
        "show": show.toString()
      };
      if (place != null && place.isNotEmpty) {
        requestData["province"] = place;
        requestData["place"] = place; // fallback
      }
      final response = await dio.post(
        ApiPath.listCourseOff,
        data: jsonEncode(requestData),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => CourseOffModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<CourseDetailModel> getDetailCourseExternal(String id) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.detailCourse,
        data: {'course_type_id': id},
      );

      if (response.data != null) {
        return CourseDetailModel.fromJson(response.data);
      } else {
        throw Exception('Không tìm thấy dữ liệu khách hàng từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<String> getStreamingUrl({required String lessonId}) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.playVideo,
        data: {'lesson_id': lessonId},
      );

      if (response.data != null) {
        return (response.data['streaming_url']);
      } else {
        throw Exception('Không tìm thấy dữ liệu khách hàng từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<PayCodeModel> paymentProduct(
    Map<String, dynamic> requestData,
    String? token,
  ) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = token;
      final response = await dio.post(
        ApiPath.productPayment,
        data: requestData,
      );
      if (response.data != null) {
        return PayCodeModel.fromJson(response.data);
      } else {
        throw Exception('Không nhận được dữ liệu phản hồi từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<PayCodeModel> paymentCourse(
    Map<String, dynamic> requestData,
    String? token,
  ) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = token;
      final response = await dio.post(ApiPath.coursePayment, data: requestData);
      if (response.data != null) {
        return PayCodeModel.fromJson(response.data);
      } else {
        throw Exception('Không nhận được dữ liệu phản hồi từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }
}
