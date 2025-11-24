import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.type});
  final int type;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late int currentPage = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDarkGreen,
      endDrawer: const FilterMenuDrawer(),
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sản phẩm',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: widget.type == 1
            ? SizedBox()
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          Builder(
            builder: (BuildContext innerContext) {
              return GestureDetector(
                // SỬ DỤNG innerContext MỚI TỪ BUILDER
                onTap: () {
                  // Lệnh này tìm kiếm Scaffold gần nhất và mở EndDrawer
                  Scaffold.of(innerContext).openEndDrawer();
                },
                child: SvgPicture.asset(
                  'assets/icons/menu_icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 16.w),
        ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      'Nguyên liệu lớp nấu ăn chay',
                      style: defaultText16B,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 20.w,
                    ),
                    physics: const ClampingScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => DetailProductScreen()),
                            ),
                          );
                        },
                        child: Container(
                          width: 343.w,
                          //height: 106.h,
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  0xff062905,
                                ).withValues(alpha: 0.16),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(
                                  0,
                                  4,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/material1.png',
                                height: 90.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 12.w),
                              SizedBox(
                                width: 217.w,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        RatingStars(
                                          rating: 4.6, // Hiển thị 4.5 sao
                                          starSize: 16.r,
                                        ),
                                        Text(
                                          '(4,6)',
                                          style: defaultText14SB.copyWith(
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300g',
                                      style: defaultText14SB,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('128.000đ', style: defaultText16B),
                                        Text(
                                          '250.000đ',
                                          style: defaultText12Re.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 52.h),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 60.h,
                width: 375.w,
                padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                decoration: BoxDecoration(color: Colors.white),
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalPages: 6,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Item> _data = [
  Item(
    headerText: 'NGUYÊN LIỆU LỚP NẤU ĂN CƠ BẢN',
    bodyText: [
      'NGUYÊN LIỆU NẤU ĂN',
      'CÁC NGUYÊN LIỆU TRONG BẾP GIA ĐÌNH NÀO CŨNG CẦN CÓ',
      'NGUYÊN LIỆU CÁC MÓN CHAY VIỆT HIỆN ĐẠI',
    ],
    isExpanded: true, // Mục này đang mở trong hình
  ),
  Item(
    headerText: 'NGUYÊN LIỆU LỚP NẤU ĂN NÂNG CAO',
    bodyText: ['Nguyên liệu cho món Tây', 'Nguyên liệu đặc biệt'],
  ),
  Item(
    headerText: 'NGUYÊN LIỆU LỚP NẤU ĂN CHAY',
    bodyText: ['Thực phẩm chay khô', 'Thực phẩm chay tươi'],
  ),
  Item(
    headerText: 'NGUYÊN LIỆU WORKSHOP SỮA HẠT VÀ KẸO DẺO TRÁI CÂY',
    bodyText: ['Các loại hạt', 'Trái cây sấy'],
  ),
  Item(
    headerText: 'WORKSHOP BỮA SÁNG GIÀU CHẤT XƠ',
    bodyText: ['Bột yến mạch', 'Hạt chia'],
  ),
];

class CategoryMenu extends StatefulWidget {
  const CategoryMenu({super.key});

  @override
  State<CategoryMenu> createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  // Hàm này nên được đặt trong State của Widget
  @override
  void initState() {
    super.initState();
    // Khởi tạo _data (Lưu ý: Bạn nên đưa nó vào State hoặc Provider)
    _data[0].isExpanded = true;
  }

  @override
  Widget build(BuildContext context) {
    // Để tái tạo giao diện thẻ bo tròn và màu nền trắng
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      // Bọc trong SingleChildScrollView để có thể cuộn nếu danh sách dài
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          // Loại bỏ đường gạch mặc định giữa các panel
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent, // Không có đường phân cách
          // Xử lý khi người dùng bấm vào tiêu đề
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              // Đóng/mở panel khi bấm vào
              _data[index].isExpanded = !isExpanded;
            });
          },

          // Xây dựng danh sách các ExpansionPanel
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              backgroundColor: Colors.white,
              // Tiêu đề của mục
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.headerText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                );
              },

              // Nội dung xổ ra (các mục con)
              body: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item.bodyText.map((text) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              isExpanded: item.isExpanded,

              // Tùy chỉnh icon mở/đóng (Sử dụng Icon + hoặc Icon -)
              canTapOnHeader: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
