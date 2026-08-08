import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/introduce_screen.dart';
import 'package:heathy_teacher/screens/listSanPham/list_detail_sp.dart';
import 'package:heathy_teacher/screens/listSanPham/list_sp.dart';
import 'package:heathy_teacher/screens/homePage/list_class_online.dart';
import 'package:heathy_teacher/screens/drawer/chinh_sach_screen.dart';
import 'package:heathy_teacher/screens/splash/list_class_online_external.dart';
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
import 'package:heathy_teacher/utils/global_data.dart';

class CustomDotLine extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final double height; // chiá»u cao toÃ n bá»™ widget (máº·c Ä‘á»‹nh 1 dÃ²ng)

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
          hint: Text("Chá»n hÃ¬nh thá»©c há»c", style: defaultText14M),
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
        color: const Color(0xFFF7F9FB), // ná»n giá»‘ng áº£nh
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.controller,
        style: defaultText14B, // mÃ u text nháº­p
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
  final Function(bool?)? onSelect;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// checkbox
          Checkbox(value: item.isSelected ?? true, onChanged: onSelect),

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
                  '${formatPrice(item.price.toString())}Ä‘',
                  style: defaultText14B,
                ),

                const SizedBox(height: 8),

                /// quantity
                const Text("Sá»‘ lÆ°á»£ng:"),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildBtn("-", onDecrease),
                    _buildQty(item.quantity),
                    _buildBtn("+", onIncrease),
                  ],
                ),
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
            onSelect: (val) {
              item.isSelected = val ?? false;
              onChanged?.call();
            },
          ),
        ),
      ],
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
        height: 100.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                //width: 150,
                height: 150,
                child: FittedBox(
                  // FittedBox giÃºp Logo tá»± scale vá»«a khÃ­t SizedBox
                  fit: BoxFit.fitHeight,
                  child: LogoWidget(), // Widget Logo cá»§a báº¡n
                ),
              ),
            ),

            // 3. HAI NÃšT HAI BÃŠN - GIá»® NGUYÃŠN KÃCH THÆ¯á»šC NHá»Ž
            // Nhá» Row náº±m trong Stack, nÃ³ chá»‰ cao báº±ng "content" cá»§a nÃ³, khÃ´ng cao báº±ng Logo.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Ráº¥t quan trá»ng: CÄƒn Row nÃ y vÃ o giá»¯a chiá»u cao cá»§a Stack
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // NÃºt ÄÄƒng nháº­p (BÃªn trÃ¡i - kÃ­ch thÆ°á»›c nhá»)
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
                    // Padding nhá» Ä‘á»ƒ nÃºt gá»n gÃ ng
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    _isLoggedIn ? 'TÃ i khoáº£n' : 'ÄÄƒng nháº­p',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Giáº£m font size má»™t chÃºt náº¿u cáº§n
                    ),
                  ),
                ),

                // Giá» hÃ ng (BÃªn pháº£i - kÃ­ch thÆ°á»›c nhá»)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ShoppingCartScreen()),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 40.dg,
                    height: 40.dg,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: mainDarkGreen,
                          size: 30.dg, // Giáº£m size Icon giá» hÃ ng má»™t chÃºt
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3), // Padding nhá» hÆ¡n
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: subYellow2,
                                shape: BoxShape.circle,
                              ),
                              child: ValueListenableBuilder<int>(
                                valueListenable: globalListCart.lengthNotifier,
                                builder: (context, count, child) {
                                  return Text(
                                    ' $count ',
                                    style: defaultText12B.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class CustomFooterInfo extends StatelessWidget {
  const CustomFooterInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          CachedNetworkImage(
            imageUrl:
                'https://cogiaohealthy.vn/wp-content/uploads/2025/07/logo_footer.png',
            height: 60.h,
            fit: BoxFit.contain,
          ),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(
                'https://maps.app.goo.gl/HokDJtxrPcZxkHNP9',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.white, size: 32),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: defaultText14M.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'HÃ  Ná»™i:',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: ' 214 Láº¡c Long QuÃ¢n, quáº­n TÃ¢y Há»“, HÃ  Ná»™i',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(
                'https://maps.app.goo.gl/owfRdPrmmCCeRhpC7?g_st=ipc',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.white, size: 32),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: defaultText14M.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'HCM:',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' SkyVilla P2406, Celadon City, sá»‘ 02 TÃ¢n Thanh, phÆ°á»ng TÃ¢n SÆ¡n NhÃ¬, thÃ nh phá»‘ Há»“ ChÃ­ Minh',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: '(+84)96 691 2016',
              );
              launchUrl(launchUri);
            },
            child: Row(
              children: [
                Icon(Icons.phone_outlined, color: Colors.white, size: 32),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: defaultText14M.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hotline:',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        TextSpan(text: '(+84)96 691 2016'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final Uri launchUri = Uri(
                scheme: 'mailto',
                path: 'cogiaohealthy@gmail.com',
              );
              launchUrl(launchUri);
            },
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: Colors.white, size: 32),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: defaultText14M.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Email: ',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        TextSpan(text: 'cogiaohealthy@gmail.com'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'CÃ”NG TY TNHH CÃ” GIÃO HEALTHY',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          Text(
            'MST: 0109187074 \nÄÄƒng kÃ½ láº§n Ä‘áº§u ngÃ y 19 hÃ¡ng 05 nÄƒm 2020 \nÄÄƒng kÃ½ thay Ä‘á»•i láº§n thá»© 4, ngÃ y 20 thÃ¡ng 06 nÄƒm 2024 \nNÆ¡i cáº¥p: Sá»Ÿ káº¿ hoáº¡ch vÃ  Ä‘áº§u tÆ° thÃ nh phá»‘ HÃ  Ná»™i - PhÃ²ng Ä‘Äƒng kÃ½ kinh doanh \nÄá»‹a chá»‰ trá»¥ sá»Ÿ chÃ­nh: Táº§ng 7, TÃ²a nhÃ  Luxury Ofice, sá»‘ 214 Láº¡c Long QuÃ¢n, PhÆ°á»ng TÃ¢y Há»“, ThÃ nh phá»‘ HÃ  Ná»™i, Viá»‡t Nam',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          Text(
            'ThÃ´ng tin',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IntroduceScreen(),
                ),
              );
            },
            child: Text(
              'Giá»›i thiá»‡u chung',
              style: defaultText14M.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListClassOnlineExternal(),
                ),
              );
            },
            child: Text(
              'KhÃ³a há»c'.sanitizeForApple,
              style: defaultText14M.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListSpScreen()),
              );
            },
            child: Text(
              'Sáº£n pháº©m',
              style: defaultText14M.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChinhSachScreen(),
                ),
              );
            },
            child: Text(
              'ChÃ­nh sÃ¡ch báº£o máº­t - há»c táº­p',
              style: defaultText14M.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: mainGreen,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Theo dÃµi CÃ´ GiÃ¡o Healthy',
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
                Text(
                  'Nháº­n thÃ´ng tin má»›i nháº¥t vá» khoÃ¡ há»c, kiáº¿n thá»©c náº¥u Äƒn!'
                      .sanitizeForApple,
                  style: defaultText14M.copyWith(color: Colors.white),
                ),
                Builder(
                  builder: (context) {
                    void openUrl(String link) async {
                      final Uri url = Uri.parse(link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildImage(
                          'assets/images/facebook.png',
                          size: 25,
                          onTap: () =>
                              openUrl('https://www.facebook.com/cogiaohealthy'),
                        ),
                        buildImage(
                          'assets/images/youtube.png',
                          size: 25,
                          onTap: () =>
                              openUrl('https://www.youtube.com/@cogiaohealthy'),
                        ),
                        buildImage(
                          'assets/images/tiktok.png',
                          size: 25,
                          onTap: () =>
                              openUrl('https://www.tiktok.com/@cogiaohealthy'),
                        ),
                        buildImage(
                          'assets/images/zalo.png',
                          size: 25,
                          onTap: () =>
                              openUrl('https://zalo.me/4529987293035203584'),
                        ),
                        buildImage(
                          'assets/images/ins.png',
                          size: 20,
                          onTap: () => openUrl(
                            'https://www.instagram.com/cogiaohealthy',
                          ),
                        ),
                        buildImage(
                          'assets/images/threads.png',
                          size: 25,
                          onTap: () =>
                              openUrl('https://www.threads.com/@cogiaohealthy'),
                        ),
                        buildImage(
                          'assets/images/lemon8.png',
                          size: 25,
                          onTap: () => openUrl(
                            'https://www.lemon8-app.com/@cogiaohealthy',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Text(
            'Â© 2025 CÃ´ GiÃ¡o Healthy | All Rights Reserved.',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
          SizedBox(height: 30.h),
        ],
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
                const CoGiaoHealthyScreen(type: 'home', place: 'HÃ  Ná»™i')),
          ),
        );
      },
      child: Image.asset(
        'assets/images/logo.png', // HÃ£y thay báº±ng logo tháº­t cá»§a báº¡n
        height: 88.h,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) => Column(
          children: [
            Text(
              'CÃ´ GiÃ¡o',
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
      //maxWidth: 380, // Giá»›i háº¡n chiá»u rá»™ng tá»‘i Ä‘a cho Ä‘áº¹p máº¯t
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
          // 1. Banner mÃ u xanh trÃªn cÃ¹ng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF3B7E45), // MÃ u xanh lÃ¡ chá»§ Ä‘áº¡o
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Text(
              'KhoÃ¡ há»c náº¥u Äƒn Eatclean -\nHealthy - Vegan'.sanitizeForApple,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),

          // Pháº§n ná»™i dung bÃªn dÆ°á»›i Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Khu vá»±c hÃ¬nh áº£nh Ä‘an xen (Image Grid + Stack)
                SizedBox(
                  height: 240,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          // áº¢nh lá»›n bÃªn trÃ¡i
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://picsum.photos/300/400', // Thay báº±ng link áº£nh tháº­t
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 2 áº£nh nhá» bÃªn pháº£i
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://picsum.photos/300/200', // Thay báº±ng link áº£nh tháº­t
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
                                              'https://picsum.photos/300/200', // Thay báº±ng link áº£nh tháº­t
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      // Tag chá»¯ nhá» Ä‘Ã¨ gÃ³c pháº£i dÆ°á»›i
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
                                            'Náº¥u Äƒn eatclean - healthy',
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
                      // Logo hÃ¬nh trÃ²n náº±m chÃ­nh giá»¯a tá»• há»£p áº£nh
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
                                'CÃ´ GiÃ¡o',
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

                // 3. TiÃªu Ä‘á» khÃ³a há»c
                Text(
                  '[ONLINE] KHÃ“A Há»ŒC MÃ” HÃŒNH KINH DOANH SUáº¤T Ä‚N SIÃŠU NÄ‚NG LÆ¯á»¢NG...'
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

                // 4. Giáº£ng viÃªn
                Row(
                  children: const [
                    Icon(Icons.co_present, color: Color(0xFF4A5568), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'CÃ´ giÃ¡o Healthy',
                      style: TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 5. Chá»‰ sá»‘ (BÃ i há»c & LÆ°á»£t há»c)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBadge(
                      icon: Icons.play_circle_fill,
                      iconColor: const Color(0xFFECC94B),
                      text: '56 bÃ i há»c',
                    ),
                    _buildStatBadge(
                      icon: Icons.people_alt,
                      iconColor: const Color(0xFFED8936),
                      text: '1141 lÆ°á»£t há»c',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 6. NÃºt "Há»c thá»­ ngay"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xá»­ lÃ½ sá»± kiá»‡n khi áº¥n nÃºt á»Ÿ Ä‘Ã¢y
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B7E45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Há»c thá»­ ngay',
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

  // HÃ m bá»• trá»£ táº¡o cÃ¡c Badge thÃ´ng sá»‘ (BÃ i há»c / LÆ°á»£t há»c)
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
  final int type; // 1: cÃ´ng thá»©c, 2: bÃ i viáº¿t
  const RecipeGridWidget({
    super.key,
    required this.recipes,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Tá»‘i Æ°u cho danh sÃ¡ch dÃ i báº±ng cÃ¡ch táº£i lÆ°á»i (lazy loading)
      shrinkWrap: true, // <--- Ã‰p co kÃ­ch thÆ°á»›c theo content
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Chia lÃ m 2 cá»™t bÃªn trÃ¡i vÃ  bÃªn pháº£i
        crossAxisSpacing: 12, // Khoáº£ng cÃ¡ch giá»¯a 2 cá»™t
        mainAxisSpacing: 12, // Khoáº£ng cÃ¡ch giá»¯a cÃ¡c hÃ ng
        childAspectRatio: type == 2 ? 0.65 : 0.8,
      ),
      itemBuilder: (context, index) {
        final item = recipes[index];
        return _buildRecipeCard(context, item, recipes);
      },
    );
  }

  // Widget con Ä‘áº¡i diá»‡n cho tá»«ng Ã´ sáº£n pháº©m/bÃ i viáº¿t
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
          color: backGroundGreen, // MÃ u ná»n xanh lÃ¡ phÃ­a dÆ°á»›i card
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
            // 1. Pháº§n hÃ¬nh áº£nh phÃ­a trÃªn (Bo gÃ³c trÃªn trÃ¡i, trÃªn pháº£i)
            Expanded(
              flex: type == 2
                  ? 12
                  : 22, // Chiáº¿m pháº§n lá»›n diá»‡n tÃ­ch cho áº£nh hiá»ƒn thá»‹ Ä‘áº¹p
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
                  // Xá»­ lÃ½ khi áº£nh lá»—i hoáº·c Ä‘ang táº£i
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

            // 2. Pháº§n ná»™i dung chá»¯ phÃ­a dÆ°á»›i (Ná»n xanh)
            Expanded(
              flex: 11, // TÄƒng pháº§n khÃ´ng gian dÃ nh cho chá»¯
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

  // HÃ m xá»­ lÃ½ má»Ÿ link YouTube
  Future<void> _launchYouTubeVideo() async {
    const String urlString = 'https://www.youtube.com/watch?v=vW5ZnHW95WM';
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode
            .externalApplication, // Má»Ÿ báº±ng app YouTube bÃªn ngoÃ i (hoáº·c trÃ¬nh duyá»‡t náº¿u khÃ´ng cÃ³ app)
      );
    } else {
      debugPrint('KhÃ´ng thá»ƒ má»Ÿ liÃªn káº¿t: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Pháº§n tiÃªu Ä‘á» Giáº£ng viÃªn
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: const [
              Icon(Icons.co_present_outlined, color: Colors.black87, size: 22),
              SizedBox(width: 8),
              Text(
                'Giáº£ng viÃªn: Linh Phan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // 2. Khung Video chÃ­nh (DÃ¹ng Stack)
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            children: [
              // Lá»šP Ná»€N: ÄÃƒ Äá»”I THÃ€NH LINK THUMBNAIL CHUáº¨N Cá»¦A VIDEO YOUTUBE Báº N CUNG Cáº¤P
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://i.ytimg.com/vi/vW5ZnHW95WM/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  // TrÆ°á»ng há»£p áº£nh lá»—i hoáº·c Ä‘ang táº£i thÃ¬ hiá»‡n mÃ u ná»n xÃ¡m nháº¹
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey[300]),
                  placeholder: (context, url) {
                    return Container(color: Colors.grey[200]);
                  },
                ),
              ),

              // Lá»›p phá»§ má» mÃ u Ä‘en Ä‘á»ƒ lÃ m ná»•i báº­t text vÃ  nÃºt play
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

              // NÃšT PLAY: ÄÃƒ THÃŠM HÃ€M Má»ž LINK YOUTUBE KHI CLICK
              Center(
                child: InkWell(
                  onTap:
                      _launchYouTubeVideo, // Gá»i hÃ m má»Ÿ link khi nháº¥n vÃ o nÃºt Play
                  splashColor: Colors.white24,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 68,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000), // Äá» YouTube
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

              // ThÃ´ng tin tiÃªu Ä‘á» video Ä‘Ã¨ gÃ³c trÃªn bÃªn trÃ¡i
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
                            'KHÃ“A Há»ŒC MÃ” HÃŒNH KINH DOANH SUáº¤T Ä‚N SIÃŠU NÄ‚NG LÆ¯á»¢NG'
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
                            'CÃ´ GiÃ¡o Healthy',
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

              // NÃºt Share & Watch Later gÃ³c dÆ°á»›i bÃªn trÃ¡i
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

              // Chá»¯ "Xem trÃªn YouTube" gÃ³c dÆ°á»›i bÃªn pháº£i
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap:
                      _launchYouTubeVideo, // Cho phÃ©p click luÃ´n vÃ o cá»¥m chá»¯ nÃ y Ä‘á»ƒ má»Ÿ link
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
                          'Xem trÃªn ',
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

        // 3. Thanh thÃ´ng tin liÃªn há»‡ mÃ u xanh lÃ¡ dÆ°á»›i Ä‘Ã¡y video
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: const Color(0xFF467D43),
          child: const Text(
            'Fanpage Linh Phan - CÃ´ GiÃ¡o Healthy. Hotline: 0966 912 016. Äá»‹a chá»‰: 214 Láº¡c Long QuÃ¢n, TÃ¢y Há»“, HÃ  Ná»™i',
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

Widget buildImage(String iconPath, {double size = 28, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
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
    ),
  );
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final Color borderColor;
  final Color iconColor;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.borderColor = const Color(0xFFC0CA33),
    this.iconColor = const Color(0xFF7CB342),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 6.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Nh?p d? tìm ki?m...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: iconColor,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }
}

