import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class ListClassScreen extends StatefulWidget {
  const ListClassScreen({super.key});

  @override
  State<ListClassScreen> createState() => _ListClassScreenState();
}

class _ListClassScreenState extends State<ListClassScreen> {
  @override
  void initState() {
    super.initState();
  }

  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Lớp học trực tiếp',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => NotificationScreen())),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Color(0xffE8F2E9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedTab == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Đã diễn ra ",
                              style: defaultText14M.copyWith(
                                color: selectedTab == 0
                                    ? colorText
                                    : colorText.withValues(alpha: 0.8),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? mainDarkGreen
                                    : Color(0xffA5C9A9),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Text(
                                '6',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),

                        decoration: BoxDecoration(
                          color: selectedTab == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Chưa diễn ra",
                              style: defaultText14M.copyWith(
                                color: selectedTab == 1
                                    ? colorText
                                    : colorText.withValues(alpha: 0.8),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? mainDarkGreen
                                    : Color(0xffA5C9A9),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Text(
                                '10',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: 343.w,
                height: 218.h,
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff062905).withValues(alpha: 0.16),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 318.w,
                      height: 34.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: backGroundGreen,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/calender_icon.png'),
                          SizedBox(width: 8.w),
                          Text(
                            '01, tháng 12',
                            style: defaultText14SB.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 16.h,
                            width: 2.w,
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                            color: Colors.white.withValues(alpha: 0.48),
                          ),
                          Text(
                            'Thứ 6 (08:30 - 10:30)',
                            style: defaultText14SB.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 318.w,
                      child: Text(
                        'Buổi 1: 3 món ăn healthy dễ làm cho nhân viên văn phòng',
                        style: defaultText16B.copyWith(
                          color: Color(0xff09204E),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 318.w,
                      child: Text(
                        '• Học và thực hành trực tiếp tại trung tâm với\n  Cô giáo và đội ngũ trợ giảng\n• Hướng dẫn học viên tự pha và thực hành\n  gần 20 lọại sauce Healthy và ứng dụng',
                        style: defaultText14Re.copyWith(
                          color: Color(0xff09204E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 343.w,
              height: 218.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff062905).withValues(alpha: 0.16),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 318.w,
                    height: 34.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: backGroundGreen,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/calender_icon.png'),
                        SizedBox(width: 8.w),
                        Text(
                          '01, tháng 12',
                          style: defaultText14SB.copyWith(color: Colors.white),
                        ),
                        Container(
                          height: 16.h,
                          width: 2.w,
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          color: Colors.white.withValues(alpha: 0.48),
                        ),
                        Text(
                          'Thứ 6 (08:30 - 10:30)',
                          style: defaultText14SB.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 318.w,
                    child: Text(
                      'Buổi 1: 3 món ăn healthy dễ làm cho nhân viên văn phòng',
                      style: defaultText16B.copyWith(color: Color(0xff09204E)),
                    ),
                  ),
                  SizedBox(
                    width: 318.w,
                    child: Text(
                      '• Học và thực hành trực tiếp tại trung tâm với\n  Cô giáo và đội ngũ trợ giảng\n• Hướng dẫn học viên tự pha và thực hành\n  gần 20 lọại sauce Healthy và ứng dụng',
                      style: defaultText14Re.copyWith(color: Color(0xff09204E)),
                    ),
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
