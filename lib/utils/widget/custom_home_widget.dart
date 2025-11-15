import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';

Widget dateTimeDisplayWidget() {
  final now = DateTime.now();
  final dateFormat = DateFormat("dd/MM/yyyy", "vi_VN");
  final timeFormat = DateFormat("hh:mm a", "vi_VN");
  const weekdays = {
    1: "Thứ 2",
    2: "Thứ 3",
    3: "Thứ 4",
    4: "Thứ 5",
    5: "Thứ 6",
    6: "Thứ 7",
    7: "Chủ nhật",
  };
  final weekday = weekdays[now.weekday] ?? "";
  final dateString = "$weekday, ${dateFormat.format(now)}";
  final timeString = timeFormat.format(now);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        dateString,
        style: defaultText12Re.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        width: 1,
        height: 18.h,
        color: Colors.white.withValues(alpha: 0.8), // vạch ngăn cách
      ),
      Text(
        timeString,
        style: defaultText12Re.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    ],
  );
}

class FloatingCartButton extends StatelessWidget {
  final VoidCallback onTap;
  const FloatingCartButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: mainOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color starColor;
  final Color emptyColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.starSize = 30,
    this.starColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });
  Widget _buildStars({required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(Icons.star, color: color, size: starSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = 5 * starSize;
    return SizedBox(
      width: fullWidth,
      height: starSize,
      child: Stack(
        children: <Widget>[
          _buildStars(color: emptyColor.withOpacity(0.5)),
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: rating / 5.0,
              child: _buildStars(color: starColor),
            ),
          ),
        ],
      ),
    );
  }
}
