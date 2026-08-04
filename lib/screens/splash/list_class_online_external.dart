import 'package:heathy_teacher/screens/coursePage/course_screen.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/coursePage/online_class_screen.dart';

class ListClassOnlineExternal extends StatefulWidget {
  final String? category;
  const ListClassOnlineExternal({super.key, this.category});

  @override
  State<ListClassOnlineExternal> createState() =>
      _ListClassOnlineExternalState();
}

class _ListClassOnlineExternalState extends State<ListClassOnlineExternal> {
  List<CourseScheduleModel> myCourses = [];
  UserModel? userModel;
  bool _isLoadingMyCourses = true;

  final List<String> categories = const [
    "Khoá học nấu ăn Eatclean - Healthy - Vegan",
    "Khoá học Đồ uống Healthy",
    "Khoá học Bánh Kẹo Healthy",
    "Khoá học Đồ ăn vặt - Tráng miệng Healthy",
    "Khóa học Dưỡng sinh - Thảo mộc",
    "Cộng đồng học viên VIP Cô Giáo Healthy",
    "Combo mô hình kinh doanh Healthy hot trend",
  ];

  @override
  void initState() {
    super.initState();
    _fetchMyCourses();
  }

  Future<void> _fetchMyCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      try {
        final courses = await CourseRepo().getCourse(show: 100);
        final profile = await HomeRepo().getUserProfile();
        if (mounted) {
          setState(() {
            myCourses = courses;
            userModel = profile;
            _isLoadingMyCourses = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoadingMyCourses = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingMyCourses = false;
        });
      }
    }
  }

  Widget buildImage(String imagePath, {double size = 28}) {
    if (imagePath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(imagePath, width: size, height: size);
    } else {
      return Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: mainDarkGreen,
              onRefresh: () async {
                await _fetchMyCourses();
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    DefaultAppBar(),
                    const CustomImageCarousel(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'DANH SÁCH KHÓA HỌC ONLINE',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryExpandableOnlineItem(
                          categoryName: categories[index],
                          myCourses: myCourses,
                          isLoadingMyCourses: _isLoadingMyCourses,
                          userModel: userModel,
                          initiallyExpanded:
                              widget.category != null &&
                              categories[index].toLowerCase() ==
                                  widget.category!.toLowerCase(),
                        );
                      },
                    ),
                    // FOOTER
                    const CustomFooterInfo(),
                  ],
                ),
              ),
            ),
          ),
          const BottomCustom(),
        ],
      ),
    );
  }
}

class CategoryExpandableOnlineItem extends StatefulWidget {
  final String categoryName;
  final List<CourseScheduleModel> myCourses;
  final bool isLoadingMyCourses;
  final bool initiallyExpanded;
  final UserModel? userModel;

  const CategoryExpandableOnlineItem({
    super.key,
    required this.categoryName,
    required this.myCourses,
    required this.isLoadingMyCourses,
    this.userModel,
    this.initiallyExpanded = false,
  });

  @override
  State<CategoryExpandableOnlineItem> createState() =>
      _CategoryExpandableOnlineItemState();
}

class _CategoryExpandableOnlineItemState
    extends State<CategoryExpandableOnlineItem> {
  late bool isExpanded;
  bool isLoading = false;
  List<CourseModel> courses = [];
  bool hasFetched = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
    if (isExpanded) {
      fetchCourses();
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      isLoading = true;
    });
    try {
      final newItems = await ExternalRepo().getListCourse(
        page: 1,
        show: 100,
        query: widget.categoryName,
        type: 'online',
      );
      if (mounted) {
        setState(() {
          courses = newItems;
          hasFetched = true;
        });
      }
    } catch (e) {
      print(
        'Lỗi gọi danh sách khoá học online: ${e.toString().sanitizeForApple}',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
            if (isExpanded && !hasFetched) {
              fetchCourses();
            }
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
        if (isExpanded && isLoading)
          Padding(
            padding: const EdgeInsets.all(20),
            child: CircularProgressIndicator(color: mainDarkGreen),
          ),
        if (isExpanded && !isLoading && courses.isEmpty && hasFetched)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Không có khóa học nào.', style: defaultText16B),
          ),
        if (isExpanded && !isLoading && courses.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                var model = courses[index];
                bool isBought = false;
                CourseScheduleModel? boughtCourse;
                try {
                  boughtCourse = widget.myCourses.firstWhere(
                    (c) => c.courseTypeId == model.courseTypeId,
                  );
                  isBought = true;
                } catch (e) {
                  isBought = false;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => RegisterClassON(
                          id: model.courseTypeId ?? '',
                          model: model,
                        )),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
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
                              imageUrl: model.img ?? '',
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: mainDarkGreen,
                                  width: 1.5,
                                ),
                                color: Colors.white,
                              ),
                              child: Text(
                                model.topicName ?? '',
                                style: defaultText14M.copyWith(
                                  color: mainDarkGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          model.courseName ?? 'Không xác định',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: mainDarkGreen,
                              size: 20.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Học Online qua App',
                              style: defaultText14M.copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                        if (isShow == 'true') ...[
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                                    style: defaultText18B.copyWith(
                                      color: mainDarkGreen,
                                    ),
                                  ),
                                  if (model.priceOld != null &&
                                      model.priceOld != '0' &&
                                      model.priceOld != '')
                                    Text(
                                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '0') ?? 0)}đ',
                                      style: defaultText14M.copyWith(
                                        color: mainDarkGreen,
                                        fontSize: 10.sp,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: mainDarkGreen.withValues(alpha: 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                  Text(
                                    '  ${model.lessonNumber} bài học',
                                    style: defaultText12M.copyWith(
                                      color: mainDarkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isShow == 'true')
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mainDarkGreen.withValues(
                                        alpha: 0.1,
                                      ),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.yellow,
                                      size: 16,
                                    ),
                                    Text(
                                      '  ${int.parse(model.totalEnrollments ?? '0') + int.parse(model.startCount ?? '0')} lượt học',
                                      style: defaultText12M.copyWith(
                                        color: mainDarkGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            if (isBought && boughtCourse != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => CourseScreen(
                                    userModel: widget.userModel ?? UserModel(),
                                  )),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => RegisterClassON(
                                    id: model.courseTypeId ?? '',
                                    model: model,
                                  )),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 80.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: mainDarkGreen.withValues(alpha: 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: isBought
                                    ? const Color(0xFFF26522)
                                    : mainDarkGreen,
                              ),
                              child: Text(
                                isBought ? 'Học ngay' : 'Đăng ký ngay',
                                style: defaultText16B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
