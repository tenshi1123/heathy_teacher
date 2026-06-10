import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class HomeRepo {
  Future<CustomerModel> getCustomer() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.home);

      if (response.data != null && response.data['data'] != null) {
        return CustomerModel.fromJson(response.data['data']);
      } else {
        throw Exception('Không tìm thấy dữ liệu khách hàng từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.info);

      if (response.data != null && response.data['data']['value'] != null) {
        return UserModel.fromJson(response.data['data']['value']);
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
