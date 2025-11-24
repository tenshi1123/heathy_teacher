import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:intl/intl.dart';

class ShoppingCartScreen extends StatefulWidget {
  ShoppingCartScreen({super.key});
  final List<String> images = [
    'assets/images/material1.png',
    'assets/images/material2.png',
    'assets/images/material3.png',
  ];
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int selectedIndex = 0;
  int quantity = 2;
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
                  Container(
                    height: 106.h,
                    width: 343.w,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
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
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {},
                            backgroundColor: Color(0xFFFE4A49),
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
                          Image.asset(
                            'assets/images/material1.png',
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
                                  'Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300g',
                                  style: defaultText14SB,
                                ),
                              ),
                              SizedBox(
                                width: 200.w,
                                child: QuantityCounter(
                                  price: 128000,
                                  quantity: quantity,
                                  onChanged: (value) {
                                    setState(() {
                                      quantity = value; // 👈 Cập nhật realtime
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                          '${NumberFormat('#,###', 'vi_VN').format(128000 * quantity)} đ',
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
                  onTap: () {},
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
