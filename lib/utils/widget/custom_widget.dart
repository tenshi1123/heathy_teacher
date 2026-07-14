import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/listSanPham/list_detail_sp.dart';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/homePage/register_class_online.dart';
import 'package:heathy_teacher/screens/authentication/login_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:heathy_teacher/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heathy_teacher/screens/bottomNavBar/bottom_bar_screen.dart';
import 'package:heathy_teacher/screens/recipe_detail_screen.dart';

class CustomDotLine extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final double height; // chiều cao toàn bộ widget (mặc định 1 dòng)

  const CustomDotLine({
    super.key,
    this.dotSize = 4,
    this.spacing = 4,
    this.color = Colors.black,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = (constraints.maxWidth / (dotSize + spacing)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              count,
              (_) => Container(
                width: dotSize,
                height: 1.h,
                decoration: BoxDecoration(color: color),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HinhThucHocDropdown extends StatefulWidget {
  final Function(String?) onChanged;
  final String? value;

  const HinhThucHocDropdown({super.key, required this.onChanged, this.value});

  @override
  State<HinhThucHocDropdown> createState() => _HinhThucHocDropdownState();
}

class _HinhThucHocDropdownState extends State<HinhThucHocDropdown> {
  final List<String> options = ["calendar", "customer_zoom_google_offline"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.value,
          isExpanded: true,
          hint: Text("Chọn hình thức học", style: defaultText14M),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: defaultText14M),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });
  final String hintText;
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 48.h,
      margin: EdgeInsets.only(right: 12.w, bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB), // nền giống ảnh
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.controller,
        style: defaultText14B, // màu text nhập
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: colorText.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function() onDelete;
  final Function() onIncrease;
  final Function() onDecrease;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// checkbox
          Checkbox(value: false, onChanged: (_) {}),

          /// image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name + delete
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// price
                Text(
                  '${formatPrice(item.price.toString())}đ',
                  style: defaultText14B,
                ),

                const SizedBox(height: 8),

                /// quantity
                if (!item.isCourse) ...[
                  const Text("Số lượng:"),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildBtn("-", onDecrease),
                      _buildQty(item.quantity),
                      _buildBtn("+", onIncrease),
                    ],
                  ),
                ] else
                  Text("Số lượng: ${item.quantity}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(String text, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }

  Widget _buildQty(int qty) {
    return Container(
      width: 40,
      height: 36,
      alignment: Alignment.center,
      child: Text("$qty"),
    );
  }
}

class CartSection extends StatelessWidget {
  final String title;
  final List<CartItem> items;
  final VoidCallback? onChanged;
  final Function(CartItem)? onDelete;

  const CartSection({
    super.key,
    required this.title,
    required this.items,
    this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $title (${items.length})",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        ...items.map(
          (item) => CartItemWidget(
            item: item,
            onDelete: () {
              onDelete?.call(item);
            },
            onIncrease: () {
              item.quantity++;
              onChanged?.call();
            },
            onDecrease: () {
              if (item.quantity > 1) item.quantity--;
              onChanged?.call();
            },
          ),
        ),
      ],
    );
  }
}

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.type, required this.place});
  final String type;
  final String place;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://lms.cogiaohealthy.vn/images/AVAMOI/B%E1%BA%A3n%20sao%20c%E1%BB%A7a%20%E1%BA%A2nh%20%C4%91%E1%BA%A1i%20di%E1%BB%87n%20kho%C3%A1%20h%E1%BB%8Dc%20tr%C3%AAn%20website%20%285%29.jpg',
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
                  'Đồ uống healthy',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'KHÓA HỌC MÔ HÌNH KINH DOANH SỮA HẠT DƯỠNG SINH HIỆN ĐẠI - MASTER CLASS 2026'
                .sanitizeForApple,
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
                '  07/05/2026 - 09/05/2026',
                style: defaultText14M.copyWith(color: mainDarkGreen),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: mainDarkGreen, size: 16),
              if (type == 'on')
                Text(
                  '  Học online qua app'.sanitizeForApple,
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                )
              else
                Text(
                  '  Trực tiếp tại $place',
                  style: defaultText14M.copyWith(color: Colors.red),
                ),
            ],
          ),
          if (type == 'off')
            Row(
              children: [
                Icon(Icons.person_outline, color: mainDarkGreen, size: 16),
                Text(
                  '  Giảng viên: Linh Phan',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: mainDarkGreen.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.yellow, size: 16),
                    Text(
                      '  1036 lượt học',
                      style: defaultText12M.copyWith(color: mainDarkGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5,990,000đ',
                    style: defaultText16B.copyWith(color: mainDarkGreen),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '6,990,000đ',
                    style: defaultText12M.copyWith(
                      color: colorText,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => type == 'on'
                          ? const RegisterClassON(id: '195')
                          : const RegisterClassOff(id: '168')),
                    ),
                  );
                  // showCitySelectionDialog(
                  //   context: context,
                  //   onCitySelected: (selectedCity) {

                  //   },
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),

                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: mainDarkGreen.withOpacity(0.1),
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
            ],
          ),
        ],
      ),
    );
  }
}

class CourseItemOnline extends StatelessWidget {
  const CourseItemOnline({super.key, required this.type, required this.place});
  final String type;
  final String place;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/images/online.jpg'),
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
                  'Đồ uống healthy',
                  style: defaultText14M.copyWith(color: mainDarkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '[ONLINE] KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG (ENERGY BOWL) VÀ CHẾ BIẾN THỰC PHẨM ĐÓNG GÓI SẴN '
                .sanitizeForApple,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: defaultText18B.copyWith(color: mainDarkGreen),
          ),
          SizedBox(height: 8.h),

          Row(
            children: const [
              Icon(
                Icons.co_present_outlined, // Icon tương đối giống bản gốc
                color: Color(0xFF3B7139),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Linh Phan',
                style: TextStyle(
                  color: Color(0xFF3B7139),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Icon(Icons.location_on_outlined, color: mainDarkGreen, size: 16),
              if (type == 'on')
                Text(
                  '  Học online qua app'.sanitizeForApple,
                  style: defaultText14M.copyWith(color: Colors.red),
                )
              else
                Text(
                  '  Trực tiếp tại $place',
                  style: defaultText14M.copyWith(color: Colors.red),
                ),
            ],
          ),
          // Giá tiền
          if (isShow == 'true')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  '2,990,000đ',
                  style: TextStyle(
                    color: Color(0xFF759E73),
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '1,990,000đ',
                  style: TextStyle(
                    color: Color(0xFF3B7139),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),

          // Các thông số (Pills)
          Row(
            children: [
              Expanded(
                child: _buildStatBadge(
                  icon: Icons.play_circle_fill,
                  iconColor: const Color(0xFFFCD34D),
                  text: '1 bài học',
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: _buildStatBadge(
                  icon: Icons.person,
                  iconColor: const Color(0xFFFBBF24),
                  text: '1089 lượt học',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Nút Đăng ký
          if (isShow == 'true')
            ElevatedButton(
              onPressed: () {
                // Xử lý sự kiện đăng ký
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const RegisterClassON(id: '195')),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF467D43),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Đăng ký ngay',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
              ),
              alignment: Alignment.center,
              child: const Text(
                'Đã khóa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF41763E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultAppBar extends StatefulWidget {
  const DefaultAppBar({super.key});

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  static const Color accentBrown = Color(0xFFD4A76A);
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                //width: 150,
                height: 150,
                child: FittedBox(
                  // FittedBox giúp Logo tự scale vừa khít SizedBox
                  fit: BoxFit.fitHeight,
                  child: LogoWidget(), // Widget Logo của bạn
                ),
              ),
            ),

            // 3. HAI NÚT HAI BÊN - GIỮ NGUYÊN KÍCH THƯỚC NHỎ
            // Nhờ Row nằm trong Stack, nó chỉ cao bằng "content" của nó, không cao bằng Logo.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Rất quan trọng: Căn Row này vào giữa chiều cao của Stack
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nút Đăng nhập (Bên trái - kích thước nhỏ)
                ElevatedButton(
                  onPressed: () {
                    if (_isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const BottomBarScreen()),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const LoginScreen()),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backGroundGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // Padding nhỏ để nút gọn gàng
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    _isLoggedIn ? 'Tài khoản' : 'Đăng nhập',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Giảm font size một chút nếu cần
                    ),
                  ),
                ),

                // Giỏ hàng (Bên phải - kích thước nhỏ)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ShoppingCartScreen()),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: mainDarkGreen,
                        size: 28, // Giảm size Icon giỏ hàng một chút
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3), // Padding nhỏ hơn
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF176),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              ' 0 ',
                              style: TextStyle(
                                color: accentBrown,
                                fontWeight: FontWeight.bold,
                                fontSize: 8, // Font chữ số nhỏ hơn
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});
  static const Color accentBrown = Color(0xFFD4A76A);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                const CoGiaoHealthyScreen(type: 'home', place: 'Hà Nội')),
          ),
        );
      },
      child: Image.asset(
        'assets/images/logo.png', // Hãy thay bằng logo thật của bạn
        height: 88.h,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) => Column(
          children: [
            Text(
              'Cô Giáo',
              style: TextStyle(
                fontSize: 18,
                color: accentBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'healthy',
              style: TextStyle(
                fontSize: 18,
                color: mainDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //maxWidth: 380, // Giới hạn chiều rộng tối đa cho đẹp mắt
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner màu xanh trên cùng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF3B7E45), // Màu xanh lá chủ đạo
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Text(
              'Khoá học nấu ăn Eatclean -\nHealthy - Vegan'.sanitizeForApple,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),

          // Phần nội dung bên dưới Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Khu vực hình ảnh đan xen (Image Grid + Stack)
                SizedBox(
                  height: 240,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          // Ảnh lớn bên trái
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://picsum.photos/300/400', // Thay bằng link ảnh thật
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 2 ảnh nhỏ bên phải
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://picsum.photos/300/200', // Thay bằng link ảnh thật
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://picsum.photos/300/200', // Thay bằng link ảnh thật
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      // Tag chữ nhỏ đè góc phải dưới
                                      Positioned(
                                        bottom: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.95,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFF3B7E45),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Text(
                                            'Nấu ăn eatclean - healthy',
                                            style: TextStyle(
                                              color: Color(0xFF3B7E45),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Logo hình tròn nằm chính giữa tổ hợp ảnh
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Cô Giáo',
                                style: TextStyle(
                                  color: Color(0xFFCCA464),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'healthy',
                                style: TextStyle(
                                  color: Color(0xFF3B7E45),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // 3. Tiêu đề khóa học
                Text(
                  '[ONLINE] KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG...'
                      .sanitizeForApple,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF2B5B34),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // 4. Giảng viên
                Row(
                  children: const [
                    Icon(Icons.co_present, color: Color(0xFF4A5568), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Cô giáo Healthy',
                      style: TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 5. Chỉ số (Bài học & Lượt học)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBadge(
                      icon: Icons.play_circle_fill,
                      iconColor: const Color(0xFFECC94B),
                      text: '56 bài học',
                    ),
                    _buildStatBadge(
                      icon: Icons.people_alt,
                      iconColor: const Color(0xFFED8936),
                      text: '1141 lượt học',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 6. Nút "Học thử ngay"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý sự kiện khi ấn nút ở đây
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B7E45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Học thử ngay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm bổ trợ tạo các Badge thông số (Bài học / Lượt học)
  Widget _buildStatBadge({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeGridWidget extends StatelessWidget {
  final List<PostModel> recipes;
  final int type; // 1: công thức, 2: bài viết
  const RecipeGridWidget({
    super.key,
    required this.recipes,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Tối ưu cho danh sách dài bằng cách tải lười (lazy loading)
      shrinkWrap: true, // <--- Ép co kích thước theo content
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Chia làm 2 cột bên trái và bên phải
        crossAxisSpacing: 12, // Khoảng cách giữa 2 cột
        mainAxisSpacing: 12, // Khoảng cách giữa các hàng
        childAspectRatio: type == 2 ? 0.65 : 0.8,
      ),
      itemBuilder: (context, index) {
        final item = recipes[index];
        return _buildRecipeCard(context, item, recipes);
      },
    );
  }

  // Widget con đại diện cho từng ô sản phẩm/bài viết
  Widget _buildRecipeCard(
    BuildContext context,
    PostModel item,
    List<PostModel>? relatedRecipes,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => type == 1
                ? RecipeDetailScreen(
                    slug: item.slug ?? '',
                    relatedRecipes: relatedRecipes ?? [],
                  )
                : RecipeDetailScreen(
                    slug: item.slug ?? '',
                    relatedRecipes: relatedRecipes ?? [],
                  ),
            //DiaryDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: backGroundGreen, // Màu nền xanh lá phía dưới card
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Phần hình ảnh phía trên (Bo góc trên trái, trên phải)
            Expanded(
              flex: type == 2
                  ? 12
                  : 22, // Chiếm phần lớn diện tích cho ảnh hiển thị đẹp
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: item.thumbnail,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  // Xử lý khi ảnh lỗi hoặc đang tải
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Phần nội dung chữ phía dưới (Nền xanh)
            Expanded(
              flex: 11, // Tăng phần không gian dành cho chữ
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: defaultText12B.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoLessonPreviewWidget extends StatelessWidget {
  const VideoLessonPreviewWidget({super.key});

  // Hàm xử lý mở link YouTube
  Future<void> _launchYouTubeVideo() async {
    const String urlString = 'https://www.youtube.com/watch?v=vW5ZnHW95WM';
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode
            .externalApplication, // Mở bằng app YouTube bên ngoài (hoặc trình duyệt nếu không có app)
      );
    } else {
      debugPrint('Không thể mở liên kết: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Phần tiêu đề Giảng viên
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: const [
              Icon(Icons.co_present_outlined, color: Colors.black87, size: 22),
              SizedBox(width: 8),
              Text(
                'Giảng viên: Linh Phan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // 2. Khung Video chính (Dùng Stack)
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            children: [
              // LỚP NỀN: ĐÃ ĐỔI THÀNH LINK THUMBNAIL CHUẨN CỦA VIDEO YOUTUBE BẠN CUNG CẤP
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://i.ytimg.com/vi/vW5ZnHW95WM/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  // Trường hợp ảnh lỗi hoặc đang tải thì hiện màu nền xám nhẹ
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey[300]),
                  placeholder: (context, url) {
                    return Container(color: Colors.grey[200]);
                  },
                ),
              ),

              // Lớp phủ mờ màu đen để làm nổi bật text và nút play
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                      stops: const [0.0, 0.2, 0.8, 1.0],
                    ),
                  ),
                ),
              ),

              // NÚT PLAY: ĐÃ THÊM HÀM MỞ LINK YOUTUBE KHI CLICK
              Center(
                child: InkWell(
                  onTap:
                      _launchYouTubeVideo, // Gọi hàm mở link khi nhấn vào nút Play
                  splashColor: Colors.white24,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 68,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000), // Đỏ YouTube
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),

              // Thông tin tiêu đề video đè góc trên bên trái
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100&auto=format&fit=crop',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG'
                                .sanitizeForApple,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 4, color: Colors.black),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Cô Giáo Healthy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE0E0E0),
                              shadows: [
                                Shadow(blurRadius: 4, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Share & Watch Later góc dưới bên trái
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    _buildCircleOverlayButton(
                      Icons.reply_outlined,
                      onTap: _launchYouTubeVideo,
                    ),
                    const SizedBox(width: 8),
                    _buildCircleOverlayButton(
                      Icons.access_time,
                      onTap: _launchYouTubeVideo,
                    ),
                  ],
                ),
              ),

              // Chữ "Xem trên YouTube" góc dưới bên phải
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap:
                      _launchYouTubeVideo, // Cho phép click luôn vào cụm chữ này để mở link
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Xem trên ',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Icon(Icons.play_circle, color: Colors.red, size: 16),
                        Text(
                          'YouTube',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. Thanh thông tin liên hệ màu xanh lá dưới đáy video
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: const Color(0xFF467D43),
          child: const Text(
            'Fanpage Linh Phan - Cô Giáo Healthy. Hotline: 0966 912 016. Địa chỉ: 214 Lạc Long Quân, Tây Hồ, Hà Nội',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleOverlayButton(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;
  final Widget? errorWidget;
  final Widget? placeholder;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget defaultPlaceholder() {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey.shade400,
          size: 32,
        ),
      );
    }

    final image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) {
        return placeholder ?? defaultPlaceholder();
      },
      errorWidget: (context, url, error) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey.shade400,
              ),
            );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: image,
      );
    }

    return image;
  }
}
