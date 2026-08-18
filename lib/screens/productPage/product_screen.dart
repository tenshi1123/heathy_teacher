import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/repo/payment_repo.dart';
import 'package:heathy_teacher/screens/order/order_info_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.type, required this.userModel});
  final int type;
  final UserModel userModel;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  int currentPageProducts = 1;
  int currentPageCourses = 1;
  bool isLoading = true;
  List<ProductModel> products = [];
  List<ProductModel> courses = [];
  final int itemsPerPage = 5;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final result = await CourseRepo().getListProduct();
    products = result.$1;
    courses = result.$2;

    setState(() {
      isLoading = false;
    });
  }

  // H�m h? tr? format ti?n (VD: 399000 -> 399.000)
  String formatPrice(String? priceString) {
    if (priceString == null || priceString.isEmpty) return '0';
    try {
      final int price = int.parse(priceString);
      return NumberFormat.decimalPattern('vi').format(price);
    } catch (e) {
      return priceString; // N?u l?i parse th� tr? v? chu?i g?c
    }
  }

  Widget _buildTabContent(
    List<ProductModel> listData,
    int currentPage,
    ValueChanged<int> onPageChanged,
  ) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (endIndex > listData.length) {
      endIndex = listData.length;
    }

    List<ProductModel> displayedProducts = [];
    if (listData.isNotEmpty && startIndex < listData.length) {
      displayedProducts = listData.sublist(startIndex, endIndex);
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
          : Stack(
              children: [
                RefreshIndicator(
                  color: mainDarkGreen,
                  onRefresh: _fetchData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        listData.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.h),
                                  child: Text(
                                    'Chưa có dữ liệu.',
                                    style: defaultText14SB,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  bottom: 20.w,
                                ),
                                physics: const ClampingScrollPhysics(),
                                itemCount: displayedProducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final product = displayedProducts[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      if (product.orderId == null) return;
                                      try {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                        final orderInfo = await PaymentRepo()
                                            .getOrderInfo(
                                              int.tryParse(product.orderId!) ??
                                                  0,
                                            );
                                        Navigator.pop(context);
                                        if (orderInfo != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderInfoScreen(
                                                    orderResponse: orderInfo,
                                                  ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      width: 343.w,
                                      margin: EdgeInsets.only(bottom: 16.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xff062905,
                                            ).withValues(alpha: 0.16),
                                            spreadRadius: 0,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            child: CachedNetworkImage(memCacheWidth: 800, 
                                              imageUrl:
                                                  product.detail?[0].img ??
                                                  'https://lms.cogiaohealthy.vn/${product.img}',
                                              height: 90.h,
                                              width: 90.w,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) {
                                                    return Container(
                                                      height: 90.h,
                                                      width: 90.w,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 4.h),
                                                Text(
                                                  product.detail?[0].name ??
                                                      ' Không có data',
                                                  style: defaultText14SB,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8.h),
                                                if (isShow == 'true' &&
                                                    product.detail?[0].price !=
                                                        null)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${NumberFormat.decimalPattern('vi_VN').format(int.tryParse(product.detail?[0].price ?? '0'))} VNĐ',
                                                        style: defaultText16B
                                                            .copyWith(
                                                              color:
                                                                  mainDarkGreen,
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
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: PaginationWidget(
                      currentPage: currentPage,
                      totalPages: (listData.length / itemsPerPage).ceil() == 0
                          ? 1
                          : (listData.length / itemsPerPage).ceil(),
                      onPageChanged: onPageChanged,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      drawerEnableOpenDragGesture: false,
      drawer: MyCustomDrawer(userModel: widget.userModel, selectedIndex: 0),
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sản phẩm đã mua',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: widget.type == 1
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.yellow,
          tabs: const [
            Tab(text: 'Nguyên liệu - Máy móc'),
            Tab(text: 'Khóa học - Tài liệu tặng kèm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(products, currentPageProducts, (page) {
            setState(() {
              currentPageProducts = page;
            });
          }),
          _buildTabContent(courses, currentPageCourses, (page) {
            setState(() {
              currentPageCourses = page;
            });
          }),
        ],
      ),
    );
  }
}
