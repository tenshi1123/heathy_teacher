import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class CourseRepo {
  Future<List<CourseScheduleModel>> getCourse() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.course);
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

  Future<List<ProductModel>> getListProduct() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.products);
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

  Future<List<ScheduleModel>> getListEventSchedule() async {
    try {
      final dio = await DioClient.getInstance();
      // Giả sử Path là ApiPath.schedules, bạn hãy đổi lại đúng tên path của mình
      final response = await dio.post(ApiPath.calendarOff);

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
}
