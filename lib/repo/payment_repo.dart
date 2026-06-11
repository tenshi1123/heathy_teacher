import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/course_model.dart';
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
}
