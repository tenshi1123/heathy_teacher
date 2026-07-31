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

  Future<OrderResponse?> getOrderInfo(int orderId) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.orderInfo,
        data: {
          "order_id": orderId,
        },
      );
      if (response.data != null) {
        return OrderResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }

  Future<List<PromoCodeModel>> getListPromoCode({
    required String type,
    required int memberRanking,
    required int totalPrice,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        ApiPath.listPromoCode,
        data: {
          "type": type,
          "member_ranking": memberRanking,
          "total_price": totalPrice,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        final List listData = response.data['data'] as List;
        return listData
            .map((e) => PromoCodeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }
}
