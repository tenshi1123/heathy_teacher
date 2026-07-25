import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/screens/coursePage/video_screen.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heathy_teacher/repo/chat_repo.dart';
import 'package:heathy_teacher/screens/chatPage/chat_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:heathy_teacher/screens/coursePage/student_product_screen.dart';

class OnlineClassScreen extends StatefulWidget {
  const OnlineClassScreen({super.key, required this.course});
  final CourseScheduleModel course;
  @override
  State<OnlineClassScreen> createState() => _OnlineClassScreenState();
}

class _OnlineClassScreenState extends State<OnlineClassScreen> {
  late int currentPage = 1;
  int? expandedIndex;
  bool isLoading = true;
  CourseDetailModel? courses;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading = true;
    try {
      courses = await CourseRepo().getCourseDetail(
        courseId: widget.course.courseId ?? '89',
        settingCourseTypeId: widget.course.settingCourseTypeId ?? '1',
        courseScheduleId: widget.course.courseScheduleId ?? '54',
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImagesAndSubmit() async {
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
                          widget.course.courseId ??
                          widget.course.courseScheduleId ??
                          '',
                      content: textContent,
                      courseTypeId: widget.course.settingCourseTypeId ?? '1',
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

  Future<void> _requestCertificate() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text('Cấp chứng nhận', style: defaultText18B),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Họ và tên',
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
                SizedBox(height: 12.h),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Số điện thoại',
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
                SizedBox(height: 12.h),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'Địa chỉ nhận',
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
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                final address = addressController.text.trim();

                if (name.isEmpty || phone.isEmpty || address.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (loadingContext) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  await CourseRepo().addCertificateCourse(
                    courseId:
                        int.tryParse(
                          widget.course.courseId ??
                              widget.course.courseScheduleId ??
                              '0',
                        ) ??
                        0,
                    courseTypeId:
                        int.tryParse(
                          widget.course.settingCourseTypeId ?? '1',
                        ) ??
                        1,
                    name: name,
                    phone: phone,
                    address: address,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Yêu cầu cấp chứng nhận thành công!'),
                      ),
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
                'Gửi',
                style: defaultText14SB.copyWith(color: mainDarkGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatHtml(String? html) {
    if (html == null) return '';
    return html
        .replaceAll(RegExp(r'width:\s*\d+px;?'), '')
        .replaceAll(RegExp(r'height:\s*\d+px;?'), '');
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
          widget.course.settingCourseTypeName ?? '',
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
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : courses == null
            ? const Center(child: Text('Không có dữ liệu'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 483 / 397.76,
                      child: CachedNetworkImage(
                        imageUrl: courses!.image!.contains('https://')
                            ? courses!.image!
                            : 'https://lms.cogiaohealthy.vn/${courses!.image}',
                        width: 343.w,
                        height: 200.h,
                        fit: BoxFit.fill,
                      ),
                    ),

                    SizedBox(height: 12.h),
                    SizedBox(
                      width: 343.w,
                      child: Text(
                        courses?.title ??
                            'Lớp Combo chuyên đề Eatclean nâng cao',
                        style: defaultText18B,
                      ),
                    ),
                    Html(
                      data: _formatHtml(courses?.description),
                      // style: {
                      //   'p': Style(
                      //     fontSize: FontSize(14.sp),
                      //     color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                      //   ),
                      // },
                    ),

                    // Text(
                    //   courses.description ?? 'Học online với video'.sanitizeForApple,
                    //   style: defaultText14Re,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              final chatCourse = await ChatRepo().getChatCourse(
                                courseId: widget.course.courseScheduleId ?? '',
                                courseType: widget.course.courseTypeId ?? '',
                              );
                              Navigator.pop(context);
                              if (chatCourse.courseSchedule != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      model: chatCourse.courseSchedule!,
                                      initialMessages: chatCourse.listMessage,
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
                            height: 44.h,
                            width: 162.w,
                            decoration: BoxDecoration(
                              color: Color(0xffEEF5EC),
                              border: Border.all(
                                color: mainDarkGreen.withValues(alpha: 0.28),
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/chat.svg',
                                  width: 20.w,
                                  height: 20.h,
                                  colorFilter: ColorFilter.mode(
                                    mainDarkGreen,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text('Chat hỗ trợ', style: defaultText14SB),
                              ],
                            ),
                          ),
                        ),
                        if (widget.course.percentLearning == 100)
                          GestureDetector(
                            onTap: _pickImagesAndSubmit,
                            child: Container(
                              height: 44.h,
                              width: 162.w,
                              decoration: BoxDecoration(
                                color: Color(0xffEEF5EC),
                                border: Border.all(
                                  color: mainDarkGreen.withValues(alpha: 0.28),
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/tra_bai.svg',
                                    width: 20.w,
                                    height: 20.h,
                                    colorFilter: ColorFilter.mode(
                                      mainDarkGreen,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text('Trả bài', style: defaultText14SB),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (widget.course.percentLearning == 100) ...[
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: _requestCertificate,
                        child: Container(
                          height: 44.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: mainDarkGreen,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                ' Cấp chứng nhận',
                                style: defaultText14SB.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentProductScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 343.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: mainGreen,
                          border: Border.all(
                            color: mainDarkGreen.withValues(alpha: 0.08),
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/bling.svg',
                              width: 20.w,
                              height: 20.h,
                            ),
                            Text(
                              ' Sản phẩm của học viên',
                              style: defaultText14SB.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    if (isShow == 'true')
                      Text(
                        'Nội dung khoá học'.sanitizeForApple,
                        style: defaultText16B,
                      ),
                    if (isShow == 'true')
                      Row(
                        children: [
                          Container(
                            height: 8.h,
                            width: 270.w,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: const Color(0xffEDEDED),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Container(
                              height: 8.h,
                              width:
                                  270.w *
                                  (widget.course.percentLearning! / 100),
                              decoration: BoxDecoration(
                                color: mainDarkGreen,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),

                          Text(
                            '  ${widget.course.percentLearning!}%',
                            style: defaultText16B.copyWith(
                              color: mainDarkGreen,
                            ),
                          ),
                        ],
                      ),

                    if (isShow == 'true')
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: courses?.topicals?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return LessonItem(
                            index: index,
                            topicModel: courses?.topicals![index],
                          );
                        },
                      ),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
      ),
    );
  }
}

class LessonItem extends StatefulWidget {
  const LessonItem({super.key, required this.index, required this.topicModel});
  final int index;
  final TopicalModel? topicModel;
  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            //height: 62.h,
            width: 338.w,
            margin: EdgeInsets.only(left: 2.w, right: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 16.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Container(
                //   height: 28.h,
                //   width: 28.w,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: mainDarkGreen,
                //   ),
                //   child: Center(
                //     child: Text(
                //       '0${widget.index + 1}',
                //       style: defaultText14SB.copyWith(color: Colors.white),
                //     ),
                //   ),
                // ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 226.w,
                      child: Text(
                        widget.topicModel?.name ?? ' Không có tên chủ đề',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                    ),
                    Text(
                      '${widget.topicModel?.lessons?.length ?? 0} bài giảng / ${widget.topicModel?.documents?.length ?? 0} tài liệu',
                      style: defaultText12M,
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right_outlined),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),

        if (isExpanded)
          Column(
            children: widget.topicModel!.lessons!
                .map(
                  (e) => GestureDetector(
                    onTap: () async {
                      String url = await ExternalRepo().getStreamingUrl(
                        lessonId: e.lessonsId ?? '',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => (DetailVideo(
                            streamingUrl: url,
                            name: e.name ?? 'Không có tên bài giảng',
                          ))),
                        ),
                      );
                    },
                    child: DetailItem(
                      title: e.name ?? 'Không có tên bài giảng',
                      type: e.time ?? 'video',
                    ),
                  ),
                )
                .toList(),
          ),
        if (isExpanded)
          Column(
            children: widget.topicModel!.documents!
                .map(
                  (e) => GestureDetector(
                    onTap: () async {
                      //open url
                      if (!await launchUrl(Uri.parse(e.url ?? ''))) {
                        throw Exception('Could not launch ');
                      }
                    },
                    child: DetailItem(
                      title: e.name ?? 'Không có tên bài giảng',
                      type: 'tài liệu',
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.title, required this.type});
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column(
        //   children: [
        //     Icon(Icons.check_circle, size: 12.r, color: mainGreen),
        //     Container(
        //       height: 32.h,
        //       width: 1.w,
        //       margin: EdgeInsets.symmetric(vertical: 8.h),
        //       decoration: const BoxDecoration(color: Colors.green),
        //     ),
        //   ],
        // ),
        Column(
          children: [
            SizedBox(height: 12.h),
            if (type == 'tài liệu')
              Icon(Icons.document_scanner_outlined)
            else
              SvgPicture.asset(
                'assets/icons/video.svg',
                width: 22.w,
                height: 22.h,
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              width: 280.w,
              child: Text(title, style: defaultText14M),
            ),
            SizedBox(
              width: 280.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    type == 'tài liệu' ? 'tài liệu' : 'Thời lượng $type',
                    style: defaultText12M.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.h,
              width: 267.w,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: const BoxDecoration(color: Color(0xffEDEDED)),
            ),
          ],
        ),
      ],
    );
  }
}
