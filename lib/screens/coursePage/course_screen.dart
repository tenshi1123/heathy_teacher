import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/coursePage/online_class_screen.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool isLoading = true;
  List<CourseScheduleModel> courses = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading = true;
    courses = await CourseRepo().getCourse();
    setState(() {
      isLoading = false;
    });
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
          'Khoá học'.sanitizeForApple,
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        //automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // Icon 3 gạch
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Lệnh gọi Drawer trượt ra
              },
            );
          },
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
      drawer: MyCustomDrawer(userModel: widget.userModel, selectedIndex: 1),
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
        child: courses.isEmpty
            ? Center(
                child: Text('Bạn chưa có khóa học nào!'.sanitizeForApple, style: defaultText16M),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 20.h,
                  top: 16.h,
                ),
                physics: const ClampingScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (BuildContext context, int index) {
                  // 1. Lấy ra item hiện tại
                  final course = courses[index];
                  final int percent = course.percentLearning ?? 0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              OnlineClassScreen(course: course)),
                        ),
                      );
                    },
                    child: Container(
                      width: 343.w,
                      margin: EdgeInsets.only(bottom: 20.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5FAF5),
                        border: Border.all(
                          color: mainDarkGreen.withValues(alpha: 0.28),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
  imageUrl: 'https://lms.cogiaohealthy.vn/images/${course.img}',
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    'assets/images/course_icon_0.png',
                                    width: 40.w,
                                    height: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 257.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.courseName ??
                                      'Chưa cập nhật tên khoá học'.sanitizeForApple,
                                  style: defaultText16B,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),

                                Text(
                                  course.settingCourseTypeName ??
                                      'Đang cập nhật hình thức',
                                  style: defaultText14Re,
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Container(
                                      height: 8.h,
                                      width: 217.w,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEDEDED),
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Container(
                                        height: 8.h,
                                        width: 217.w * (percent / 100),
                                        decoration: BoxDecoration(
                                          color: mainDarkGreen,
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      ' $percent%',
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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
