import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/list_class_off.dart';
import 'package:heathy_teacher/screens/homePage/list_class_online.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/homePage/schedule_screen.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 375.w,
            height: 296.h,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/home_background.png',
                  width: 375.w,
                  height: 296.h,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 72.h,
                  left: 16.w,
                  child: SizedBox(
                    width: 343.w,
                    //height: 52.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/avatar.png',
                          width: 48.w,
                          //height: 48.h,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Dương Huyền Anh',
                              style: defaultText18B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            dateTimeDisplayWidget(),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/bell.png',
                          width: 25.w,
                          height: 28.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 28.h,
                  right: 40.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '03\n',
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                      Text(
                        '03\n',
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                      Text('4.500.000 VNĐ', style: defaultText18B),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => CalenderScreen())),
              );
            },
            child: Container(
              height: 64.h,
              width: 343.w,
              decoration: BoxDecoration(
                color: mainDarkGreen,
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Image.asset(
                    'assets/images/schedule.png',
                    height: 40.h,
                    width: 40.w,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Lịch học lớp trực tiếp',
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 30.r,
                  ),
                  SizedBox(width: 22.w),
                ],
              ),
            ),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: 343.w,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => ListClassOff())),
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/class_off.svg'),
                  Text(
                    '  Lớp học trực tiếp',
                    style: defaultText16B.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    'Xem tất cả  ',
                    style: defaultText14SB.copyWith(
                      color: mainDarkGreen,
                      fontSize: 12.sp,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: mainDarkGreen),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 375.w,
            height: (264 + 48).h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => RegisterClassOff(type: 'off')),
                      ),
                    );
                  },
                  child: Container(
                    height: 264.h,
                    width: 200.w,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: index == 2 ? 16.w : 4.w,
                      top: 20.h,
                      bottom: 28.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/off_class_${index + 1}.png',
                          height: 103.h,
                          width: 184.w,
                          fit: BoxFit.fill,
                        ),
                        Row(
                          children: [
                            RatingStars(
                              rating: 4.5, // Hiển thị 4.5 sao
                              starSize: 16.r,
                            ),
                            Text(
                              '(4,5)',
                              style: defaultText14SB.copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        Text(
                          'Lớp nấu ăn Eatclean cơ bản dành cho gia đình',
                          style: defaultText14SB,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('3.000.000đ', style: defaultText16B),
                            Text(
                              '4.000.000đ',
                              style: defaultText12Re.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 32.h,
                          width: 184.w,
                          decoration: BoxDecoration(
                            color: mainDarkGreen,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tham gia ngay ',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.arrow_right_alt, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ListClassOnline())),
              );
            },
            child: SizedBox(
              width: 343.w,
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/class_online.svg'),
                  Text(
                    '  Khoá học online',
                    style: defaultText16B.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    'Xem tất cả  ',
                    style: defaultText14SB.copyWith(
                      color: mainDarkGreen,
                      fontSize: 12.sp,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: mainDarkGreen),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 375.w,
            height: (294 + 48).h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => RegisterClassOff(type: 'on')),
                      ),
                    );
                  },
                  child: Container(
                    height: 294.h,
                    width: 200.w,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: index == 2 ? 16.w : 4.w,
                      top: 20.h,
                      bottom: 28.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 103.h,
                          width: 184.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/online_class_${index + 1}.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            RatingStars(
                              rating: 4.5, // Hiển thị 4.5 sao
                              starSize: 16.r,
                            ),
                            Text(
                              '(4,5)',
                              style: defaultText14SB.copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        Text(
                          'Lớp bánh mì sandwich & pate, ăn kèm heakthy',
                          style: defaultText14SB,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('8.000.000đ', style: defaultText16B),
                            Text(
                              '9.000.000đ',
                              style: defaultText12Re.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 32.h,
                          width: 184.w,
                          decoration: BoxDecoration(
                            color: Color(0xff73BB43),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8.w),
                              Image.asset(
                                'assets/images/play_icon.png',
                                height: 16.h,
                                width: 16.w,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '15 bài học',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 32.h,
                          width: 184.w,
                          decoration: BoxDecoration(
                            color: Color(0xff73BB43),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8.w),
                              Image.asset(
                                'assets/images/play_icon.png',
                                height: 16.h,
                                width: 16.w,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '12 lượt đã học',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 343.w,
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/material_icon.svg'),
                Text(
                  '  Gian hàng nguyên liệu',
                  style: defaultText16B.copyWith(color: Colors.black),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProductScreen(type: 2),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  child: Text(
                    'Xem tất cả  ',
                    style: defaultText14SB.copyWith(
                      color: mainDarkGreen,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: mainDarkGreen),
              ],
            ),
          ),
          SizedBox(
            width: 375.w,
            height: (297 + 48).h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => DetailProductScreen()),
                      ),
                    );
                  },
                  child: Container(
                    height: 297.h,
                    width: 200.w,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: index == 2 ? 16.w : 4.w,
                      top: 20.h,
                      bottom: 28.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/material${index + 1}.png',
                          width: 184.w,
                          height: 184.h,
                          fit: BoxFit.fitWidth,
                        ),
                        Row(
                          children: [
                            RatingStars(rating: 4.5, starSize: 16.r),
                            Text(
                              '(4,5)',
                              style: defaultText14SB.copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        Text(
                          'Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300g',
                          style: defaultText14SB,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
