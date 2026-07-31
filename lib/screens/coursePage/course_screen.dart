import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/repo/chat_repo.dart';
import 'package:heathy_teacher/screens/chatPage/chat_screen.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/repo/payment_repo.dart';
import 'package:heathy_teacher/screens/order/order_info_screen.dart';
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
    final List<CourseScheduleModel> fetchedCourses = await CourseRepo()
        .getCourse();
    courses = isShow == 'true'
        ? fetchedCourses
        : fetchedCourses
              .where((course) => course.settingCourseTypeType != 'online')
              .toList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImagesAndSubmit(CourseScheduleModel course) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (!mounted) return;
      final TextEditingController textController = TextEditingController();
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text('Xác nhận trả bài', style: defaultText18B),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bạn có chắc chắn muốn trả bài với các ảnh đã chọn không?',
                    style: defaultText14M,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 80.h,
                    width: double.maxFinite,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              File(images[index].path),
                              height: 80.h,
                              width: 80.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung bài trả...',
                      hintStyle: defaultText14M.copyWith(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: mainDarkGreen),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Hủy', style: defaultText14B),
              ),
              TextButton(
                onPressed: () async {
                  final textContent = textController.text;
                  Navigator.pop(dialogContext);

                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (loadingContext) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    await CourseRepo().customerSubmit(
                      courseId:
                          course.courseId ?? course.courseScheduleId ?? '',
                      content: textContent,
                      courseTypeId: course.settingCourseTypeId ?? '1',
                      isPointAcc: 0,
                      files: images.map((e) => e.path).toList(),
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trả bài thành công!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                    }
                  }
                },
                child: Text(
                  'Trả bài',
                  style: defaultText14SB.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          );
        },
      );
    }
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
          'Khoá học của tôi'.sanitizeForApple,
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : courses.isEmpty
            ? Center(
                child: Text(
                  'Bạn chưa có khóa học nào!'.sanitizeForApple,
                  style: defaultText16M,
                ),
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

                  return Container(
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
                            imageUrl:
                                'https://lms.cogiaohealthy.vn/images/${course.img}',
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
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
                                    'Chưa cập nhật tên khoá học'
                                        .sanitizeForApple,
                                style: defaultText16B,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              if (isShow == 'true')
                                Text(
                                  course.settingCourseTypeName ??
                                      'Đang cập nhật hình thức',
                                  style: defaultText14Re,
                                ),
                              SizedBox(height: 12.h),
                              if (course.soBuoiHoc != null)
                                GestureDetector(
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
                                    height: 32.h,
                                    width: 150.w,
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE89A48),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Text(
                                            'Bài giảng',
                                            style: defaultText14B.copyWith(
                                              color: const Color(0xFFE89A48),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 32.h,
                                          height: 32.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE89A48),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (course.soBuoiHoc == null)
                                GestureDetector(
                                  onTap: () async {
                                    if (course.orderId == null) return;
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                      final orderInfo = await PaymentRepo()
                                          .getOrderInfo(
                                            int.tryParse(course.orderId!) ?? 0,
                                          );
                                      Navigator.pop(context);
                                      if (orderInfo != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderInfoScreen(
                                                  orderResponse: orderInfo,
                                                ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Không thể tải thông tin đơn hàng',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      debugPrint('Lỗi tải order info: $e');
                                    }
                                  },
                                  child: Container(
                                    height: 32.h,
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE89A48),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Text(
                                            'Chờ thanh toán',
                                            style: defaultText14B.copyWith(
                                              color: const Color(0xFFE89A48),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 32.h,
                                          height: 32.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE89A48),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.access_time_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (course.soBuoiHoc != null)
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                      final chatCourse = await ChatRepo()
                                          .getChatCourse(
                                            courseId:
                                                course.courseScheduleId ?? '',
                                            courseType:
                                                course.courseTypeId ?? '',
                                          );
                                      Navigator.pop(context);
                                      if (chatCourse.courseSchedule != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              model: chatCourse.courseSchedule!,
                                              courseScheduleId:
                                                  course.courseScheduleId,
                                              courseTypeId: course.courseTypeId,
                                              initialMessages:
                                                  chatCourse.listMessage,
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      debugPrint('Lỗi chat hỗ trợ: $e');
                                    }
                                  },
                                  child: Container(
                                    height: 32.h,
                                    width: 150.w,
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE89A48),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Text(
                                            'Chat hỗ trợ',
                                            style: defaultText14B.copyWith(
                                              color: const Color(0xFFE89A48),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 32.h,
                                          height: 32.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE89A48),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.message,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Container(
                                  //   height: 44.h,
                                  //   width: 162.w,
                                  //   decoration: BoxDecoration(
                                  //     color: Color(0xffEEF5EC),
                                  //     border: Border.all(
                                  //       color: mainDarkGreen.withValues(
                                  //         alpha: 0.28,
                                  //       ),
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(16.r),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       SvgPicture.asset(
                                  //         'assets/icons/chat.svg',
                                  //         width: 20.w,
                                  //         height: 20.h,
                                  //         colorFilter: ColorFilter.mode(
                                  //           mainDarkGreen,
                                  //           BlendMode.srcIn,
                                  //         ),
                                  //       ),
                                  //       SizedBox(width: 8.w),
                                  //       Text(
                                  //         'Chat hỗ trợ',
                                  //         style: defaultText14SB,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ),
                              if (isShow == 'true')
                                Row(
                                  children: [
                                    Container(
                                      height: 8.h,
                                      width: 210.w,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEDEDED),
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Container(
                                        height: 8.h,
                                        width: 210.w * (percent / 100),
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
                  );
                },
              ),
      ),
    );
  }
}
