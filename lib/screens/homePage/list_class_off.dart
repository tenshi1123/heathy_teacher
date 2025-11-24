import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';

class ListClassOff extends StatefulWidget {
  const ListClassOff({super.key});

  @override
  State<ListClassOff> createState() => _ListClassOffState();
}

class _ListClassOffState extends State<ListClassOff> {
  late int currentPage = 1;
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
          'Danh sách lớp trực tiếp',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
        padding: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              physics: const ClampingScrollPhysics(),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
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
                    width: 343.w,
                    //height: 106.h,
                    margin: EdgeInsets.only(bottom: index == 5 ? 80 : 16.h),
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
                          'assets/images/off_class_4.png',
                          height: 90.h,
                          width: 90.w,
                          fit: BoxFit.fill,
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
                                'Lớp nấu ăn Eatclean cơ bản dành cho gia đình',
                                style: defaultText14SB,
                              ),
                              Row(
                                children: [
                                  Text('3.000.000đ', style: defaultText16B),
                                  SizedBox(width: 12.w),
                                  Text(
                                    '4.000.000đ',
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
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 76.h,
                width: 375.w,
                padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
                decoration: BoxDecoration(color: Colors.white),
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalPages: 6,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
