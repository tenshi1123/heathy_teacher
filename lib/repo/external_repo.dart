import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class ExternalRepo {
  Future<CourseDetailModel> getDetailCourseExternal() async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.detailCourse,
        data: {'course_type_id': '168'},
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
}
