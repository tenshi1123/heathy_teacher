import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class ProductRepo {
  Future<List<CategoryModel>> getCategory({int page = 1, int show = 10}) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.productCatalog,
        data: jsonEncode({"page": page.toString(), "show": show.toString()}),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
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

  Future<List<CategoryDetail>> getListProduct(
    String categorySlug, {
    int page = 1,
    int show = 10,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      dio.options.headers['Token'] = 'Healthy1234567890HVG';
      final response = await dio.post(
        ApiPath.listProduct,
        data: jsonEncode({
          'category_slug': categorySlug,
          "page": page.toString(),
          "show": show.toString(),
        }),
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;

        return listData
            .map((e) => CategoryDetail.fromJson(e as Map<String, dynamic>))
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
