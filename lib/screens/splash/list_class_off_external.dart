import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heathy_teacher/repo/course_repo.dart';

class ListClassOffExternal extends StatefulWidget {
  final String? place;
  const ListClassOffExternal({super.key, this.place});

  @override
  State<ListClassOffExternal> createState() => _ListClassOffExternalState();
}

class _ListClassOffExternalState extends State<ListClassOffExternal> {
  late int currentPage = 1;
  int itemsPerPage = 100;
  bool isLoading = false;
  List<CourseOffModel> localListCourseOff = [];

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
    if (startIndex >= localListCourseOff.length) {
      setState(() {
        isLoading = true;
      });
      try {
        final newItems = await ExternalRepo().getListCourseOff(
          page: page,
          show: itemsPerPage,
          place: widget.place,
        );
        setState(() {
          localListCourseOff.addAll(newItems);
        });
      } catch (e) {
        print('Lỗi gọi danh sách khoá học offline: $e'.sanitizeForApple);
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  List<CourseOffModel> get currentItems {
    final filtered = localListCourseOff.where((course) {
      return !myCourses.any((myCourse) => myCourse.courseId == course.id);
    }).toList();

    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (startIndex >= filtered.length) return [];
    if (endIndex > filtered.length)
      endIndex = filtered.length;
    return filtered.sublist(startIndex, endIndex);
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  DefaultAppBar(),
                  const CustomImageCarousel(),

                  if (currentItems.isEmpty && !isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Không có khóa học nào tại khu vực này.',
                        style: defaultText16B,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 20.h,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        var model = currentItems[index];
                        return model.province == widget.place
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => RegisterClassOff(
                                        id: currentItems[index].id ?? '',
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
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: model.img ?? '',
                                          width: double.infinity,
                                          height: 180.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
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
                                        model.name ?? 'Không xác định',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: defaultText18B.copyWith(
                                          color: mainDarkGreen,
                                        ),
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
                                            '  ${model.dateStart?.replaceRange(10, null, '')} - ${model.dateEnd?.replaceRange(10, null, '')}',
                                            style: defaultText14M.copyWith(
                                              color: mainDarkGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: mainDarkGreen,
                                            size: 16,
                                          ),

                                          Text(
                                            '  Trực tiếp tại ${model.province}',
                                            style: defaultText14M.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: mainDarkGreen,
                                            size: 16,
                                          ),
                                          Text(
                                            '  Giảng viên ${model.lecturer}',
                                            style: defaultText14M.copyWith(
                                              color: mainDarkGreen,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      if (isShow == 'true') ...[
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Text(
                                              '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                                              style: defaultText18B.copyWith(
                                                color: mainDarkGreen,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            if (model.priceOld != '0')
                                              Text(
                                                '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '0') ?? 0)}đ',
                                                style: defaultText14M.copyWith(
                                                  color: mainDarkGreen,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                      SizedBox(height: 16.h),
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 60.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
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
                                            color: mainDarkGreen,
                                          ),
                                          child: Text(
                                            'Đăng ký ngay',
                                            style: defaultText16B.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox();
                      },
                    ),

                  // if (currentItems.isNotEmpty)
                  //   Container(
                  //     height: 76.h,
                  //     width: 375.w,
                  //     padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
                  //     decoration: const BoxDecoration(color: Colors.white),
                  //     child: PaginationWidget(
                  //       currentPage: currentPage,
                  //       totalPages: 6,
                  //       onPageChanged: (page) {
                  //         setState(() {
                  //           currentPage = page;
                  //         });
                  //         _loadPage(page);
                  //       },
                  //     ),
                  //   ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: mainDarkGreen),
                    ),
                  // FOOTER
                  const CustomFooterInfo(),
                ],
              ),
            ),
          ),
          const BottomCustom(),
        ],
      ),
    );
  }
}
