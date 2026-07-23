import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  bool isLoading = true;
  List<CourseModel> saleCourses = [];
  List<CategoryDetail> saleProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final futures = await Future.wait([
        ExternalRepo().getListCourse(page: 1, show: 10),
        ProductRepo().getListProduct('uu-dai-khuyen-mai', page: 1, show: 10),
      ]);
      setState(() {
        saleCourses = futures[0] as List<CourseModel>;
        saleProducts = futures[1] as List<CategoryDetail>;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  DefaultAppBar(),

                  if (isLoading)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(color: mainDarkGreen),
                      ),
                    )
                  else ...[
                    // Khóa học online
                    if (saleCourses.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          'Khóa học ưu đãi',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: saleCourses.length,
                        itemBuilder: (context, index) {
                          return _buildCourseItem(saleCourses[index]);
                        },
                      ),
                    ],

                    // Sản phẩm
                    if (saleProducts.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          'Sản phẩm ưu đãi',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: saleProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                        itemBuilder: (context, index) {
                          return _buildProductItem(saleProducts[index]);
                        },
                      ),
                    ],

                    if (saleCourses.isEmpty && saleProducts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Chưa có ưu đãi nào',
                            style: defaultText16M,
                          ),
                        ),
                      ),
                  ],

                  SizedBox(height: 20.h),
                  BottomCustom(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(CourseModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterClassON(id: model.courseTypeId ?? ''),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
            child: CachedNetworkImage(
              imageUrl: (model.img != null && model.img!.contains('https://'))
                  ? model.img!
                  : (model.img != null ? 'https://lms.cogiaohealthy.vn/${model.img}' : ''),
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.h),
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
                  'Khóa học online',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
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
                Icons.calendar_month_outlined,
                color: mainDarkGreen,
                size: 16,
              ),
              Text(
                '  Cô giáo Healthy',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
              const Spacer(),
              RatingStars(rating: 4.6, starSize: 16.r),
              Text(' (4,6)', style: defaultText14SB.copyWith(fontSize: 12.sp)),
            ],
          ),
          if (isShow == 'true') ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                  style: defaultText18B.copyWith(color: Colors.red),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '0') ?? 0)}đ',
                  style: defaultText14M.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
              if (isShow == 'true')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                        Icons.person_outline,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      Text(
                        '  ${model.totalEnrollments} lượt học',
                        style: defaultText12M.copyWith(color: mainDarkGreen),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 10.h),
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
                color: mainDarkGreen,
              ),
              child: Text(
                'Xem chi tiết',
                style: defaultText16B.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
      ),
    );
  }

  Widget _buildProductItem(CategoryDetail item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: (item.img != null && item.img!.contains('https://'))
                  ? item.img!
                  : 'https://lms.cogiaohealthy.vn/images/${item.img}',
              width: double.infinity,
              height: 120.dg,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: defaultText14B,
                ),
                SizedBox(height: 4.h),
                if (isShow == 'true')
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.price ?? '0') ?? 0)}đ',
                    style: defaultText14B.copyWith(color: mainDarkGreen),
                  ),
                SizedBox(height: 4.h),
                if (isShow == 'true')
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.priceOld ?? '0') ?? 0)}đ',
                    style: defaultText12Re.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
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
