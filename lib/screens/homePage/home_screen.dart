import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:heathy_teacher/screens/homePage/list_class_off.dart';
import 'package:heathy_teacher/screens/homePage/list_class_online.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/homePage/schedule_screen.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.customerModel,
    this.onCourseTabRequested,
    this.onProductTabRequested,
  });
  final UserModel userModel;
  final CustomerModel customerModel;
  final VoidCallback? onCourseTabRequested;
  final VoidCallback? onProductTabRequested;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyCustomDrawer(userModel: userModel, selectedIndex: 0),
      backgroundColor: Colors.white,
      body: StatefulBuilder(
        builder: (context, setState) {
          return RefreshIndicator(
            color: mainDarkGreen,
            onRefresh: () async {
              try {
                final futureCourse = await ExternalRepo().getListCourse(
                  show: 6,
                );
                final futureCourseOff = await ExternalRepo().getListCourseOff(
                  show: 6,
                );
                setState(() {
                  globalListCourse = futureCourse;
                  globalListCourseOff = futureCourseOff;
                });
              } catch (e) {
                print('Lỗi làm mới: $e');
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: 375.w,
                    height: 296.w,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/home_background2.png',
                          width: 375.w,
                          height: 296.w,
                          fit: BoxFit.cover,
                        ),

                        Positioned(
                          top: 72.w,
                          left: 16.w,
                          child: SizedBox(
                            width: 343.w,
                            //height: 52.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Builder(
                                  builder: (BuildContext context) {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 32,
                                        color: Colors.white,
                                      ), // Nút 3 gạch tự tạo
                                      onPressed: () {
                                        // Gọi lệnh mở Drawer
                                        Scaffold.of(context).openDrawer();
                                      },
                                    );
                                  },
                                ),
                                avatar(userModel.img),

                                SizedBox(width: 16.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, ${userModel.fullName}',
                                      style: defaultText18B.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    //dateTimeDisplayWidget(),
                                    SelectableText.rich(
                                      TextSpan(
                                        style: defaultText14M.copyWith(
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(text: 'Mã giới thiệu: '),
                                          TextSpan(
                                            text: userModel.customerCode,
                                            style: defaultText14B.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            NotificationScreen()),
                                      ),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/bell.svg',
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 97.w,
                          right: 40.w,
                          child: GestureDetector(
                            onTap: onCourseTabRequested,
                            child: Text(
                              customerModel.course.toString(),
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 48.w,
                          right: 40.w,
                          child: GestureDetector(
                            onTap: onProductTabRequested,
                            child: Text(
                              customerModel.product.toString(),
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 20.w,
                        //   right: 40.w,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: ((context) => HocPhiScreen()),
                        //         ),
                        //       );
                        //     },
                        //     child: Text(
                        //       '${NumberFormat.decimalPattern('vi_VN').format(customerModel.paymentHistory)} VNĐ',

                        //       style: defaultText18B,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => CalenderScreen()),
                        ),
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
                          MaterialPageRoute(
                            builder: ((context) => ListClassOff()),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/class_off.svg'),
                          Text(
                            ' Gợi ý các khóa học trực tiếp'.sanitizeForApple,
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
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: mainDarkGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 375.w,
                    height: (256 + 48).h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: globalListCourseOff.length,
                      itemBuilder: (context, index) {
                        return _OfflineClassCard(
                          model: globalListCourseOff[index],
                        );
                      },
                    ),
                  ),
                  if (isShow == 'true')
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ListClassOnline()),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 343.w,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/class_online.svg'),
                            Text(
                              ' Gợi ý các khóa học online'.sanitizeForApple,
                              style: defaultText16B.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Xem tất cả  ',
                              style: defaultText14SB.copyWith(
                                color: mainDarkGreen,
                                fontSize: 12.sp,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: mainDarkGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isShow == 'true')
                    SizedBox(
                      width: 375.w,
                      height: (294 + 48).h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: globalListCourse.length,
                        itemBuilder: (context, index) {
                          return _OnlineClassCard(
                            index: index,
                            model: globalListCourse[index],
                          );
                        },
                      ),
                    ),
                  // SizedBox(
                  //   width: 343.w,
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset('assets/icons/material_icon.svg'),
                  //       Text(
                  //         '  Gian hàng nguyên liệu',
                  //         style: defaultText16B.copyWith(color: Colors.black),
                  //       ),
                  //       Spacer(),
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             PageRouteBuilder(
                  //               pageBuilder:
                  //                   (context, animation, secondaryAnimation) =>
                  //                       ProductScreen(type: 2, userModel: userModel),
                  //               transitionsBuilder:
                  //                   (context, animation, secondaryAnimation, child) {
                  //                     return FadeTransition(
                  //                       opacity: animation,
                  //                       child: child,
                  //                     );
                  //                   },
                  //             ),
                  //           );
                  //         },
                  //         child: Text(
                  //           'Xem tất cả  ',
                  //           style: defaultText14SB.copyWith(
                  //             color: mainDarkGreen,
                  //             fontSize: 12.sp,
                  //           ),
                  //         ),
                  //       ),
                  //       Icon(Icons.keyboard_arrow_right, color: mainDarkGreen),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 375.w,
                  //   height: (297 + 48).h,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     shrinkWrap: true,
                  //     physics: const ScrollPhysics(),
                  //     itemCount: 3,
                  //     itemBuilder: (context, index) {
                  //       return _MaterialProductCard(index: index);
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OfflineClassCard extends StatelessWidget {
  final CourseOffModel model;
  const _OfflineClassCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => RegisterClassOff(id: model.id ?? '')),
          ),
        );
      },
      child: Container(
        height: 256.h,
        width: 200.w,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 8.w,
          top: 20.h,
          bottom: 28.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff062905).withValues(alpha: 0.16),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              model.img ?? '',
              //height: 103.h,
              width: 184.w,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, color: Colors.grey);
              },
              loadingBuilder:
                  (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child; // Đã tải xong
                    }
                    return Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.grey[100],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
            ),
            // Row(
            //   children: [
            //     RatingStars(rating: 4.5, starSize: 16.r),
            //     Text('(4,5)', style: defaultText14SB.copyWith(fontSize: 12.sp)),
            //   ],
            // ),
            Text(
              model.name ?? 'Không xác định',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: defaultText14SB,
            ),
            if (isShow == 'true')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? ''))}đ',
                    style: defaultText16B,
                  ),
                  if (model.priceOld != '0')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? ''))}đ',
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
                    style: defaultText14SB.copyWith(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlineClassCard extends StatelessWidget {
  final int index;
  final CourseModel model;
  const _OnlineClassCard({required this.index, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                RegisterClassON(id: model.courseTypeId ?? '')),
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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff062905).withValues(alpha: 0.16),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 184.w, // Cố định chiều rộng
              // Cố tình KHÔNG set height ở đây để chiều cao tự động co giãn
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  8.r,
                ), // Vẫn giữ được bo góc như cũ
                child: Image.network(
                  model.img ??
                      'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg', // URL ảnh dự phòng
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            // Row(
            //   children: [
            //     RatingStars(rating: 4.5, starSize: 16.r),
            //     Text('(4,5)', style: defaultText14SB.copyWith(fontSize: 12.sp)),
            //   ],
            // ),
            Text(
              model.courseName ?? 'Không xác định',
              maxLines: 2,
              style: defaultText14SB,
            ),
            if (isShow == 'true')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? ''))}đ',
                    style: defaultText16B,
                  ),
                  if (model.priceOld != '0')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? ''))}đ',
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
                color: const Color(0xff73BB43),
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
                    '${model.lessonNumber} bài học',
                    style: defaultText14SB.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              height: 32.h,
              width: 184.w,
              decoration: BoxDecoration(
                color: const Color(0xff73BB43),
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
                    '${model.totalEnrollments} lượt học',
                    style: defaultText14SB.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialProductCard extends StatelessWidget {
  final int index;
  const _MaterialProductCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => DetailProductScreen())),
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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff062905).withValues(alpha: 0.16),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                Text('(4,5)', style: defaultText14SB.copyWith(fontSize: 12.sp)),
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
  }
}
