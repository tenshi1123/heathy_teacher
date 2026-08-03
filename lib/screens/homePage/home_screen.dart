import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/homePage/schedule_screen.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.customerModel,
    this.onCourseTabRequested,
    this.onProductTabRequested,
  });
  final UserModel userModel;
  final CustomerModel customerModel;
  final VoidCallback? onCourseTabRequested;
  final VoidCallback? onProductTabRequested;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CourseScheduleModel> myCourses = [];
  List<CategoryModel> categoryList = [];

  UserModel get userModel => widget.userModel;
  CustomerModel get customerModel => widget.customerModel;
  VoidCallback? get onCourseTabRequested => widget.onCourseTabRequested;
  VoidCallback? get onProductTabRequested => widget.onProductTabRequested;

  @override
  void initState() {
    super.initState();
    _fetchMyCourses();
  }

  Future<void> _fetchMyCourses() async {
    try {
      final courses = await CourseRepo().getCourse();
      final fetchedCategories = await ProductRepo().getCategory(
        page: 1,
        show: 6,
      );
      setState(() {
        myCourses = courses;
        categoryList = fetchedCategories;
      });
    } catch (e) {
      print('Lỗi lấy khoá học của tôi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyCustomDrawer(userModel: userModel, selectedIndex: 0),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: mainDarkGreen,
        onRefresh: () async {
          try {
            await _fetchMyCourses();
            final futureCourse = await ExternalRepo().getListCourse(show: 6);
            final futureFreeCourse = await ExternalRepo().getListFreeCourse(
              show: 6,
            );
            final futureCourseOff = await ExternalRepo().getListCourseOff(
              show: 6,
            );
            setState(() {
              globalListCourse = futureCourse;
              globalListFreeCourse = futureFreeCourse;
              globalListCourseOff = futureCourseOff;
            });
          } catch (e) {
            print('Lỗi làm mới: $e');
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: 375.w,
                height: 296.w,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/home_background2.png',
                      width: 375.w,
                      height: 296.w,
                      fit: BoxFit.cover,
                    ),

                    Positioned(
                      top: 72.w,
                      left: 16.w,
                      child: SizedBox(
                        width: 343.w,
                        //height: 52.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.arrow_back_ios_new,
                                //     size: 32,
                                //     color: Colors.white,
                                //   ), // Nút 3 gạch tự tạo
                                //   onPressed: () {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             const CoGiaoHealthyScreen(
                                //               type: 'home',
                                //               place: 'Hà Nội',
                                //             ),
                                //       ),
                                //     );
                                //   },
                                // ),
                                Builder(
                                  builder: (BuildContext context) {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 32,
                                        color: Colors.white,
                                      ), // Nút 3 gạch tự tạo
                                      onPressed: () {
                                        // Gọi lệnh mở Drawer
                                        Scaffold.of(context).openDrawer();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             const CoGiaoHealthyScreen(
                                //               type: 'home',
                                //               place: 'Hà Nội',
                                //             ),
                                //       ),
                                //     );
                                //   },
                                //   child: Image.asset(
                                //     "assets/images/logo.png",
                                //     height: 73.h,
                                //     fit: BoxFit.fitHeight,
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    avatar(userModel.img),
                                    SizedBox(width: 16.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hi, ${userModel.fullName}',
                                          style: defaultText18B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        //dateTimeDisplayWidget(),
                                        SelectableText.rich(
                                          TextSpan(
                                            style: defaultText14M.copyWith(
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(text: 'Mã giới thiệu: '),
                                              TextSpan(
                                                text: userModel.phone,
                                                style: defaultText14B.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        NotificationScreen()),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/bell.svg',
                                width: 20.w,
                                height: 20.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 97.w,
                      right: 40.w,
                      child: InkWell(
                        onTap: onCourseTabRequested,
                        child: SizedBox(
                          width: 343.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                customerModel.course.toString(),
                                style: defaultText16B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48.w,
                      right: 40.w,
                      child: InkWell(
                        onTap: onProductTabRequested,
                        child: SizedBox(
                          width: 343.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                customerModel.product.toString(),
                                style: defaultText16B.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 20.w,
                    //   right: 40.w,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((context) => HocPhiScreen()),
                    //         ),
                    //       );
                    //     },
                    //     child: Text(
                    //       '${NumberFormat.decimalPattern('vi_VN').format(customerModel.paymentHistory)} VNĐ',

                    //       style: defaultText18B,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => CalenderScreen())),
                  );
                },
                child: Container(
                  height: 64.h,
                  width: 343.w,
                  decoration: BoxDecoration(
                    color: mainDarkGreen,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset(
                        'assets/images/schedule.png',
                        height: 40.h,
                        width: 40.w,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Lịch học lớp trực tiếp',
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 30.r,
                      ),
                      SizedBox(width: 22.w),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              const HomeSaleSection(),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSaleSection extends StatefulWidget {
  const HomeSaleSection({super.key});

  @override
  State<HomeSaleSection> createState() => _HomeSaleSectionState();
}

class _HomeSaleSectionState extends State<HomeSaleSection> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                        child: Icon(Icons.chevron_left, color: Colors.white),
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
                        child: Icon(Icons.chevron_right, color: Colors.white),
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
                child: Text('Chưa có ưu đãi nào', style: defaultText16M),
              ),
            ),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildCourseItem(CourseModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RegisterClassON(id: model.courseTypeId ?? '', model: model),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                    style: defaultText18B.copyWith(color: Colors.red),
                  ),
                  if (model.priceOld != null &&
                      model.priceOld != '0' &&
                      model.priceOld != '')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '0') ?? 0)}đ',
                      style: defaultText14M.copyWith(
                        fontSize: 10.sp,
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
                  if (item.priceOld != null &&
                      item.priceOld != '0' &&
                      item.priceOld != '')
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.priceOld ?? '0') ?? 0)}đ',
                      style: defaultText12Re.copyWith(
                        fontSize: 10.sp,
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
