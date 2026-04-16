import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/notification_model.dart';
import 'package:heathy_teacher/screens/notification/notification_detail_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
      title: 'Khoá học nấu ăn của bạn có album mới',
      image: 'assets/images/notification.png',
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
    ),
    NotificationModel(
      title: 'Khoá học nấu ăn của bạn có album mới',
      image: 'assets/images/notification.png',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      title: 'Khoá học nấu ăn của bạn có album mới',
      image: 'assets/images/notification.png',
      time: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      title: 'Khoá học nấu ăn của bạn có album mới',
      image: 'assets/images/notification.png',
      time: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = groupNotifications(notifications);
    final keys = grouped.keys.toList();

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
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: keys.length,
          itemBuilder: (context, index) {
            String date = keys[index];
            List<NotificationModel> items = grouped[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE DATE
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    date,
                    style: defaultText16M.copyWith(
                      color: const Color(0xffFFD54F),
                    ),
                  ),
                ),

                /// LIST ITEM
                ...items.map((e) => notificationItem(e)),

                SizedBox(height: 16.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget notificationItem(NotificationModel model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          model.isRead = true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(
              title: model.title,
              image: model.image,
              time: '20:05 - 28/10/2022',
              content:
                  'Lớp học nấu ăn của bạn đã có album mới, hãy vào xem ngay nhé!',
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: model.isRead ? Colors.white : const Color(0xffFFF3B5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(model.image, width: 64.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.title, style: defaultText14B),
                  SizedBox(height: 4.h),
                  Text('2 phút trước', style: defaultText14Re),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
