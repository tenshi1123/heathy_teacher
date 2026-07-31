import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/repo/course_repo.dart';

class ListFreeCourse extends StatefulWidget {
  const ListFreeCourse({super.key});

  @override
  State<ListFreeCourse> createState() => _ListFreeCourseState();
}

class _ListFreeCourseState extends State<ListFreeCourse> {
  // Màu xanh lá logo
  static const Color secondaryGreen = Color(
    0xFF7CB342,
  ); // Màu xanh nút đăng nhập

  late int currentPage = 1;
  int itemsPerPage = 1000;
  bool isLoading = false;
  List<CourseModel> localListCourse = [];

  List<CourseScheduleModel> myCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchMyCourses();
    _loadPage(1);
  }

  Future<void> _fetchMyCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      try {
        final courses = await CourseRepo().getCourse(show: 100);
        if (mounted) {
          setState(() {
            myCourses = courses;
          });
        }
      } catch (e) {}
    }
  }

  Future<void> _loadPage(int page) async {
    int startIndex = (page - 1) * itemsPerPage;
    if (startIndex >= localListCourse.length) {
      setState(() {
        isLoading = true;
      });
      try {
        final newItems = await ExternalRepo().getListFreeCourse(
          page: page,
          show: 1000,
        );
        setState(() {
          localListCourse.addAll(newItems);
        });
      } catch (e) {
        // print('Lỗi: $e');
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  List<CourseModel> get currentItems {
    final filtered = localListCourse.where((course) {
      return !myCourses.any(
        (myCourse) => myCourse.settingCourseTypeId == course.courseTypeId,
      );
    }).toList();

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (startIndex >= filtered.length) return [];
    if (endIndex > filtered.length) endIndex = filtered.length;
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50), // Khoảng cách cho status bar

                  DefaultAppBar(),

                  // 2. SEARCH BAR AREA
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFC0CA33),
                          width: 1.5,
                        ),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập để tìm kiếm...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: secondaryGreen),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. SLIDE SHOW AREA (Phần bạn yêu cầu)
                  const CustomImageCarousel(),

                  //list
                  if (currentItems.isEmpty && !isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Không có khóa học nào.',
                        style: defaultText16B,
                      ),
                    )
                  else
                    Builder(
                      builder: (context) {
                        Map<String, List<CourseModel>> grouped = {};
                        for (var course in currentItems) {
                          String cat = course.categoryName ?? 'Khác';
                          if (!grouped.containsKey(cat)) grouped[cat] = [];
                          grouped[cat]!.add(course);
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: grouped.keys.length,
                          itemBuilder: (context, index) {
                            String cat = grouped.keys.elementAt(index);
                            return CategoryExpandableItem(
                              categoryName: cat,
                              courses: grouped[cat]!,
                            );
                          },
                        );
                      },
                    ),

                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: mainDarkGreen),
                    ),
                  Container(
                    height: 160.h,
                    width: 375.w,
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.only(left: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        colors: [mainDarkGreen, mainGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: mainDarkGreen, width: 1.w),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// TEXT (tự co lại)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 5.h),
                              Text(
                                'ƯU ĐÃI ĐẶC QUYỀN GIẢM ĐẾN 30%',
                                style: defaultText14B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'NGUYÊN LIỆU VÀ DỤNG CỤ CHO HỌC VIÊN',
                                style: defaultText14B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  'Nhận ưu đãi ngay',
                                  style: defaultText16B.copyWith(
                                    color: mainDarkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// IMAGE (giữ kích thước mong muốn)
                        SizedBox(
                          height: 140.h, // 👈 bạn control size ảnh ở đây
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cogiaohealthy.vn/wp-content/uploads/2025/07/cogiao.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomFooterInfo(),
                  // Khoảng cách cuối trang
                ],
              ),
            ),
          ),
          BottomCustom(),
        ],
      ),
    );
  }
}

Widget buildIcon(String iconPath, {double size = 28}) {
  if (iconPath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(iconPath, width: size, height: size);
  } else {
    return Image.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class PulseIcon extends StatefulWidget {
  final String iconPath;

  const PulseIcon({super.key, required this.iconPath});

  @override
  State<PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = _controller.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// vòng lan 1
              _buildWave(value),

              /// vòng lan 2 (trễ hơn chút cho đẹp)
              _buildWave((value + 0.5) % 1),

              /// nút chính
              child!,
            ],
          );
        },
        child: Transform.translate(
          offset: Offset(
            (sin(_controller.value * 2 * pi) * 2), // rung ngang nhẹ
            0,
          ),
          child: _buildMainButton(),
        ),
      ),
    );
  }

  Widget _buildWave(double value) {
    return Container(
      width: 50 + (value * 40), // 👈 nở ra
      height: 50 + (value * 40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mainDarkGreen.withOpacity(1 - value), // 👈 mờ dần
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(color: mainDarkGreen, shape: BoxShape.circle),
      child: Center(child: buildIcon(widget.iconPath, size: 18)),
    );
  }
}

class FreeCourseItem extends StatelessWidget {
  final CourseModel model;
  const FreeCourseItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: AspectRatio(
              aspectRatio: 483 / 397.76,
              child: CachedNetworkImage(
                imageUrl:
                    model.img ??
                    'https://lms.cogiaohealthy.vn/images/AVAMOI/B%E1%BA%A3n%20sao%20c%E1%BB%A7a%20%E1%BA%A2nh%20%C4%91%E1%BA%A1i%20di%E1%BB%87n%20kho%C3%A1%20h%E1%BB%8Dc%20tr%C3%AAn%20website%20%285%29.jpg',
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: mainDarkGreen, width: 1.5),
                  color: Colors.white,
                ),
                child: Text(
                  model.topicName ?? '',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            (model.courseName ?? 'Không xác định').sanitizeForApple,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: defaultText18B.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: mainDarkGreen,
                size: 16,
              ),
              Text(
                '  Cô giáo Healthy',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    Text(
                      '  ${model.lessonNumber} bài học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.yellow, size: 16),
                    Text(
                      '  ${int.parse(model.totalEnrollments ?? '0') + int.parse(model.startCount ?? '0')}lượt học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');
                if (!context.mounted) return;

                if (token != null && token.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterClassON(
                        id: model.courseTypeId ?? '',
                        isTrial: true,
                      ),
                    ),
                  );
                } else {
                  showLoginDialog(context);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.h),

                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: mainDarkGreen,
                ),
                child: Text(
                  'Học thử ngay',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryExpandableItem extends StatefulWidget {
  final String categoryName;
  final List<CourseModel> courses;

  const CategoryExpandableItem({
    super.key,
    required this.categoryName,
    required this.courses,
  });

  @override
  State<CategoryExpandableItem> createState() => _CategoryExpandableItemState();
}

class _CategoryExpandableItemState extends State<CategoryExpandableItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: mainDarkGreen,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.categoryName,
                    textAlign: TextAlign.center,
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...widget.courses.map((course) => FreeCourseItem(model: course)),
      ],
    );
  }
}
