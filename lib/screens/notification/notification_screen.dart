import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/notification_model.dart';
import 'package:heathy_teacher/repo/notication_repo.dart';
import 'package:heathy_teacher/screens/notification/notification_detail_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading = true;
    notifications = await NotiRepo().getNotifications();
    isLoading = false;
    setState(() {});
  }

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
        child: RefreshIndicator(
          color: mainDarkGreen,
          onRefresh: _fetchData,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : keys.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    alignment: Alignment.center,
                    child: Text('Không có thông báo mới', style: defaultText16M),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget notificationItem(NotificationModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(
              title: model.title,

              time: model.createdAt.toString(),
              content: model.content,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.title, style: defaultText14B),
                  SizedBox(height: 4.h),
                  Text(model.content, style: defaultText14Re),
                  SizedBox(height: 4.h),
                  Text(
                    '${model.createdAt.hour}:${model.createdAt.minute}',
                    style: defaultText14B,
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
