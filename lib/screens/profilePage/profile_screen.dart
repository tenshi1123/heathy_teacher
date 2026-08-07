import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/screens/drawer/hoc_phi_screen.dart';
import 'package:heathy_teacher/screens/profilePage/detail_info_screen.dart';
import 'package:heathy_teacher/screens/splash/external_page.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyCustomDrawer(userModel: widget.userModel, selectedIndex: 0),
      body: Column(
        children: [
          SizedBox(
            width: 375.w,
            height: 200.h,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    width: 375.w,
                    height: 200.h,
                    image: const AssetImage(
                      'assets/images/person_background.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 40.h,
                  child: SizedBox(
                    width: 375.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ), // Icon 3 gạch
                                  onPressed: () {
                                    Scaffold.of(
                                      context,
                                    ).openDrawer(); // Lệnh gọi Drawer trượt ra
                                  },
                                );
                              },
                            ),
                            Text(
                              'Tài khoản',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
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
                                width: 24.w,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 375.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 138.w,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.userModel.img!.contains('https://')
                            ? '${widget.userModel.img}'
                            : 'https://lms.cogiaohealthy.vn/${widget.userModel.img}',
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                        // Hiển thị Icon mặc định khi lỗi tải ảnh
                        errorWidget: (context, url, error) {
                          return Container(
                            width: 80.w,
                            height: 80.h,
                            color:
                                Colors.grey[200], // Màu nền của icon mặc định
                            child: Icon(
                              Icons
                                  .person, // Hoặc Icons.error_outline tuỳ ý bạn
                              size: 40.w,
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
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            widget.userModel.fullName ?? 'không xác định',
            style: defaultText18B,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          Text('${widget.userModel.memberRanking}', style: defaultText14B),
          RichText(
            text: TextSpan(
              style: defaultText14M,
              children: [
                TextSpan(text: 'Điểm tích lũy: '),
                TextSpan(
                  text: formatPrice(widget.userModel.accumulatedPoint),
                  style: defaultText14B,
                ),
                TextSpan(text: ' điểm'),
              ],
            ),
          ),
          SelectableText.rich(
            TextSpan(
              style: defaultText14M,
              children: [
                TextSpan(text: 'Mã giới thiệu: '),
                TextSpan(text: widget.userModel.phone, style: defaultText14B),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailInfoScreen(model: widget.userModel),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/person.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text("Thông tin tài khoản", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Container(
          //     margin: EdgeInsets.only(top: 16.h),
          //     width: 343.w,
          //     height: 60.h,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFF0F2F4),
          //       borderRadius: BorderRadius.circular(16.r),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16.w),
          //       child: Row(
          //         children: [
          //           Container(
          //             width: 36.w,
          //             height: 36.h,
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(12.r),
          //             ),
          //             child: Center(
          //               child: SvgPicture.asset(
          //                 'assets/icons/key.svg',
          //                 width: 20.w,
          //                 height: 20.h,
          //               ),
          //             ),
          //           ),
          //           SizedBox(width: 12.w),
          //           Text("Đổi mật khẩu", style: defaultText14B),
          //           Spacer(),
          //           Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => HocPhiScreen())),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(child: Icon(Icons.payment)),
                    ),
                    SizedBox(width: 12.w),
                    Text("Lịch sử thanh toán", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => dialogBuilder(context, type: 0),
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(child: Icon(Icons.delete)),
                    ),
                    SizedBox(width: 12.w),
                    Text("Xóa tài khoản", style: defaultText14B),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => dialogBuilder(context, type: 1),
            child: Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 343.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/logout.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Đăng xuất",
                      style: defaultText14B.copyWith(color: Color(0xffF70B22)),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 20.r, color: colorText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> dialogBuilder(BuildContext context, {required int type}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          type == 0 ? 'Cảnh báo !!' : 'Đăng xuất',
          style: defaultText16B,
        ),
        content: Text(
          type == 0
              ? 'Bạn có chắc muốn xóa tài khoản ?'
              : 'Bạn có chắc muốn đăng xuất ?',
          style: defaultText14M,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              'Hủy',
              style: defaultText14M.copyWith(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              type == 0 ? 'Xóa Tài Khoản' : 'Đăng xuất',
              style: defaultText14B.copyWith(color: Colors.red),
            ),
            onPressed: () async {
              //remove token
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('id_user');
              await prefs.remove('remember_token');
              HomeRepo.cachedUser = null;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      const CoGiaoHealthyScreen(type: 'home', place: 'Hà Nội')),
                ),
              );
            },
          ),
        ],
      );
    },
  );
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
