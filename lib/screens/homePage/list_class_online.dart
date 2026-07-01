import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';

class ListClassOnline extends StatefulWidget {
  const ListClassOnline({super.key});

  @override
  State<ListClassOnline> createState() => _ListClassOnlineState();
}

class _ListClassOnlineState extends State<ListClassOnline> {
  late int currentPage = 1;
  int itemsPerPage = 6;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadPage(int page) async {
    int startIndex = (page - 1) * itemsPerPage;
    if (startIndex >= globalListCourse.length) {
      setState(() {
        isLoading = true;
      });
      try {
        final newItems = await ExternalRepo().getListCourse(page: page, show: itemsPerPage);
        setState(() {
          globalListCourse.addAll(newItems);
        });
      } catch (e) {
        print('Lỗi gọi danh sách khoá học online: $e');
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
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (startIndex >= globalListCourse.length) return [];
    if (endIndex > globalListCourse.length) endIndex = globalListCourse.length;
    return globalListCourse.sublist(startIndex, endIndex);
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
          'Danh sách khoá online',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          SvgPicture.asset(
            'assets/icons/bell.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Stack(
          children: [
            Stack(
              children: [
                ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              physics: const ClampingScrollPhysics(),
              itemCount: currentItems.length,
              itemBuilder: (BuildContext context, int index) {
                var model = currentItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => RegisterClassON(
                          id: currentItems[index].courseTypeId ?? '',
                        )),
                      ),
                    );
                  },
                  child: Container(
                    width: 343.w,
                    //height: 106.h,
                    margin: EdgeInsets.only(bottom: index == 5 ? 80 : 16.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff062905).withValues(alpha: 0.16),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(
                            0,
                            4,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 90.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    model.img ??
                                        'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg',
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            SizedBox(
                              width: 217.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      RatingStars(
                                        rating: 4.6, // Hiển thị 4.5 sao
                                        starSize: 16.r,
                                      ),
                                      Text(
                                        '(4,6)',
                                        style: defaultText14SB.copyWith(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    model.courseName ?? 'Không xác định',
                                    style: defaultText14SB,
                                  ),
                                  if (isShow == 'true')
                                    Row(
                                      children: [
                                        Text(
                                          '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? ''))}đ',
                                          style: defaultText16B,
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? ''))}đ',
                                          style: defaultText12Re.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 32.h,
                              width: 156.w,
                              decoration: BoxDecoration(
                                color: Color(0xffE8F8EA),
                                border: Border.all(
                                  color: Color(
                                    0xff407B37,
                                  ).withValues(alpha: 0.04),
                                ),

                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8.w),
                                  Image.asset(
                                    'assets/images/play_icon.png',
                                    height: 16.h,
                                    width: 16.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${model.lessonNumber} bài học',
                                    style: defaultText14SB.copyWith(
                                      color: mainDarkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 32.h,
                              width: 156.w,
                              decoration: BoxDecoration(
                                color: Color(0xffE8F8EA),
                                border: Border.all(
                                  color: Color(
                                    0xff407B37,
                                  ).withValues(alpha: 0.04),
                                ),

                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8.w),
                                  Image.asset(
                                    'assets/images/play_icon.png',
                                    height: 16.h,
                                    width: 16.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${model.totalEnrollments} lượt đã học',
                                    style: defaultText14SB.copyWith(
                                      color: mainDarkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.5),
                  child: Center(
                    child: CircularProgressIndicator(color: mainDarkGreen),
                  ),
                ),
              ),
          ],
        ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 76.h,
                width: 375.w,
                padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
                decoration: BoxDecoration(color: Colors.white),
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalPages: 6,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                    _loadPage(page);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
