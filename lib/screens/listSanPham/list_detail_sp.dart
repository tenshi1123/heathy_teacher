import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_dialog.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:intl/intl.dart';

class ListDetailSpScreen extends StatefulWidget {
  final CategoryModel model;
  const ListDetailSpScreen({super.key, required this.model});

  @override
  State<ListDetailSpScreen> createState() => _ListDetailSpScreenState();
}

class _ListDetailSpScreenState extends State<ListDetailSpScreen> {
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
      widget.model.categorySlug ?? '',
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
      widget.model.categorySlug ?? '',
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

      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 50), // Khoảng cách cho status bar

                      DefaultAppBar(),

                      // 2. SEARCH BAR AREA
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
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Nhập để tìm kiếm...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.search, color: mainGreen),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
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
                          fit: BoxFit.cover,
                        ),
                      ),
                      //back button
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
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          widget.model.categoryName ?? '',
                          style: defaultText18B.copyWith(color: mainDarkGreen),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            '    Sắp xếp theo: ',
                            style: defaultText14B.copyWith(color: colorText),
                          ),
                          FilterDropdownDialog(
                            options: const [
                              "Sản phẩm bán chạy",
                              "Giá tăng dần",
                              "Giá giảm dần",
                            ],
                            selected: selected,
                            onSelected: (value) {
                              setState(() {
                                selected = value; // 👈 update UI bên ngoài
                              });
                            },
                          ),
                        ],
                      ),
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
                              childAspectRatio: 0.55,
                            ),
                        itemBuilder: (context, index) {
                          final item = coursesDetail[index];

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
                                  child: Image.network(
                                    item.img!.contains('https://')
                                        ? item.img ?? ''
                                        : 'https://lms.cogiaohealthy.vn/images/${item.img}',
                                    //width: 50.dg,
                                    height: 160.dg,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace,
                                        ) {
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
                                    loadingBuilder:
                                        (
                                          BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child; // Đã tải xong
                                          }
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

                                Text(
                                  '${formatPrice(item.price)}đ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: defaultText16B.copyWith(
                                    color: mainDarkGreen,
                                  ),
                                ),
                                if (item.priceOld != '0')
                                  Text(
                                    '${formatPrice(item.priceOld)}đ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: defaultText12M.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
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
                                            (element) => element.id == item.id,
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
                                                onPressed: () => Navigator.pop(
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
                                        vertical: 2.h,
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: mainDarkGreen,
                                        borderRadius: BorderRadius.circular(8),
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
                          border: Border.all(color: mainDarkGreen, width: 1.w),
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
                                      borderRadius: BorderRadius.circular(16.r),
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
                              child: Image.network(
                                'https://cogiaohealthy.vn/wp-content/uploads/2025/07/cogiao.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 375.w,

                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                          color: mainDarkGreen,
                          border: Border.all(color: mainDarkGreen, width: 1.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
                              height: 60.h,
                              fit: BoxFit.contain,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: defaultText14M.copyWith(
                                        color: Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Hà Nội:',
                                          style: defaultText14B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' 214 Lạc Long Quân, quận Tây Hồ, Hà Nội',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: defaultText14M.copyWith(
                                        color: Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'HCM:',
                                          style: defaultText14B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' SkyVilla P2406, Celadon City, số 02 Tân Thanh, phường Tân Sơn Nhì, thành phố Hồ Chí Minh',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: defaultText14M.copyWith(
                                        color: Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Hotline:',
                                          style: defaultText14B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(text: '\n(+84)96 691 2016'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'CÔNG TY TNHH CÔ GIÁO HEALTHY',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'MST: 0109187074 \nĐăng ký lần đầu ngày 19 háng 05 năm 2020 \nĐăng ký thay đổi lần thứ 4, ngày 20 tháng 06 năm 2024 \nNơi cấp: Sở kế hoạch và đầu tư thành phố Hà Nội - Phòng đăng ký kinh doanh \nĐịa chỉ trụ sở chính: Tầng 7, Tòa nhà Luxury Ofice, số 214 Lạc Long Quân, Phường Tây Hồ, Thành phố Hà Nội, Việt Nam',
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Thông tin',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Giới thiệu chung',
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Khóa học'.sanitizeForApple,
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Sản phẩm',
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Chính sách bảo mật - học tập',
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Theo dõi Cô Giáo Healthy',
                                    style: defaultText16B.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Nhận thông tin mới nhất về khoá học, kiến thức nấu ăn!'
                                        .sanitizeForApple,
                                    style: defaultText14M.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      buildImage(
                                        'assets/images/facebook.png',
                                        size: 25,
                                      ),
                                      buildImage(
                                        'assets/images/youtube.png',
                                        size: 25,
                                      ),
                                      buildImage(
                                        'assets/images/tiktok.png',
                                        size: 25,
                                      ),
                                      buildImage(
                                        'assets/images/zalo.png',
                                        size: 25,
                                      ),
                                      buildImage(
                                        'assets/images/ins.png',
                                        size: 20,
                                      ),
                                      buildImage(
                                        'assets/images/threads.png',
                                        size: 25,
                                      ),

                                      buildImage(
                                        'assets/images/lemon8.png',
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '© 2025 Cô Giáo Healthy | All Rights Reserved.',
                              style: defaultText14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      // Khoảng cách cuối trang
                    ],
                  ),
                ),
              ),
              BottomCustom(),
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
