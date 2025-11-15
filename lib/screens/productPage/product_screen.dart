import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
          'Sản phẩm',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          SvgPicture.asset(
            'assets/icons/menu_icon.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 16.w),
        ],
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  'Nguyên liệu lớp nấu ăn chay',
                  style: defaultText16B,
                ),
              ),
              SizedBox(height: 20.h),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.w),
                physics: const ClampingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 343.w,
                    //height: 106.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff062905).withValues(alpha: 0.16),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(
                            0,
                            4,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/material.png',
                          height: 90.h,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 217.w,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  RatingStars(
                                    rating: 4.6, // Hiển thị 4.5 sao
                                    starSize: 16.r,
                                  ),
                                  Text(
                                    '(4,6)',
                                    style: defaultText14SB.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300g',
                                style: defaultText14SB,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('128.000đ', style: defaultText16B),
                                  Text(
                                    '250.000đ',
                                    style: defaultText12Re.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
