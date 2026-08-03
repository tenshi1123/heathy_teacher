import 'dart:convert';
import 'dart:io';

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

  Future<String> changeInfo({
    required String name,
    required String email,
    required String dob,
    required String phone,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.editProfile,
        data: FormData.fromMap({
          'full_name': name,
          'phone': phone,
          'email': email,
          'dob': dob,
        }),
      );
      final data = response.data;
      if (data['status'] == 'true') {
        return 'Cập nhật thông tin thành công';
      } else if (data['status'] == 'false') {
        final message = data['message'];
        if (message is Map) {
          return message.entries.map((e) => e.value.toString()).join(', ');
        }
        return message.toString();
      } else {
        return 'Có lỗi không xác định xảy ra.';
      }
    } catch (e) {
      if (e is DioException) {
        return 'Lỗi mạng hoặc server: ${e.message}';
      }
      return 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  Future<String> changeAvatar(File photo) async {
    final dio = await DioClient.getInstance();
    Response response;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });
    response = await dio.post(ApiPath.changeAvatar, data: formData);
    return response.data['message'];
  }

  Future<List<PostModel>> getPosts({
    required String slug,
    required int limit,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.listBaiviet,
        data: jsonEncode({"category_slug": slug, "limit": limit}),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
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

  Future<PostModel> getDetailPost(String slug) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.detailBaiviet,
        data: jsonEncode({"slug": slug}),
      );

      if (response.data != null && response.data['data'] != null) {
        return PostModel.fromJson(response.data['data']);
      } else {
        throw Exception('Không tìm thấy dữ liệu bài viết từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<PolicyModel> getPolicy() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.chinhSach);

      if (response.data != null && response.data['data'] != null) {
        return PolicyModel.fromJson(response.data['data']);
      } else {
        throw Exception('Không tìm thấy dữ liệu chính sách từ server.');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }
}
