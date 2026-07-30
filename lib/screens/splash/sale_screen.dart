import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
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

  final ScrollController _productScrollController = ScrollController();
  final ScrollController _courseScrollController = ScrollController();

  void _scrollCourses(bool forward) {
    if (!_courseScrollController.hasClients) return;
    final double currentPosition = _courseScrollController.position.pixels;
    final double scrollAmount = 300.w;
    if (forward) {
      _courseScrollController.animateTo(
        currentPosition + scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _courseScrollController.animateTo(
        currentPosition - scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollProducts(bool forward) {
    if (!_productScrollController.hasClients) return;
    final double currentPosition = _productScrollController.position.pixels;
    final double scrollAmount = 200.w;
    if (forward) {
      _productScrollController.animateTo(
        currentPosition + scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _productScrollController.animateTo(
        currentPosition - scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _courseScrollController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final futures = await Future.wait([
        ExternalRepo().getListCourse(
          page: 1,
          show: 20,
          offerMonth: 1,
          type: 'online',
        ),
        ProductRepo().getListProduct('uu-dai-khuyen-mai', page: 1, show: 1000),
      ]);
      setState(() {
        final List<CourseModel> courses = futures[0] as List<CourseModel>;
        final List<CategoryDetail> products =
            futures[1] as List<CategoryDetail>;

        saleCourses = courses.where((element) {
          final priceOld = element.priceOld ?? '0';
          final price = element.price ?? '0';
          return priceOld != '0' && priceOld != price;
        }).toList();

        saleProducts = products.where((element) {
          final priceOld = element.priceOld ?? '0';
          final price = element.price ?? '0';
          return priceOld != '0' && priceOld != price;
        }).toList();

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
                    if (saleCourses.isNotEmpty && isShow == 'true') ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          'ƯU ĐÃI KHÓA HỌC',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                      SizedBox(
                        height: 550.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ListView.builder(
                              controller: _courseScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              itemCount: saleCourses.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 320.w,
                                  child: _buildCourseItem(saleCourses[index]),
                                );
                              },
                            ),
                            Positioned(
                              left: 8.w,
                              child: GestureDetector(
                                onTap: () => _scrollCourses(false),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8.w,
                              child: GestureDetector(
                                onTap: () => _scrollCourses(true),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          'ƯU ĐÃI NGUYÊN LIỆU - MÁY MÓC',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                      SizedBox(
                        height: 380.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ListView.builder(
                              controller: _productScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              itemCount: saleProducts.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 170.w,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 8.h,
                                  ),
                                  child: _buildProductItem(saleProducts[index]),
                                );
                              },
                            ),
                            Positioned(
                              left: 8.w,
                              child: GestureDetector(
                                onTap: () => _scrollProducts(false),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8.w,
                              child: GestureDetector(
                                onTap: () => _scrollProducts(true),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  CustomFooterInfo(),

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
              child: AspectRatio(
                aspectRatio: 483 / 397.76,
                child: CachedNetworkImage(
                  imageUrl: (model.img != null && model.img!.startsWith('http'))
                      ? model.img!
                      : (model.img != null && model.img!.isNotEmpty
                            ? 'https://lms.cogiaohealthy.vn/${model.img!.startsWith('/') ? model.img!.substring(1) : model.img}'
                            : ''),
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
              ],
            ),
            ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                    style: defaultText18B.copyWith(color: Colors.red),
                  ),
                  SizedBox(width: 12.w),
                  if (model.priceOld != '0')
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
                        '  ${int.parse(model.totalEnrollments ?? '0') + int.parse(model.startCount ?? '0')} lượt học',
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
                  'Đăng ký',
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
            builder: (context) => DetailProductScreen(productId: item.id ?? ''),
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
                imageUrl: (item.img != null && item.img!.startsWith('http'))
                    ? item.img!
                    : (item.img != null && item.img!.isNotEmpty
                          ? 'https://lms.cogiaohealthy.vn/${item.img!.startsWith('/') || item.img!.startsWith('images') ? (item.img!.startsWith('/') ? item.img!.substring(1) : item.img) : 'images/${item.img}'}'
                          : ''),
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: defaultText14B,
                  ),
                  SizedBox(height: 4.h),

                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.price ?? '0') ?? 0)}đ',
                    style: defaultText14B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 2.h),
                  if (item.priceOld != '0')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.priceOld ?? '0') ?? 0)}đ',
                      style: defaultText12Re.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color:
                          item.inventoryQuantity == '0' &&
                              item.allowShortSelling == '0'
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF388E3C),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.inventoryQuantity == '0' &&
                              item.allowShortSelling == '0'
                          ? 'Hết hàng'
                          : 'Thêm vào giỏ hàng',
                      style: defaultText14M.copyWith(color: Colors.white),
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
