import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/screens/shoppingCart/order_payment_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:intl/intl.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int selectedIndex = 0;

  List<CartItem> get courses => globalListCart.where((item) => item.isCourse).toList();
  List<CartItem> get products => globalListCart.where((item) => !item.isCourse).toList();

  int get totalPrice {
    int total = 0;
    for (var item in globalListCart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void onCartChanged() {
    setState(() {});
  }

  void onDelete(CartItem item) {
    setState(() {
      globalListCart.remove(item);
    });
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
          'Giỏ hàng của bạn',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  CartSection(
                    title: "Khóa học".sanitizeForApple,
                    items: courses,
                    onChanged: onCartChanged,
                    onDelete: onDelete,
                  ),
                  const SizedBox(height: 20),
                  CartSection(
                    title: "Nguyên liệu - Máy",
                    items: products,
                    onChanged: onCartChanged,
                    onDelete: onDelete,
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: CustomDotLine(
                      dotSize: 6.w,
                      spacing: 6.w,
                      color: colorText.withValues(alpha: 0.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền hàng:',
                          style: defaultText14SB.copyWith(fontSize: 16.sp),
                        ),
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                          style: defaultText20B.copyWith(fontSize: 24.sp),
                        ),
                      ],
                    ),
                  ),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => OrderPaymentScreen()),
                      ),
                    );
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
                        "Thanh toán",
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
