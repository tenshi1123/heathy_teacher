import 'package:flutter/material.dart';
import 'package:heathy_teacher/models/product_model.dart';
import 'package:heathy_teacher/utils/widget/custom_widget.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<CartItem> courses = [
    CartItem(
      id: "1",
      name: "KHÓA HỌC DƯỠNG SINH THẢO MỘC ĐÔNG Y HIỆN ĐẠI",
      image: "assets/images/sp1.jpg",
      price: 16990000,
      isCourse: true,
    ),
  ];

  final List<CartItem> products = [
    CartItem(
      id: "2",
      name: "Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300G",
      image: "assets/images/sp2.jpg",
      price: 120960,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng của bạn")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CartSection(title: "Khóa học", items: courses),
            const SizedBox(height: 20),
            CartSection(title: "Nguyên liệu - Máy", items: products),
          ],
        ),
      ),
    );
  }
}
