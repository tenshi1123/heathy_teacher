import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class OrderPaymentScreen extends StatefulWidget {
  const OrderPaymentScreen({super.key});

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: 343.w,
      height: 48.h,
      margin: EdgeInsets.only(right: 12.w, bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: defaultText14B,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: colorText.withValues(alpha: 0.4)),
        ),
      ),
    );
  }

  int get totalPrice {
    int total = 0;
    for (var item in globalListCart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Thanh toán đơn hàng',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Text('Điền thông tin của bạn', style: defaultText16B),
                  _buildInputField(
                    hintText: 'Họ và tên*',
                    controller: _nameController,
                  ),
                  _buildInputField(
                    hintText: 'Số điện thoại*',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  CustomTextField(
                    hintText: 'Tỉnh/Thành phố',
                    controller: _provinceController,
                  ),
                  CustomTextField(
                    hintText: 'Quận/Huyện',
                    controller: _districtController,
                  ),
                  CustomTextField(
                    hintText: 'Xã/Phường',
                    controller: _wardController,
                  ),
                  CustomTextField(
                    hintText: 'Địa chỉ cụ thể*',
                    controller: _addressController,
                  ),
                  SizedBox(height: 24.h),
                  Text('Thông tin đơn hàng', style: defaultText16B),
                  ...globalListCart.map((item) {
                    return Container(
                      height: 106.h,
                      width: 343.w,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Slidable(
                        key: ValueKey(item.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                setState(() {
                                  globalListCart.remove(item);
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r),
                              ),
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: item.image.startsWith('http')
                                  ? NetworkImage(item.image)
                                  : AssetImage(item.image) as ImageProvider,
                              height: 90.h,
                              width: 90.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 217.w,
                                  child: Text(
                                    item.name,
                                    style: defaultText14SB,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 200.w,
                                  child: QuantityCounter(
                                    price: item.price,
                                    quantity: item.quantity,
                                    onChanged: (value) {
                                      setState(() {
                                        item.quantity = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16.h),
                    child: CustomDotLine(
                      dotSize: 6.w,
                      spacing: 6.w,
                      color: colorText.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 211.w,
                        height: 48.h,
                        margin: EdgeInsets.only(right: 12.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FB), // nền giống ảnh
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          //ontroller: widget.controller,
                          style: defaultText14B, // màu text nhập
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mã Giảm giá',
                            hintStyle: defaultText14Re, // hint luôn xám
                          ),
                        ),
                      ),
                      Container(
                        width: 120.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: mainGreen,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: mainDarkGreen.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Áp dụng',
                            style: defaultText16B.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16.h),
                    child: CustomDotLine(
                      dotSize: 6.w,
                      spacing: 6.w,
                      color: colorText.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền hàng:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                        style: defaultText20B.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Giảm giá:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '0đ',
                        style: defaultText20B.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng hoá đơn:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                        style: defaultText20B.copyWith(
                          fontSize: 24.sp,
                          color: mainDarkGreen,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 98.h,
                width: 375.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (_nameController.text.trim().isEmpty ||
                        _phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng điền họ và tên và số điện thoại',
                          ),
                        ),
                      );
                      return;
                    }

                    bool hasCourse = globalListCart.any(
                      (item) => item.isCourse,
                    );
                    bool hasProduct = globalListCart.any(
                      (item) => !item.isCourse,
                    );

                    if (hasCourse && hasProduct) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng thanh toán khóa học và nguyên liệu máy riêng biệt',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final payload = {
                        "full_name": _nameController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "promo_code": "",
                        "payment_method_id": 1,
                        "price_promo_code_online": 0,
                        "free_ship": 0,
                        "accumulate_point": 0,
                        "province": _provinceController.text.trim(),
                        "district": _districtController.text.trim(),
                        "ward": _wardController.text.trim(),
                        "address": _addressController.text.trim(),
                        "cart": globalListCart
                            .map(
                              (item) => hasCourse
                                  ? {
                                      "course_type_id": int.parse(
                                        item.courseTypeId ?? '',
                                      ),
                                      "quantity": item.quantity,
                                    }
                                  : {
                                      "product_id": int.parse(item.id),
                                      "quantity": item.quantity,
                                    },
                            )
                            .toList(),
                      };
                      //get remember_me_token
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final String? token = prefs.getString('remember_token');
                      final payCode = hasCourse
                          ? await ExternalRepo().paymentCourse(payload, token)
                          : await ExternalRepo().paymentProduct(payload, token);

                      final String customerId =
                          '${DateTime.now().millisecondsSinceEpoch}${math.Random().nextInt(9999).toString().padLeft(4, '0')}';
                      await prefs.setString('customer_id', customerId);

                      String addInfo =
                          '${payCode.payCode} W$customerId ${payCode.isLogin ?? ''}';
                      if (payCode.courseScheduleId != null &&
                          payCode.courseScheduleId.toString().isNotEmpty) {
                        addInfo += ' C${payCode.courseScheduleId}';
                      }

                      Navigator.pop(context); // close loading dialog

                      // If we want to show dynamic QR code, we could use payCode here,
                      // but for now keeping the existing UI logic
                      if (!context.mounted) return;
                      ScreenshotController screenshotController =
                          ScreenshotController();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Screenshot(
                                    controller: screenshotController,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Quét mã QR để thanh toán',
                                            style: defaultText18B.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Image.network(
                                            'https://img.vietqr.io/image/${payCode.bankCode}-${payCode.bankAccount}-compact2.png?amount=${payCode.price}&addInfo=${Uri.encodeComponent(addInfo.trim())}',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                if (context.mounted) {
                                                  Navigator.pop(context); // Đóng dialog QR hiện tại
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text(
                                                        'Lỗi',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: const Text('Không thể tạo mã QR thanh toán lúc này. Vui lòng thử lại sau!'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: Text(
                                                            'Đóng',
                                                            style: TextStyle(
                                                              color: mainDarkGreen,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              });
                                              return const SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 48,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainDarkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Đóng',
                                          style: defaultText16B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            final image =
                                                await screenshotController
                                                    .capture(
                                                      delay: const Duration(
                                                        milliseconds: 10,
                                                      ),
                                                    );
                                            if (image != null) {
                                              final result =
                                                  await ImageGallerySaverPlus.saveImage(
                                                    image,
                                                  );
                                              if (result['isSuccess'] == true &&
                                                  context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Lưu ảnh QR thành công!',
                                                    ),
                                                  ),
                                                );
                                              } else if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Không thể lưu ảnh QR',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Lỗi khi lưu ảnh: `e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainDarkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Tải QR',
                                          style: defaultText16B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      Navigator.pop(context); // close loading dialog
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                    }
                  },
                  child: Container(
                    width: 343.w,
                    height: 50.h,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      bottom: 30.h,
                      top: 16.w,
                      right: 16.w,
                    ),
                    constraints: BoxConstraints(maxHeight: 120.h),
                    decoration: BoxDecoration(
                      color: mainDarkGreen,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    child: Center(
                      child: Text(
                        "Xác nhận thanh toán",
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
