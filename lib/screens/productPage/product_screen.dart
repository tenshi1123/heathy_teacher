import 'package:heathy_teacher/utils/apple_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/home_model.dart';
import 'package:heathy_teacher/screens/homePage/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/repo/course_repo.dart';
import 'package:heathy_teacher/screens/productPage/detail_product_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_home_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.type, required this.userModel});
  final int type;
  final UserModel userModel;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late int currentPage = 1;
  bool isLoading = true;
  List<ProductModel> products = [];
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    products = await CourseRepo().getListProduct();

    setState(() {
      isLoading = false;
    });
  }

  // Hàm hỗ trợ format tiền (VD: 399000 -> 399.000)
  String formatPrice(String? priceString) {
    if (priceString == null || priceString.isEmpty) return '0';
    try {
      final int price = int.parse(priceString);
      return NumberFormat.decimalPattern('vi').format(price);
    } catch (e) {
      return priceString; // Nếu lỗi parse thì trả về chuỗi gốc
    }
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    // Đảm bảo endIndex không vượt quá độ dài thực tế của mảng
    if (endIndex > products.length) {
      endIndex = products.length;
    }

    // 3. Tạo mảng con chỉ chứa các sản phẩm của trang hiện tại
    List<ProductModel> displayedProducts = [];
    if (products.isNotEmpty && startIndex < products.length) {
      displayedProducts = products.sublist(startIndex, endIndex);
    }
    return Scaffold(
      backgroundColor: mainDarkGreen,
      drawer: MyCustomDrawer(userModel: widget.userModel, selectedIndex: 0),
      // endDrawer: const FilterMenuDrawer(), // Tạm comment nếu bạn chưa dùng
      appBar: AppBar(
        backgroundColor: mainDarkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Nguyên liệu máy đã mua',
          style: defaultText18B.copyWith(color: Colors.white),
        ),
        leading: widget.type == 1
            ? Builder(
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
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        // actions: [
        //   Builder(
        //     builder: (BuildContext innerContext) {
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
        child: isLoading
            // 1. HIỂN THỊ LOADING KHI ĐANG GỌI API
            ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            'Danh sách sản phẩm/khóa học'.sanitizeForApple,
                            style: defaultText16B,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // 2. NẾU KHÔNG CÓ DỮ LIỆU THÌ HIỂN THỊ THÔNG BÁO
                        products.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.h),
                                  child: Text(
                                    'Chưa có sản phẩm nào.',
                                    style: defaultText14SB,
                                  ),
                                ),
                              )
                            // 3. RENDER DANH SÁCH TỪ API
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  bottom: 20.w,
                                ),
                                physics: const ClampingScrollPhysics(),
                                itemCount: displayedProducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // Lấy ra sản phẩm tại vị trí index
                                  final product = displayedProducts[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          // Bạn có thể truyền product vào DetailProductScreen để hiển thị chi tiết
                                          builder: ((context) =>
                                              DetailProductScreen()),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 343.w,
                                      margin: EdgeInsets.only(bottom: 16.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xff062905,
                                            ).withValues(alpha: 0.16),
                                            spreadRadius: 0,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // THAY ẢNH CỨNG BẰNG ẢNH MẠNG (TỪ API)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  product.detail?[0].img ??
                                                  'https://lms.cogiaohealthy.vn/${product.img}',
                                              height: 90.h,
                                              width: 90
                                                  .w, // Nên set cứng width để UI không bị vỡ nếu ảnh lỗi
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) {
                                                // Hiển thị icon mặc định nếu link ảnh lỗi hoặc null
                                                return Container(
                                                  height: 90.h,
                                                  width: 90.w,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            // Dùng Expanded thay vì SizedBox fix width để UI linh hoạt hơn
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start, // Căn trái text
                                              children: [
                                                Row(
                                                  children: [
                                                    RatingStars(
                                                      rating:
                                                          5.0, // Tạm fix vì JSON của bạn chưa có trường rating
                                                      starSize: 16.r,
                                                    ),
                                                    Text(
                                                      '(5,0)',
                                                      style: defaultText14SB
                                                          .copyWith(
                                                            fontSize: 12.sp,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ), // Thêm khoảng cách nhỏ cho thoáng
                                                // THAY TÊN SẢN PHẨM BẰNG DATA API
                                                Text(
                                                  product.detail?[0].name ??
                                                      ' Chưa cập nhật tên',
                                                  style: defaultText14SB,
                                                  maxLines:
                                                      2, // Giới hạn 2 dòng để không bị tràn UI
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                SizedBox(height: 8.h),
                                                if (isShow == 'true')
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // THAY GIÁ SẢN PHẨM BẰNG DATA API
                                                      Text(
                                                        '${NumberFormat.decimalPattern('vi_VN').format(int.tryParse(product.detail?[0].price ?? '0'))} VNĐ',
                                                        style: defaultText16B
                                                            .copyWith(
                                                              color:
                                                                  mainDarkGreen,
                                                            ), // Đổi màu giá để nổi bật
                                                      ),
                                                      // Giá gốc bị gạch ngang (Tạm ẩn nếu API không có giá khuyến mãi)
                                                      // Text(
                                                      //   '250.000đ',
                                                      //   style: defaultText12Re.copyWith(
                                                      //     decoration: TextDecoration.lineThrough,
                                                      //   ),
                                                      // ),
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
                        SizedBox(
                          height: 80.h,
                        ), // Tăng padding bottom để không bị che bởi thanh Pagination
                      ],
                    ),
                  ),

                  // Phần phân trang (Pagination) giữ nguyên
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: PaginationWidget(
                        currentPage: currentPage,
                        // THAY ĐỔI Ở ĐÂY: Dùng biến vừa tính toán
                        totalPages: (products.length / itemsPerPage).ceil() == 0
                            ? 1
                            : (products.length / itemsPerPage).ceil(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                            // Vì dữ liệu đã có sẵn trong list 'products',
                            // ta chỉ cần setState để UI tự render lại list con, không cần gọi lại API
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
