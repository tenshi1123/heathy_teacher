import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/models/schedule_model.dart';
import 'package:heathy_teacher/screens/homePage/register_class.dart';
import 'package:heathy_teacher/screens/login_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';

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
  final List<String> options = [
    "Lịch học ở trung tâm",
    "Lịch học Zoom",
    "Lịch học phụ đạo - học bù",
  ];

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
  const CustomTextField({super.key, required this.hintText});
  final String hintText;
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
        //ontroller: widget.controller,
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
            child: Image.asset(
              item.image,
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
                  "${item.price} đ",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
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

  const CartSection({super.key, required this.title, required this.items});

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
            onDelete: () {},
            onIncrease: () {
              item.quantity++;
            },
            onDecrease: () {
              if (item.quantity > 1) item.quantity--;
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
          Image.network(
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
            'KHÓA HỌC MÔ HÌNH KINH DOANH SỮA HẠT DƯỠNG SINH HIỆN ĐẠI - MASTER CLASS 2026',
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
                  '  Học online qua app',
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
                      builder: ((context) => RegisterClassOff(type: type)),
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

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({super.key});
  static const Color accentBrown = Color(0xFFD4A76A);
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
                // Truyền kích thước to hơn hẳn cho Logo ở đây
                width: 150, // Ví dụ chiều rộng to
                height: 150, // Ví dụ chiều cao to
                child: FittedBox(
                  // FittedBox giúp Logo tự scale vừa khít SizedBox
                  fit: BoxFit.contain,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const LoginScreen()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
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
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
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
            child: const Text(
              'Khoá học nấu ăn Eatclean -\nHealthy - Vegan',
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
                              child: Image.network(
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
                                    child: Image.network(
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
                                        child: Image.network(
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
                const SizedBox(height: 16),

                // 3. Tiêu đề khóa học
                const Text(
                  '[ONLINE] KHÓA HỌC MÔ HÌNH KINH DOANH SUẤT ĂN SIÊU NĂNG LƯỢNG...',
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
  final List<RecipeModel> recipes;
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
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Chia làm 2 cột bên trái và bên phải
        crossAxisSpacing: 12, // Khoảng cách giữa 2 cột
        mainAxisSpacing: 12, // Khoảng cách giữa các hàng
        childAspectRatio: type == 2
            ? 0.6
            : 0.8, // Tỷ lệ Chiều rộng / Chiều cao để vừa vặn text và ảnh
      ),
      itemBuilder: (context, index) {
        final item = recipes[index];
        return _buildRecipeCard(item);
      },
    );
  }

  // Widget con đại diện cho từng ô sản phẩm/bài viết
  Widget _buildRecipeCard(RecipeModel item) {
    return Container(
      decoration: BoxDecoration(
        color: mainGreen, // Màu nền xanh lá phía dưới card
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
            flex: 11, // Chiếm phần lớn diện tích cho ảnh hiển thị đẹp
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                item.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                // Xử lý khi ảnh lỗi hoặc đang tải
                errorBuilder: (context, error, stackTrace) => Container(
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
            flex: 9, // Phần không gian dành cho chữ và ngày tháng
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tiêu đề bài viết
                  Text(
                    item.title.toUpperCase(), // Chuyển chữ hoa như mẫu
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: defaultText14B.copyWith(color: Colors.white),
                  ),
                  Text(
                    item.detail ??
                        '', // Hiển thị chi tiết nếu có, nếu không hiển thị chuỗi rỗng
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: defaultText12M.copyWith(color: Colors.white),
                  ),
                  // Ngày tháng năm (Đẩy xuống sát góc phải dưới)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.date,
                        style: defaultText12M.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
