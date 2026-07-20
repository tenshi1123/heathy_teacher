import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseRepo {
  Future<List<CourseScheduleModel>> getCourse({
    int page = 1,
    int show = 10,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.course,
        data: {"page": page.toString(), "show": show.toString()},
      );
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['value'] != null) {
        final List listData = response.data['data']['value'] as List;

        return listData
            .map((e) => CourseScheduleModel.fromJson(e as Map<String, dynamic>))
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

  Future<CourseDetailModel> getCourseDetail({
    required String courseId,
    required String settingCourseTypeId,
    required String courseScheduleId,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.courseDetail,
        data: {
          'course_id': courseId,
          'setting_course_type_id': settingCourseTypeId,
          'course_schedule_id': courseScheduleId,
        },
      );
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['value'] != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        return CourseDetailModel.fromJson(data);
      } else {
        throw Exception('Dữ liệu không hợp lệ');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<List<ProductModel>> getListProduct({
    int page = 1,
    int show = 10,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.products,
        data: {"page": page.toString(), "show": show.toString()},
      );
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['value'] != null) {
        final List listData = response.data['data']['value'] as List;

        return listData
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
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

  Future<List<ScheduleModel>> getListEventSchedule({
    int page = 1,
    int show = 10,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      // Giả sử Path là ApiPath.schedules, bạn hãy đổi lại đúng tên path của mình
      final response = await dio.post(
        ApiPath.calendarOff,
        data: {"page": page.toString(), "show": show.toString()},
      );

      if (response.data != null && response.data['data'] != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        final List<ScheduleModel> combinedList = [];

        // 1. Parse danh sách từ 'calendar' nếu có
        if (data['calendar'] != null) {
          final List calendarList = data['calendar'] as List;
          combinedList.addAll(
            calendarList.map(
              (e) => ScheduleModel.fromJson(e as Map<String, dynamic>),
            ),
          );
        }

        // 2. Parse danh sách từ 'customer_zoom_google_offline' nếu có
        if (data['customer_zoom_google_offline'] != null) {
          final List offlineList = data['customer_zoom_google_offline'] as List;
          combinedList.addAll(
            offlineList.map(
              (e) => ScheduleModel.fromJson(e as Map<String, dynamic>),
            ),
          );
        }

        return combinedList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<void> customerSubmit({
    required String courseId,
    required String content,
    required String courseTypeId,
    required int isPointAcc,
    required List<String> files,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      Map<String, dynamic> requestData = {
        'content': content,
        'course_id': courseId,
        'course_type_id': courseTypeId,
        'is_point_acc': isPointAcc,
      };

      for (int i = 0; i < files.length; i++) {
        requestData['images[$i]'] = await MultipartFile.fromFile(
          files[i],
          filename: files[i].split('/').last,
        );
      }

      FormData formData = FormData.fromMap(requestData);

      final response = await dio.post(ApiPath.customerSubmit, data: formData);
      if (response.data == null || response.data['status'] != 200) {
        throw Exception('Lỗi khi gửi bài: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }
}
