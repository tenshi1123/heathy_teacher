import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          'Thông báo',
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
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/person_background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            opacity: 0.12,
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
            return GestureDetector(
              onTap: () {},
              child: Container(
                //height: 116.h,
                width: 343.w,
                margin: EdgeInsets.only(bottom: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xffFFF3B5),

                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/notification.png',
                      width: 64.w,
                      //height: 40.h,
                      fit: BoxFit.fitWidth,
                    ),
                    Spacer(),
                    SizedBox(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khoá học nấu ăn của bạn có album mới',
                            style: defaultText14B,
                          ),
                          Text('2 phút trước', style: defaultText14Re),
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
    );
  }
}
