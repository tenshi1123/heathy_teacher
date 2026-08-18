import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:heathy_teacher/screens/productPage/list_detail_product_screen.dart';
import 'package:heathy_teacher/screens/productPage/product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  bool isLoading = true;
  List<CategoryModel> courses = [];
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
    courses = await ProductRepo().getCategory(page: _page, show: _show);
    if (courses.length < _show) {
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
    final moreCourses = await ProductRepo().getCategory(
      page: _page,
      show: _show,
    );
    if (moreCourses.length < _show) {
      _hasMore = false;
    }
    setState(() {
      courses.addAll(moreCourses);
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      drawer: MyCustomDrawer(userModel: widget.userModel, selectedIndex: 0),
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Gian hàng',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // Icon 3 gạch
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Lệnh gọi Drawer trượt ra
              },
            );
          },
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) =>
        //               ProductScreen(type: 2, userModel: widget.userModel),
        //         ),
        //       );
        //     },
        //     child: Text(
        //       'Đã mua',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 14.sp,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ],

        // actions: [
        //   Builder(
        //     buildColor.fromARGB(255, 43, 27, 27)ntext innerContext) {
        //       return GestureDetector(
        //         onTap: () {
        //           Scaffold.of(innerContext).openEndDrawer();
        //         },
        //         child: SvgPicture.asset(
        //           'assets/icons/menu_icon.svg',
        //           width: 20.w,
        //           height: 20.h,
        //           colorFilter: const ColorFilter.mode(
        //             Colors.white,
        //             BlendMode.srcIn,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        //   SizedBox(width: 16.w),
        // ],
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
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: courses.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.6,
                              ),
                          itemBuilder: (context, index) {
                            final item = courses[index];

                            return Container(
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
                                      imageUrl: item.img ?? '',
                                      height: 160.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          width: 50.dg,
                                          height: 50.dg,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.error_outline,
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
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 8.w,
                                      right: 8.w,
                                      top: 8.h,
                                    ),
                                    child: Text(
                                      item.categoryName ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: defaultText16B.copyWith(
                                        color: mainDarkGreen,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  /// BUTTON
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                ListDetailProductScreen(
                                                  categorySlug:
                                                      item.categorySlug ?? '',
                                                  categoryName:
                                                      item.categoryName ?? '',
                                                )),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: mainDarkGreen,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Xem tất cả",
                                            style: defaultText14B.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Khoảng cách cuối trang
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
