import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
