import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/product_model.dart';
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
