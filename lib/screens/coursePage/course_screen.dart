import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
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
          'Khoá học',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          SvgPicture.asset(
            'assets/icons/bell.svg',
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
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
            top: 16.h,
          ),
          physics: const ClampingScrollPhysics(),
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              //height: 116.h,
              width: 343.w,
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Color(0xffF5FAF5),
                border: Border.all(
                  color: mainDarkGreen.withValues(alpha: 0.28),
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/course_icon_$index.png',
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.fitWidth,
                  ),
                  Spacer(),
                  SizedBox(
                    width: 257.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lớp Combo chuyên đề Eatclean nâng cao',
                          style: defaultText16B,
                        ),
                        Text(
                          index == 0
                              ? 'Học online với video'
                              : 'Học trực tiếp tại trung tâm',
                          style: defaultText14Re,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              height: 8.h,
                              width: 217.w,
                              padding: EdgeInsets.only(right: 150.w),
                              decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Container(
                                height: 8.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: mainDarkGreen,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                            ),
                            Text(
                              ' 26%',
                              style: defaultText16B.copyWith(
                                color: mainDarkGreen,
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
      ),
    );
  }
}
