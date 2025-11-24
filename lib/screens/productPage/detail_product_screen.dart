import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';

class DetailProductScreen extends StatefulWidget {
  DetailProductScreen({super.key});
  final List<String> images = [
    'assets/images/material1.png',
    'assets/images/material2.png',
    'assets/images/material3.png',
  ];
  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController _tabController;
  int activeTabIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        activeTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chi tiết sản phẩm',
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 343.w,
                height: 240.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(widget.images[selectedIndex]),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 1,
                      child: ListView.separated(
                        itemCount: widget.images.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedIndex;
                          return GestureDetector(
                            onTap: () => setState(() => selectedIndex = index),
                            child: Container(
                              padding: EdgeInsets.all(isSelected ? 4 : 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.yellow.shade600
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(widget.images[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  RatingStars(
                    rating: 4.6, // Hiển thị 4.5 sao
                    starSize: 16.r,
                  ),
                  Text(
                    '(4,6)',
                    style: defaultText14SB.copyWith(fontSize: 12.sp),
                  ),
                  Text(
                    ' • Tên thương hiệu',
                    style: defaultText14SB.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300g',
                style: defaultText18B,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '128.000đ',
                    style: defaultText20B.copyWith(
                      fontSize: 24.sp,
                      color: mainDarkGreen,
                    ),
                  ),
                  Text(
                    '250.000đ',
                    style: defaultText14Re.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(' • Tiết kiệm: 121.480đ', style: defaultText14SB),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: SizedBox(
                  width: 181.w,
                  child: QuantityCounter(
                    price: 128000,
                    quantity: 1,
                    onChanged: (int quantity) {},
                  ),
                ),
              ),
              _overviewItem(label: 'Hàng CHÍNH HÃNG 100%, có tem phụ'),
              _overviewItem(label: 'Chính sách ưu đãi cho HỌC VIÊN hấp dẫn'),
              _overviewItem(label: 'Giao hàng TOÀN QUỐC, MIỄN PHÍ vận chuyển'),
              _overviewItem(label: 'Liên hệ nhận GIÁ SỈ tốt nhất'),
              SizedBox(height: 28.h),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 48.h,
                  width: 340.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
                    border: Border.all(color: mainDarkGreen, width: 1.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/gio_hang.png'),
                      Text(
                        '  Thêm vào giỏ hàng',
                        textAlign: TextAlign.center,
                        style: defaultText16B.copyWith(color: mainDarkGreen),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 48.h,
                  width: 343.w,
                  margin: EdgeInsets.only(bottom: 28.h, top: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: mainDarkGreen,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/lingting.png'),
                      Text(
                        '  Mua ngay',
                        textAlign: TextAlign.center,
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50.h,
                width: 375.w,
                margin: EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  color: Color(0xffEFEFEF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: TabBar.secondary(
                  padding: EdgeInsets.zero,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 4,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xff292929).withAlpha(84),
                  tabs: [
                    Tab(text: "Mô tả sản phẩm"),
                    Tab(text: "Thông số sản phẩm"),
                  ],
                ),
              ),
              IndexedStack(
                index: _tabController.index,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\nMô tả sản phẩm\n', style: defaultText14B),
                        Text(
                          ' • Tên sản phẩm: Đường hoa dừa hữu cơ Sokfarm 300g\n • Nguyên liệu: 100% đường hoa dừa hữu cơ - Việt Nam\n •  Mô tả: Đường hoa dừa hữu cơ Sokfarm là vị ngọt mới từ hoa dừa, sản phẩm được thu thủ công bằng kỹ thuật mát-xa hoa dừa và thu mật truyền thống của người Khmer Trà Vinh, ứng dụng công nghệ chế biến ở nhiệt độ thấp. Đường hoa dừa nguyên chất 100%, giàu dinh dưỡng và khoáng chất tự nhiên, đặc biệt đây là đường hấp thu chậm tốt cho sức khoẻ, cả gia đình an tâm sử dụng.',
                          style: defaultText14Re,
                        ),
                        SizedBox(height: 8.h),
                        Image.asset(
                          'assets/images/rice.png',
                          width: 343.w,
                          height: 200.h,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  Container(
                    width: 343.w,
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _overviewItem({required String label}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        'assets/images/tick_icon.png',
        width: 16.w,
        height: 16.h,
        fit: BoxFit.fill,
      ),
      SizedBox(width: 8.w),
      SizedBox(
        width: 310.w,
        child: Text(
          label,
          style: defaultText14SB.copyWith(
            color: colorText.withValues(alpha: 0.8),
          ),
        ),
      ),
    ],
  );
}
