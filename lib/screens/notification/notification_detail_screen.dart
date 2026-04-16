import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String time;
  final String content;

  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.time,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chi tiết thông báo',
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
        padding: EdgeInsets.all(16.w),
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
              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 16.h),

              /// TITLE
              Text(title, style: defaultText16B),

              SizedBox(height: 6.h),

              /// TIME
              Text(time, style: defaultText14Re.copyWith(color: Colors.grey)),

              SizedBox(height: 16.h),

              /// CONTENT
              Text(content, style: defaultText14Re.copyWith(height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
