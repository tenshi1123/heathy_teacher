import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/payment_model.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/repo/external_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:heathy_teacher/screens/drawer/chinh_sach_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/voucher_dialog.dart';
import 'package:heathy_teacher/screens/shoppingCart/address_selection_dialog.dart';
import 'package:heathy_teacher/repo/payment_repo.dart';
import 'package:heathy_teacher/repo/home_repo.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';

class OrderPaymentScreen extends StatefulWidget {
  const OrderPaymentScreen({super.key});

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isAgreed = true;
  bool _isUsePoint = false;
  PromoCodeModel? _selectedPromoCode;
  String? _selectedProvinceCode;
  String? _selectedDistrictCode;
  UserModel? _userModel;
  bool _isFirstCoursePurchase = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final isCourse = selectedCartItems.any((item) => item.isCourse);
      final futures = <Future>[HomeRepo().getUserProfile()];
      if (isCourse) {
        futures.add(CourseRepo().getCourse(show: 1));
      }

      final results = await Future.wait(futures);

      if (mounted) {
        setState(() {
          _userModel = results[0] as UserModel;
          _nameController.text = _userModel?.fullName ?? '';
          _phoneController.text = _userModel?.phone ?? '';

          if (isCourse) {
            final myCourses = results[1] as List;
            if (myCourses.isEmpty) {
              _isFirstCoursePurchase = true;
            }
          }
        });
      }
    } catch (e) {
      // ignore
    }
  }

  int get userPoints {
    if (_userModel == null) return 0;
    return int.tryParse(_userModel!.accumulatedPoint ?? '0') ?? 0;
  }

  int get maxApplicablePoints {
    int maxCanUse = totalPrice - discountValue + shippingFee;
    if (maxCanUse < 0) maxCanUse = 0;
    return userPoints > maxCanUse ? maxCanUse : userPoints;
  }

  void _showVoucherDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: mainDarkGreen)),
    );
    try {
      final userModel = await HomeRepo().getUserProfile();
      int memberRankingValue = 1; // Default
      if (userModel.memberRanking != null) {
        final ranking = userModel.memberRanking!.toLowerCase();
        if (ranking.contains('kim cương')) {
          memberRankingValue = 3;
        } else if (ranking.contains('vàng')) {
          memberRankingValue = 2;
        } else if (ranking.contains('bạc')) {
          memberRankingValue = 1;
        }
      }

      final promos = await PaymentRepo().getListPromoCode(
        type: selectedCartItems.any((item) => item.isCourse)
            ? "course"
            : "product",
        memberRanking: memberRankingValue,
        totalPrice: totalPrice,
      );
      if (!context.mounted) return;
      Navigator.pop(context); // close loading

      final result = await showDialog<dynamic>(
        context: context,
        builder: (context) => VoucherDialog(
          vouchers: promos,
          selectedVoucher: _selectedPromoCode,
        ),
      );

      if (result == 'clear') {
        setState(() {
          _selectedPromoCode = null;
        });
      } else if (result is PromoCodeModel) {
        setState(() {
          _selectedPromoCode = result;
        });
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  int get discountValue {
    int applicableTotal = 0;
    bool hasCourse = selectedCartItems.any((item) => item.isCourse);

    if (hasCourse) {
      for (var item in selectedCartItems) {
        if (item.isOnlineCourse) {
          applicableTotal += item.price * item.quantity;
        }
      }
    } else {
      applicableTotal = totalPrice;
    }

    if (_selectedPromoCode == null) {
      if (_isFirstCoursePurchase && applicableTotal > 0) {
        return (applicableTotal * 0.1).round();
      }
      return 0;
    }
    int percent = int.tryParse(_selectedPromoCode!.valuePercent ?? '0') ?? 0;
    int maxUse = int.tryParse(_selectedPromoCode!.priceMaxUse ?? '0') ?? 0;

    int discount = (applicableTotal * percent / 100).round();
    if (maxUse > 0 && discount > maxUse) {
      discount = maxUse;
    }
    return discount;
  }

  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: 343.w,
      height: 48.h,
      margin: EdgeInsets.only(right: 12.w, bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: defaultText14B,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: colorText.withValues(alpha: 0.4)),
        ),
      ),
    );
  }

  List<CartItem> get selectedCartItems =>
      globalListCart.where((item) => item.isSelected ?? true).toList();

  int get totalPrice {
    int total = 0;
    for (var item in selectedCartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int get accumulatedPoints {
    double finalAmount =
        (totalPrice - discountValue - (_isUsePoint ? maxApplicablePoints : 0))
            .toDouble();
    if (finalAmount < 0) finalAmount = 0;

    double ratio = totalPrice > 0 ? finalAmount / totalPrice : 0.0;

    double points = 0;
    for (var item in selectedCartItems) {
      double itemFinalPrice = (item.price * item.quantity) * ratio;
      if (item.isCourse) {
        points += itemFinalPrice * 0.02;
      } else {
        points += itemFinalPrice * 0.005;
      }
    }
    return points.round();
  }

  int get shippingFee {
    if (totalPrice > 2000000) return 0;
    if (selectedCartItems.any((item) => item.isCourse)) return 0;
    if (selectedCartItems.any((item) => item.name.toLowerCase().contains('máy'))) return 0;

    final province = _provinceController.text.trim().toLowerCase();
    if (province.isEmpty) return 0;

    bool isHanoi = province.contains('hà nội') || province.contains('ha noi');

    if (totalPrice >= 1000000 && totalPrice <= 2000000) {
      return isHanoi ? 20000 : 40000;
    }
    
    return isHanoi ? 40000 : 50000;
  }

  @override
  Widget build(BuildContext context) {
    bool isCourse = selectedCartItems.any((e) => e.isCourse);
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Thanh toán đơn hàng',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Text('Điền thông tin của bạn', style: defaultText16B),
                  _buildInputField(
                    hintText: 'Họ và tên*',
                    controller: _nameController,
                  ),
                  _buildInputField(
                    hintText: 'Số điện thoại*',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  if (!isCourse) ...[
                    GestureDetector(
                      onTap: () async {
                        final res = await AddressSelectionDialog.show(
                          context,
                          'province',
                        );
                        if (res != null) {
                          setState(() {
                            _provinceController.text = res['name'];
                            _selectedProvinceCode = res['code'].toString();
                            _districtController.text = '';
                            _selectedDistrictCode = null;
                            _wardController.text = '';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: 'Tỉnh/Thành phố*',
                          controller: _provinceController,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final res = await AddressSelectionDialog.show(
                          context,
                          'district',
                          parentCode: _selectedProvinceCode,
                        );
                        if (res != null) {
                          setState(() {
                            _districtController.text = res['name'];
                            _selectedDistrictCode = res['code'].toString();
                            _wardController.text = '';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: 'Quận/Huyện*',
                          controller: _districtController,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final res = await AddressSelectionDialog.show(
                          context,
                          'ward',
                          parentCode: _selectedDistrictCode,
                        );
                        if (res != null) {
                          setState(() {
                            _wardController.text = res['name'];
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: 'Xã/Phường*',
                          controller: _wardController,
                        ),
                      ),
                    ),
                    CustomTextField(
                      hintText: 'Địa chỉ cụ thể*',
                      controller: _addressController,
                    ),
                  ],
                  SizedBox(height: 24.h),
                  Text('Thông tin đơn hàng', style: defaultText16B),
                  ...selectedCartItems.map((item) {
                    return Container(
                      height: 106.h,
                      width: 343.w,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Slidable(
                        key: ValueKey(item.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                setState(() {
                                  globalListCart.remove(item);
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r),
                              ),
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: item.image.startsWith('http')
                                  ? NetworkImage(item.image)
                                  : AssetImage(item.image) as ImageProvider,
                              height: 90.h,
                              width: 90.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 217.w,
                                  child: Text(
                                    item.name,
                                    style: defaultText14SB,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 200.w,
                                  child: QuantityCounter(
                                    price: item.price,
                                    quantity: item.quantity,
                                    onChanged: (value) {
                                      setState(() {
                                        item.quantity = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16.h),
                    child: CustomDotLine(
                      dotSize: 6.w,
                      spacing: 6.w,
                      color: colorText.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showVoucherDialog,
                          child: Container(
                            height: 48.h,
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedPromoCode != null
                                  ? (_selectedPromoCode!.code ??
                                        'Đã chọn voucher')
                                  : 'Mã Giảm giá',
                              style: _selectedPromoCode != null
                                  ? defaultText14B.copyWith(
                                      color: mainDarkGreen,
                                    )
                                  : defaultText14Re,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showVoucherDialog,
                        child: Container(
                          width: 120.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: mainGreen,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: mainDarkGreen.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Áp dụng',
                              style: defaultText16B.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 16.h),
                    child: CustomDotLine(
                      dotSize: 6.w,
                      spacing: 6.w,
                      color: colorText.withValues(alpha: 0.4),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền hàng:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                        style: defaultText20B.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Giảm giá:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '-${NumberFormat('#,###', 'vi_VN').format(discountValue)}đ',
                        style: defaultText20B.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  if (!isCourse && shippingFee > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phí vận chuyển:',
                          style: defaultText14SB.copyWith(fontSize: 16.sp),
                        ),
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(shippingFee)} đ',
                          style: defaultText20B.copyWith(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  if (_isUsePoint)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sử dụng điểm:',
                          style: defaultText14SB.copyWith(fontSize: 16.sp),
                        ),
                        Text(
                          '-${NumberFormat('#,###', 'vi_VN').format(maxApplicablePoints)} đ',
                          style: defaultText20B.copyWith(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng hoá đơn:',
                        style: defaultText14SB.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(totalPrice - discountValue + shippingFee - (_isUsePoint ? maxApplicablePoints : 0))} đ',
                        style: defaultText20B.copyWith(
                          fontSize: 24.sp,
                          color: mainDarkGreen,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: RichText(
                      text: TextSpan(
                        style: defaultText14M.copyWith(
                          color: Colors.black87,
                          fontSize: 16.sp,
                        ),
                        children: [
                          const TextSpan(text: 'Đặt hàng để nhận '),
                          TextSpan(
                            text: NumberFormat(
                              '#,###',
                              'vi_VN',
                            ).format(accumulatedPoints),
                            style: defaultText14B.copyWith(
                              color: const Color(0xFFF26522),
                              fontSize: 16.sp,
                            ),
                          ),
                          const TextSpan(text: ' điểm'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (userPoints > 0)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUsePoint = !_isUsePoint;
                              });
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isUsePoint
                                    ? const Color(0xFFF26522)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _isUsePoint
                                      ? const Color(0xFFF26522)
                                      : Colors.grey,
                                ),
                              ),
                              child: _isUsePoint
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.w,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: defaultText14M.copyWith(
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: 'Sử dụng '),
                                  TextSpan(
                                    text:
                                        '${NumberFormat('#,###', 'vi_VN').format(maxApplicablePoints)} điểm',
                                    style: defaultText14B.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const TextSpan(text: ' tích lũy'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAgreed = !_isAgreed;
                          });
                        },
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isAgreed
                                ? const Color(0xFFF26522)
                                : Colors.transparent,
                            border: Border.all(
                              color: _isAgreed
                                  ? const Color(0xFFF26522)
                                  : Colors.grey,
                            ),
                          ),
                          child: _isAgreed
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.w,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: defaultText14M.copyWith(
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(text: 'Đồng ý với '),
                              TextSpan(
                                text: 'chính sách',
                                style: defaultText14M.copyWith(
                                  color: mainDarkGreen,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChinhSachScreen(),
                                      ),
                                    );
                                  },
                              ),
                              const TextSpan(text: ' của Cô Giáo Healthy'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 98.h,
                width: 375.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (!_isAgreed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng đồng ý với chính sách của chúng tôi',
                          ),
                        ),
                      );
                      return;
                    }

                    if (_nameController.text.trim().isEmpty ||
                        _phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng điền họ và tên và số điện thoại',
                          ),
                        ),
                      );
                      return;
                    }

                    bool hasCourse = selectedCartItems.any(
                      (element) => element.isCourse == true,
                    );
                    bool hasProduct = selectedCartItems.any(
                      (element) => element.isCourse == false,
                    );

                    if (hasCourse && hasProduct) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng thanh toán khóa học và nguyên liệu máy riêng biệt',
                          ),
                        ),
                      );
                      return;
                    }

                    if (!hasCourse) {
                      if (_selectedProvinceCode == null ||
                          _selectedDistrictCode == null ||
                          _wardController.text.trim().isEmpty ||
                          _addressController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Vui lòng điền đầy đủ thông tin địa chỉ giao hàng',
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final payload = {
                        "full_name": _nameController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "promo_code": _selectedPromoCode?.code ?? "",
                        "payment_method_id": 1,
                        if (_selectedPromoCode == null)
                          "price_promo_code_online": discountValue,
                        "free_ship": shippingFee,
                        "accumulate_point": _isUsePoint
                            ? maxApplicablePoints
                            : 0,
                        "province": _provinceController.text.trim(),
                        "district": _districtController.text.trim(),
                        "ward": _wardController.text.trim(),
                        "address": _addressController.text.trim(),
                        "cart": selectedCartItems
                            .map(
                              (item) => hasCourse
                                  ? {
                                      "course_type_id": int.parse(
                                        item.courseTypeId ?? '',
                                      ),
                                      "quantity": item.quantity,
                                    }
                                  : {
                                      "product_id": int.parse(item.id),
                                      "quantity": item.quantity,
                                    },
                            )
                            .toList(),
                      };
                      //get remember_me_token
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final String? token = prefs.getString('remember_token');
                      final payCode = hasCourse
                          ? await ExternalRepo().paymentCourse(payload, token)
                          : await ExternalRepo().paymentProduct(payload, token);

                      final String customerId =
                          '${DateTime.now().millisecondsSinceEpoch}${math.Random().nextInt(9999).toString().padLeft(4, '0')}';
                      await prefs.setString('customer_id', customerId);

                      String addInfo =
                          '${payCode.payCode} W$customerId ${payCode.isLogin ?? ''}';
                      if (payCode.courseScheduleId != null &&
                          payCode.courseScheduleId.toString().isNotEmpty) {
                        addInfo += ' C${payCode.courseScheduleId}';
                      }

                      Navigator.pop(context); // close loading dialog

                      // If we want to show dynamic QR code, we could use payCode here,
                      // but for now keeping the existing UI logic
                      if (!context.mounted) return;
                      ScreenshotController screenshotController =
                          ScreenshotController();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Screenshot(
                                    controller: screenshotController,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Quét mã QR để thanh toán',
                                            style: defaultText18B.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Image.network(
                                            'https://img.vietqr.io/image/${payCode.bankCode}-${payCode.bankAccount}-compact2.png?amount=${payCode.price}&addInfo=${Uri.encodeComponent(addInfo.trim())}',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              WidgetsBinding.instance.addPostFrameCallback((
                                                _,
                                              ) {
                                                if (context.mounted) {
                                                  Navigator.pop(
                                                    context,
                                                  ); // Đóng dialog QR hiện tại
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text(
                                                        'Lỗi',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: const Text(
                                                        'Không thể tạo mã QR thanh toán lúc này. Vui lòng thử lại sau!',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child: Text(
                                                            'Đóng',
                                                            style: TextStyle(
                                                              color:
                                                                  mainDarkGreen,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              });
                                              return const SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 48,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainDarkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Đóng',
                                          style: defaultText16B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            final image =
                                                await screenshotController
                                                    .capture(
                                                      delay: const Duration(
                                                        milliseconds: 10,
                                                      ),
                                                    );
                                            if (image != null) {
                                              final result =
                                                  await ImageGallerySaverPlus.saveImage(
                                                    image,
                                                  );
                                              if (result['isSuccess'] == true &&
                                                  context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Lưu ảnh QR thành công!',
                                                    ),
                                                  ),
                                                );
                                              } else if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Không thể lưu ảnh QR',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Lỗi khi lưu ảnh: `e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainDarkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Tải QR',
                                          style: defaultText16B.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      Navigator.pop(context); // close loading dialog
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                    }
                  },
                  child: Container(
                    width: 343.w,
                    height: 50.h,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      bottom: 30.h,
                      top: 16.w,
                      right: 16.w,
                    ),
                    constraints: BoxConstraints(maxHeight: 120.h),
                    decoration: BoxDecoration(
                      color: mainDarkGreen,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    child: Center(
                      child: Text(
                        "Xác nhận thanh toán",
                        style: defaultText16B.copyWith(color: Colors.white),
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
  }
}
