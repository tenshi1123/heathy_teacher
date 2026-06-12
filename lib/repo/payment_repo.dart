import 'package:dio/dio.dart';

import 'package:heathy_teacher/models/payment_model.dart';
import 'package:heathy_teacher/utils/DioClient.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';

class PaymentRepo {
  Future<List<PaymentModel>> getPendingPayment() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.pendingPayment);
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['value'] != null) {
        final List listData = response.data['data']['value'] as List;

        return listData
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
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

  Future<List<PaymentModel>> getPaymentHistory() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.paymentHistory);
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['value'] != null) {
        final List listData = response.data['data']['value'] as List;

        return listData
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
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
