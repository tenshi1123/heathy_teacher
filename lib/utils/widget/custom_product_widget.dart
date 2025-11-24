// 1. Data Model (Giữ nguyên như trước)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';

class FilterMenuDrawer extends StatefulWidget {
  const FilterMenuDrawer({super.key});
  @override
  State<FilterMenuDrawer> createState() => _FilterMenuDrawerState();
}

class _FilterMenuDrawerState extends State<FilterMenuDrawer> {
  final List<Item> _data = [
    Item(
      headerText: 'NGUYÊN LIỆU LỚP NẤU ĂN CƠ BẢN',
      bodyText: [
        'NGUYÊN LIỆU NẤU ĂN',
        'CÁC NGUYÊN LIỆU TRONG BẾP GIA ĐÌNH NÀO CŨNG CẦN CÓ',
        'NGUYÊN LIỆU CÁC MÓN CHAY VIỆT HIỆN ĐẠI',
      ],
      isExpanded: true,
    ),
    // ... Thêm các Item khác ở đây ...
    Item(
      headerText: 'NGUYÊN LIỆU LỚP NẤU ĂN NÂNG CAO',
      bodyText: ['Nguyên liệu cho món Tây', 'Nguyên liệu đặc biệt'],
    ),
    Item(
      headerText: 'WORKSHOP BỮA SÁNG GIÀU CHẤT XƠ',
      bodyText: ['Bột yến mạch', 'Hạt chia'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sử dụng Drawer cho chức năng trượt từ cạnh ra
    return Drawer(
      // Để tái tạo giao diện bo góc/nền trắng, hãy dùng Container
      child: Container(
        padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thêm tiêu đề nếu cần thiết (ví dụ: 'Bộ lọc sản phẩm')
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'DANH MỤC SẢN PHẨM',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Widget ExpansionPanelList của bạn
              ExpansionPanelList(
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,

                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    backgroundColor: Colors.white,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        // Thêm Icon Xóa/Cộng (+/-) tùy chỉnh ở đây
                        trailing: Icon(
                          isExpanded
                              ? Icons.remove_circle_outline
                              : Icons.add_circle_outline,
                          color: Colors.green, // Màu của icon
                        ),
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
                    canTapOnHeader: true, // Cho phép bấm vào tiêu đề để mở/đóng
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantityCounter extends StatefulWidget {
  const QuantityCounter({
    super.key,
    required this.price,
    required this.quantity,
    required this.onChanged, // 👈 thêm callback
  });

  final int price;
  final int quantity;
  final Function(int quantity) onChanged; // 👈 trả quantity ra ngoài

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int _quantity;
  final int _minQuantity = 1;
  final int _maxQuantity = 10;
  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity = widget.quantity;
      if (_quantity < _maxQuantity) {
        _quantity++;
        widget.onChanged(_quantity);
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > _minQuantity) {
        _quantity--;
        widget.onChanged(_quantity);
      }
    });
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
    required int type,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: type == 1 ? Colors.white : mainDarkGreen,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: isEnabled ? mainDarkGreen : Colors.grey.shade400, // Màu viền
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 20.r,
          color: type == 2 ? Colors.white : mainDarkGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 1. Text "Số lượng:"
        Text(
          '${NumberFormat('#,###', 'vi_VN').format(widget.price)} đ',
          style: defaultText14SB.copyWith(fontSize: 16.sp),
        ),
        Spacer(),
        // 2. Nút Trừ (-)
        _buildControlButton(
          icon: Icons.remove,
          onTap: _decrementQuantity,
          isEnabled: _quantity > _minQuantity,
          type: 1,
        ),
        SizedBox(width: 16.w),
        Text('$_quantity', style: defaultText14SB.copyWith(fontSize: 16.sp)),
        SizedBox(width: 16.w),
        _buildControlButton(
          icon: Icons.add,
          onTap: _incrementQuantity,
          isEnabled: _quantity < _maxQuantity,
          type: 2,
        ),
      ],
    );
  }
}
