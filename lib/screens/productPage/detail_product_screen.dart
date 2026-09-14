import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:heathy_teacher/utils/widget/custom_product_widget.dart';
import 'package:heathy_teacher/main.dart';
import 'package:heathy_teacher/repo/product_repo.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/utils/global_data.dart';
import 'package:heathy_teacher/screens/shoppingCart/order_payment_screen.dart';
import 'package:heathy_teacher/screens/shoppingCart/shopping_cart_screen.dart';

class DetailProductScreen extends StatefulWidget {
  final String productId;
  const DetailProductScreen({super.key, required this.productId});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen>
    with SingleTickerProviderStateMixin {
  int selectedQuantity = 1;
  late TabController _tabController;
  ProductDetailModel? productDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    try {
      final result = await ProductRepo().getDetailProduct(widget.productId);
      if (mounted) {
        setState(() {
          productDetail = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ShoppingCartScreen())),
              );
            },
            child: SizedBox(
              width: 40.dg,
              height: 40.dg,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 30.dg, // Giảm size Icon giỏ hàng một chút
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3), // Padding nhỏ hơn
                      decoration: BoxDecoration(
                        color: mainDarkGreen,
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
        child: RefreshIndicator(
          color: mainDarkGreen,
          onRefresh: _fetchProductDetail,
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: mainDarkGreen))
              : productDetail == null
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    alignment: Alignment.center,
                    child: Text(
                      'Không tìm thấy sản phẩm',
                      style: defaultText16M,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            memCacheWidth: 800,
                            imageUrl:
                                (productDetail!.img != null &&
                                    productDetail!.img!.startsWith('http'))
                                ? productDetail!.img!
                                : (productDetail!.img != null &&
                                          productDetail!.img!.isNotEmpty
                                      ? 'https://lms.cogiaohealthy.vn/${productDetail!.img!.startsWith('/') || productDetail!.img!.startsWith('images') ? (productDetail!.img!.startsWith('/') ? productDetail!.img!.substring(1) : productDetail!.img) : 'images/${productDetail!.img}'}'
                                      : ''),
                            width: 343.w,
                            height: 240.h,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(),
                      SizedBox(height: 6.h),
                      Text(
                        productDetail!.name ?? '',
                        style: defaultText18B.copyWith(color: mainDarkGreen),
                      ),
                      Text(
                        'Thương hiệu: ${productDetail?.brand == '' ? "Đang cập nhật" : productDetail?.brand}',
                      ),
                      if (isShow == 'true') ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${NumberFormat('#,###', 'vi_VN').format(productDetail!.priceInt)}đ',
                              style: defaultText20B.copyWith(
                                fontSize: 24.sp,
                                color: mainDarkGreen,
                              ),
                            ),
                            if (productDetail!.priceOld != '0' &&
                                productDetail!.priceOld != null &&
                                productDetail!.priceOld != '') ...[
                              Row(
                                children: [
                                  Text(
                                    '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(productDetail!.priceOld!) ?? 0)}đ',
                                    style: defaultText14Re.copyWith(
                                      fontSize: 10.sp,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      '• Tiết kiệm: ${NumberFormat('#,###', 'vi_VN').format((int.tryParse(productDetail!.priceOld!) ?? 0) - productDetail!.priceInt)}đ',
                                      style: defaultText14SB,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: SizedBox(
                            width: 181.w,
                            child: QuantityCounter(
                              price: productDetail!.priceInt,
                              quantity: selectedQuantity,
                              onChanged: (int quantity) {
                                setState(() {
                                  selectedQuantity = quantity;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                      _overviewItem(label: 'Hàng chính hãng 100%'),
                      _overviewItem(
                        label: 'Chính sách ưu đãi cho học viên hấp dẫn',
                      ),
                      _overviewItem(
                        label: 'Giao hàng toàn quốc, miễn phí vận chuyển',
                      ),
                      _overviewItem(label: 'Liên hệ nhận giá sỉ tốt nhất'),
                      SizedBox(height: 28.h),
                      if (isShow == 'true') ...[
                        InkWell(
                          onTap: () {
                            if (productDetail!.inventoryQuantity == '0' &&
                                productDetail!.allowShortSelling == '0')
                              return;

                            int existingIndex = globalListCart.indexWhere(
                              (element) => element.id == productDetail!.id,
                            );
                            if (existingIndex != -1) {
                              globalListCart[existingIndex].quantity +=
                                  selectedQuantity;
                            } else {
                              globalListCart.add(
                                CartItem(
                                  id: productDetail!.id ?? '',
                                  name: productDetail!.name ?? '',
                                  image: productDetail!.img ?? '',
                                  price: productDetail!.priceInt,
                                  isCourse: false,
                                  quantity: selectedQuantity,
                                ),
                              );
                            }
                            setState(() {});
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                    'Sản phẩm đã được thêm vào giỏ hàng của bạn.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 48.h,
                            width: 340.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color:
                                  productDetail!.inventoryQuantity == '0' &&
                                      productDetail!.allowShortSelling == '0'
                                  ? Colors.grey
                                  : Colors.white,
                              border: Border.all(
                                color:
                                    productDetail!.inventoryQuantity == '0' &&
                                        productDetail!.allowShortSelling == '0'
                                    ? Colors.grey
                                    : mainDarkGreen,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (productDetail!.inventoryQuantity != '0' ||
                                    productDetail!.allowShortSelling != '0')
                                  Image.asset('assets/images/gio_hang.png'),
                                Text(
                                  productDetail!.inventoryQuantity == '0' &&
                                          productDetail!.allowShortSelling ==
                                              '0'
                                      ? 'Hết hàng'
                                      : '  Thêm vào giỏ hàng',
                                  textAlign: TextAlign.center,
                                  style: defaultText16B.copyWith(
                                    color:
                                        productDetail!.inventoryQuantity ==
                                                '0' &&
                                            productDetail!.allowShortSelling ==
                                                '0'
                                        ? Colors.white
                                        : mainDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (productDetail!.inventoryQuantity == '0' &&
                                productDetail!.allowShortSelling == '0')
                              return;

                            globalListCart.clear();
                            globalListCart.add(
                              CartItem(
                                id: productDetail!.id ?? '',
                                name: productDetail!.name ?? '',
                                image: productDetail!.img ?? '',
                                price: productDetail!.priceInt,
                                isCourse: false,
                                quantity: selectedQuantity,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderPaymentScreen(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: Container(
                            height: 48.h,
                            width: 343.w,
                            margin: EdgeInsets.only(bottom: 28.h, top: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color:
                                  productDetail!.inventoryQuantity == '0' &&
                                      productDetail!.allowShortSelling == '0'
                                  ? Colors.grey
                                  : mainDarkGreen,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (productDetail!.inventoryQuantity != '0' ||
                                    productDetail!.allowShortSelling != '0')
                                  Image.asset('assets/images/lingting.png'),
                                Text(
                                  productDetail!.inventoryQuantity == '0' &&
                                          productDetail!.allowShortSelling ==
                                              '0'
                                      ? 'Hết hàng'
                                      : '  Mua ngay',
                                  textAlign: TextAlign.center,
                                  style: defaultText16B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                          unselectedLabelColor: const Color(
                            0xff292929,
                          ).withAlpha(84),
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
                                SizedBox(height: 16.h),
                                HtmlWidget(
                                  productDetail!.description ??
                                      'Đang cập nhật...',
                                  textStyle: defaultText14Re,
                                ),
                                const SizedBox(),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.h),
                                HtmlWidget(
                                  productDetail!.content ?? 'Đang cập nhật...',
                                  textStyle: defaultText14Re,
                                ),
                                const SizedBox(),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
