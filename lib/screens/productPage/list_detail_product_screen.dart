import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';

class ListDetailProductScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryName;
  const ListDetailProductScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  State<ListDetailProductScreen> createState() =>
      _ListDetailProductScreenState();
}

class _ListDetailProductScreenState extends State<ListDetailProductScreen> {
  bool isLoading = true;
  List<CategoryDetail> coursesDetail = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _show = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 500 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      _page = 1;
      _hasMore = true;
    });
    coursesDetail = await ProductRepo().getListProduct(
      widget.categorySlug,
      page: _page,
      show: _show,
    );
    if (coursesDetail.length < _show) {
      _hasMore = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    _page++;
    final moreCourses = await ProductRepo().getListProduct(
      widget.categorySlug,
      page: _page,
      show: _show,
    );
    if (moreCourses.length < _show) {
      _hasMore = false;
    }
    setState(() {
      coursesDetail.addAll(moreCourses);
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String selected = "Sản phẩm bán chạy"; // Màu chữ và giỏ hàng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryName,
          maxLines: 2,
          style: defaultText18B.copyWith(color: mainDarkGreen),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: mainDarkGreen),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartScreen(),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: globalListCart.lengthNotifier,
                    builder: (context, count, child) {
                      return Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: mainDarkGreen,
                  onRefresh: _fetchData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        // Row(
                        //   children: [
                        //     Text(
                        //       '    Sắp xếp theo: ',
                        //       style: defaultText14B.copyWith(color: colorText),
                        //     ),
                        //     FilterDropdownDialog(
                        //       options: const [
                        //         "Sản phẩm bán chạy",
                        //         "Giá tăng dần",
                        //         "Giá giảm dần",
                        //       ],
                        //       selected: selected,
                        //       onSelected: (value) {
                        //         setState(() {
                        //           selected = value; // 👈 update UI bên ngoài
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        //list
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: coursesDetail.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.6,
                              ),
                          itemBuilder: (context, index) {
                            final item = coursesDetail[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProductScreen(
                                      productId: item.id ?? '',
                                    ),
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
                                      child: CachedNetworkImage(memCacheWidth: 800, 
                                        imageUrl: item.img!.contains('https://')
                                            ? item.img ?? ''
                                            : 'https://lms.cogiaohealthy.vn/images/${item.img}',
                                        width: double.infinity,
                                        height: 120.dg,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: 50.dg,
                                            height: 50.dg,
                                            color: Colors
                                                .grey[200], // Màu nền của icon mặc định
                                            child: Icon(
                                              Icons
                                                  .error_outline, // Hoặc Icons.error_outline tuỳ ý bạn
                                              size: 30.dg,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        // (Tuỳ chọn) Hiển thị vòng xoay loading trong lúc đang tải ảnh
                                        placeholder: (context, url) {
                                          return Container(
                                            width: 80.w,
                                            height: 80.h,
                                            color: Colors.grey[100],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    Text(
                                      item.productName ?? 'Không xác định',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: defaultText16B.copyWith(
                                        color: mainDarkGreen,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${formatPrice(item.price)}đ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: defaultText16B.copyWith(
                                            color: mainDarkGreen,
                                          ),
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
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                      ],
                                    ),

                                    const Spacer(),

                                    /// BUTTON
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 4.h,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          int existingIndex = globalListCart
                                              .indexWhere(
                                                (element) =>
                                                    element.id == item.id,
                                              );
                                          if (existingIndex != -1) {
                                            globalListCart[existingIndex]
                                                .quantity++;
                                          } else {
                                            globalListCart.add(
                                              CartItem(
                                                id: item.id ?? '',
                                                name: item.productName ?? '',
                                                image: item.img ?? '',
                                                price:
                                                    int.tryParse(
                                                      item.price ?? '0',
                                                    ) ??
                                                    0,
                                                isCourse: false,
                                              ),
                                            );
                                          }
                                          setState(() {});
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                //title:  Text('Đã thêm vào giỏ hàng'),
                                                content: const Text(
                                                  'Sản phẩm đã được thêm vào giỏ hàng của bạn.',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          'OK',
                                                        ),
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Thêm vào giỏ hàng",
                                              style: defaultText12B.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoadingMore)
            Positioned(
              bottom: 80, // Hiện phía trên thanh BottomCustom
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(color: mainDarkGreen),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Widget nhỏ tùy chỉnh cho các nút dịch vụ tròn
class ServiceIconButton extends StatelessWidget {
  final String iconPath; // 👈 đổi sang path SVG
  final String title;

  const ServiceIconButton({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   height: 50,
        //   width: 50,
        //   decoration: BoxDecoration(
        //     color: mainDarkGreen,
        //     shape: BoxShape.circle,
        //   ),
        //   child: Center(
        //     //if icons is png, use Image.asset, if svg, use SvgPicture.asset
        //     child: buildIcon(iconPath, size: 28),
        //   ),
        // ),
        PulseIcon(iconPath: iconPath),
        const SizedBox(height: 8),
        Text(title),
      ],
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

Widget buildImage(String iconPath, {double size = 28}) {
  return Container(
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Image.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
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

String formatPrice(String? priceString) {
  if (priceString == null || priceString.isEmpty) return '0';
  try {
    final int price = int.parse(priceString);
    return NumberFormat.decimalPattern('vi').format(price);
  } catch (e) {
    return priceString; // Nếu lỗi parse thì trả về chuỗi gốc
  }
}
