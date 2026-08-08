import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CourseModel> _onlineCourses = [];
  bool _isLoadingOnline = true;

  List<CourseModel> _offlineCourses = [];
  bool _isLoadingOffline = true;

  List<CategoryDetail> _products = [];
  bool _isLoadingProducts = true;

  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _searchController.text = _currentQuery;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoadingOnline = true;
      _isLoadingOffline = true;
    });

    try {
      final courses = await ExternalRepo().getListCourse(
        query: _currentQuery,
        show: 20,
        type: 'online',
      );
      if (mounted) {
        setState(() {
          _onlineCourses = courses;
          _isLoadingOnline = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOnline = false;
        });
      }
    }

    try {
      final offCourses = await ExternalRepo().getListCourse(
        query: _currentQuery,
        show: 20,
        type: 'off',
      );
      if (mounted) {
        setState(() {
          _offlineCourses = offCourses;
          _isLoadingOffline = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOffline = false;
        });
      }
    }

    try {
      final products = await ProductRepo().getListProduct(
        "",
        query: _currentQuery,
        show: 20,
      );
      if (mounted) {
        setState(() {
          _products = products;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const DefaultAppBar(),

                  // Search Bar
                  CustomSearchBar(
                    controller: _searchController,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          _currentQuery = value.trim();
                        });
                        _fetchData();
                      }
                    },
                  ),

                  // Breadcrumb
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Text('Trang chủ', style: defaultText14B),
                        const Icon(Icons.chevron_right, color: Colors.black54),
                        Text(
                          'Kết quả tìm kiếm',
                          style: defaultText14Re.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // KHÓA HỌC ONLINE SECTION
                  SizedBox(height: 16.h),
                  Text(
                    'KHÓA HỌC ONLINE',
                    style: defaultText18B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 8.h),
                  if (_isLoadingOnline)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    )
                  else if (_onlineCourses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Không tìm thấy khóa học online nào.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _onlineCourses.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: _buildOnlineClassCard(_onlineCourses[index]),
                        );
                      },
                    ),

                  // KHÓA HỌC TRỰC TIẾP SECTION
                  SizedBox(height: 24.h),
                  Text(
                    'KHÓA HỌC TRỰC TIẾP',
                    style: defaultText18B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 8.h),
                  if (_isLoadingOffline)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    )
                  else if (_offlineCourses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Không tìm thấy khóa học trực tiếp nào.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _offlineCourses.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: _buildOfflineClassCard(_offlineCourses[index]),
                        );
                      },
                    ),

                  // NGUYÊN LIỆU - MÁY MÓC SECTION
                  SizedBox(height: 24.h),
                  Text(
                    'NGUYÊN LIỆU - MÁY MÓC',
                    style: defaultText18B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 16.h),
                  if (_isLoadingProducts)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    )
                  else if (_products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Không tìm thấy nguyên liệu - máy móc nào.'),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        itemCount: _products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) {
                          return _buildProductCard(_products[index]);
                        },
                      ),
                    ),

                  SizedBox(height: 30.h),
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

  Widget _buildOnlineClassCard(CourseModel model) {
    bool isBought = false;
    String isShow = 'true'; // Default to true as in external page

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                RegisterClassON(id: model.courseTypeId ?? '', model: model)),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
                        style: defaultText18B.copyWith(color: mainDarkGreen),
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
            GestureDetector(
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
                    color: mainDarkGreen,
                  ),
                  child: Text(
                    'Đăng ký ngay',
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineClassCard(CourseModel courseModel) {
    CourseOffModel model = CourseOffModel(
      id: courseModel.courseTypeId ?? courseModel.courseId,
      name: courseModel.courseName,
      topicName: courseModel.topicName,
      img: courseModel.img,
      price: courseModel.price,
      priceOld: courseModel.priceOld,
      lecturer: courseModel.lecturerName,
      startCount: courseModel.startCount,
      totalEnrollments: courseModel.totalEnrollments,
      province: '',
    );
    String isShow = 'true';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                RegisterClassOff(id: model.id ?? '', model: model)),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
                  imageUrl: model.img ?? '',
                  width: double.infinity,
                  height: 280.h,
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
              model.name ?? 'Không xác định',
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
                  '  ${model.dateStart != null ? DateFormat('dd/MM/yyyy').format(DateTime.tryParse(model.dateStart!) ?? DateTime.now()) : ""} - ${model.dateEnd != null ? DateFormat('dd/MM/yyyy').format(DateTime.tryParse(model.dateEnd!) ?? DateTime.now()) : ""}',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
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
                  style: defaultText14M.copyWith(color: Colors.red),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.person_outline, color: mainDarkGreen, size: 16),
                Text(
                  '  Giảng viên ${model.lecturer}',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
            if (isShow == 'true') ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.price ?? '0') ?? 0)}đ',
                        style: defaultText18B.copyWith(color: mainDarkGreen),
                      ),
                      SizedBox(width: 12.w),
                      if (model.priceOld != '0')
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(model.priceOld ?? '0') ?? 0)}đ',
                          style: defaultText12B.copyWith(
                            color: mainDarkGreen,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => RegisterClassOff(
                            id: model.id ?? '',
                            model: model,
                          )),
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
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
                          color: mainDarkGreen,
                        ),
                        child: Text(
                          'Đăng ký ngay',
                          style: defaultText16B.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  String formatPrice(String? priceString) {
    if (priceString == null || priceString.isEmpty) {
      return '0';
    }

    try {
      int price = int.parse(priceString.replaceAll(RegExp(r'[^0-9]'), ''));
      final formatter = NumberFormat('#,###', 'vi_VN');
      return formatter.format(price);
    } catch (e) {
      return '0';
    }
  }

  Widget _buildProductCard(CategoryDetail item) {
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
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
                bottom: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: (item.img != null && item.img!.contains('https://'))
                    ? item.img ?? ''
                    : 'https://lms.cogiaohealthy.vn/images/${item.img}',
                width: double.infinity,
                height: 120.dg,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    width: 50.dg,
                    height: 50.dg,
                    color: Colors.grey[200], // Màu nền của icon mặc định
                    child: Icon(
                      Icons.error_outline, // Hoặc Icons.error_outline tuỳ ý bạn
                      size: 30.dg,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Text(
              item.productName ?? 'Không xác định',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: defaultText16B.copyWith(color: mainDarkGreen),
            ),
            SizedBox(height: 8.h),
            Text(
              '${formatPrice(item.price)}đ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: defaultText16B.copyWith(color: mainDarkGreen),
            ),
            if (item.priceOld != null &&
                item.priceOld != '0' &&
                item.priceOld != '')
              Text(
                '${formatPrice(item.priceOld)}đ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: defaultText12M.copyWith(
                  color: Colors.grey,
                  fontSize: 10.sp,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const Spacer(),

            /// BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
              child: GestureDetector(
                onTap: () {
                  int existingIndex = globalListCart.indexWhere(
                    (element) => element.id == item.id,
                  );
                  if (existingIndex != -1) {
                    globalListCart[existingIndex].quantity++;
                  } else {
                    globalListCart.add(
                      CartItem(
                        id: item.id ?? '',
                        name: item.productName ?? '',
                        image: item.img ?? '',
                        price: int.tryParse(item.price ?? '0') ?? 0,
                        isCourse: false,
                      ),
                    );
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text(
                          'Sản phẩm đã được thêm vào giỏ hàng của bạn.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: mainDarkGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Thêm vào giỏ hàng",
                      style: defaultText12B.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
