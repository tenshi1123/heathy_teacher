import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/models/payment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class OrderInfoScreen extends StatefulWidget {
  final OrderResponse orderResponse;

  const OrderInfoScreen({Key? key, required this.orderResponse}) : super(key: key);

  @override
  State<OrderInfoScreen> createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  String _formatCurrency(num? value) {
    if (value == null) return '0đ';
    return '${NumberFormat('#,###', 'vi_VN').format(value)}đ';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.orderResponse.data;
    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Thông tin đơn hàng')),
        body: const Center(child: Text('Không có dữ liệu đơn hàng')),
      );
    }

    final customer = data.customer;
    final payment = data.paymentInfo;
    final bankInfo = data.bankInfo;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) => const SizedBox(height: 100),
              ),
            ),
            const SizedBox(height: 32),

            // Thông tin học viên
            const Text(
              'THÔNG TIN HỌC VIÊN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Họ tên học viên', customer?.fullName ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('Số điện thoại', customer?.phone ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('Email', customer?.email ?? ''),
            const SizedBox(height: 32),

            // Thông tin khóa học
            const Text(
              'THÔNG TIN KHÓA HỌC',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (data.items != null)
              ...data.items!.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.stt ?? ''}. ${item.name ?? ''}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatCurrency(item.price),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            const SizedBox(height: 20),

            // Thông tin thanh toán
            const Text(
              'THÔNG TIN THANH TOÁN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentRow('Số tiền:', _formatCurrency(payment?.totalAmount)),
            _buildPaymentRow('Giảm giá:', _formatCurrency(payment?.discountAmount)),
            _buildPaymentRow('Giảm trừ tiền mặt:', _formatCurrency(payment?.cashDeduction)),
            _buildPaymentRow('Ưu đãi giảm giá khóa học online:', _formatCurrency(payment?.valuePercent)),
            _buildPaymentRow('Điểm tích lũy:', _formatCurrency(payment?.accumulatePoint)),
            _buildPaymentRow('Phí vận chuyển:', _formatCurrency(payment?.freeShip)),
            _buildPaymentRow('Đã thanh toán:', payment?.daThanhToan?.toString() ?? '0'),
            _buildPaymentRow('Tổng tiền:', _formatCurrency(payment?.finalTotalAmount)),
            _buildPaymentRow('Hình thức thanh toán:', payment?.paymentMethodName ?? '', isLast: true),

            const SizedBox(height: 24),

            // Lời nhắn chuyển khoản
            if (bankInfo != null) ...[
              Text(
                'Khách hàng vui lòng chuyển khoản qua số tài khoản ${bankInfo.accountNumber ?? ''} (${bankInfo.bankName ?? ''}) chủ tài khoản: ${bankInfo.owner ?? ''}, hoặc quét mã QR sau để thanh toán',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              if (bankInfo.qrUrl != null && bankInfo.qrUrl!.isNotEmpty) ...[
                Center(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: bankInfo.qrUrl!,
                        width: 250,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await _screenshotController.capture(
                          delay: const Duration(milliseconds: 10),
                        );
                        if (image != null) {
                          final result = await ImageGallerySaverPlus.saveImage(image);
                          if (result['isSuccess'] == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lưu ảnh QR thành công!')),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Không thể lưu ảnh QR')),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi khi lưu ảnh: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C), // Màu xanh
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Tải mã QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],

            if (data.payCode != null)
              Center(
                child: Text(
                  'Khách hàng vui lòng nhập đúng cú pháp để\ntránh nhầm lẫn: ${data.payCode}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // Chữ ký
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'Người thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'TP.Hà Nội, ngày ${DateTime.now().day} tháng ${DateTime.now().month.toString().padLeft(2, '0')} năm ${DateTime.now().year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Người lập đơn',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        data.userName ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
