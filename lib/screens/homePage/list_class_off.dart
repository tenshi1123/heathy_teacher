import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListClassOff extends StatefulWidget {
  final String? place;
  const ListClassOff({super.key, this.place});

  @override
  State<ListClassOff> createState() => _ListClassOffState();
}

class _ListClassOffState extends State<ListClassOff> {
  late int currentPage = 1;
  int itemsPerPage = 6;
  bool isLoading = false;
  List<CourseOffModel> localListCourseOff = [];

  @override
  void initState() {
    super.initState();
    _loadPage(1);
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
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (startIndex >= localListCourseOff.length) return [];
    if (endIndex > localListCourseOff.length) endIndex = localListCourseOff.length;
    return localListCourseOff.sublist(startIndex, endIndex);
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
          'Danh sách lớp trực tiếp',
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
                        builder: ((context) => RegisterClassOff(
                          id: currentItems[index].id ?? '',
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
                    child: Row(
                      children: [
                        CachedNetworkImage(
  imageUrl: model.img ?? '',
                          height: 90.h,
                          width: 90.w,
                          fit: BoxFit.fill,
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
                                model.name ?? 'Không xác định',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                        decoration: TextDecoration.lineThrough,
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
