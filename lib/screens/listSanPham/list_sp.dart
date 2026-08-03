import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/listSanPham/list_detail_sp.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListSpScreen extends StatefulWidget {
  const ListSpScreen({super.key});

  @override
  State<ListSpScreen> createState() => _ListSpScreenState();
}

class _ListSpScreenState extends State<ListSpScreen> {
  bool isLoading = true;
  List<CategoryModel> courses = [];
  final ScrollController _scrollController = ScrollController();
  final int _show = 100;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    courses = await ProductRepo().getCategory(page: 1, show: _show);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const Color secondaryGreen = Color(0xFF7CB342);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        const SizedBox(height: 50),
                        DefaultAppBar(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFC0CA33),
                                width: 1.5,
                              ),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Nhập để tìm kiếm...',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: secondaryGreen,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 4. SLIDE SHOW AREA (Phần bạn yêu cầu)
                        Container(
                          width: double.infinity,
                          //height: 375.w * 4 / 3,
                          margin: EdgeInsets.symmetric(vertical: 16.h),
                          child: Image.asset(
                            'assets/images/sptitle.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover, // 🔥 QUAN TRỌNG
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 16.w),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Cài đặt màu nền cho nút
                                foregroundColor: Colors
                                    .white, // Chuyển màu chữ thành trắng để tương phản tốt hơn
                                elevation: 2, // (Tùy chọn) Độ đổ bóng của nút
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ), // (Tùy chọn) Bo góc cho nút mềm mại hơn
                                ),
                              ),
                              child: const Text('Trở về'),
                            ),
                          ],
                        ),
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
                                    child: CachedNetworkImage(
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

                                  Text(
                                    item.categoryName ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: defaultText16B.copyWith(
                                      color: mainDarkGreen,
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
                                                ListDetailSpScreen(
                                                  model: item,
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
                        Container(
                          height: 160.h,
                          width: 375.w,
                          margin: EdgeInsets.only(bottom: 20.h),
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              colors: [mainDarkGreen, mainGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: mainDarkGreen,
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /// TEXT (tự co lại)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'ƯU ĐÃI ĐẶC QUYỀN GIẢM ĐẾN 30%',
                                      style: defaultText14B.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'NGUYÊN LIỆU VÀ DỤNG CỤ CHO HỌC VIÊN',
                                      style: defaultText14B.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        'Nhận ưu đãi ngay',
                                        style: defaultText16B.copyWith(
                                          color: mainDarkGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// IMAGE (giữ kích thước mong muốn)
                              SizedBox(
                                height: 140.h, // 👈 bạn control size ảnh ở đây
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://cogiaohealthy.vn/wp-content/uploads/2025/07/cogiao.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const CustomFooterInfo(),
                        // Khoảng cách cuối trang
                      ],
                    ),
                  ),
                ),
              ),
              BottomCustom(),
            ],
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
