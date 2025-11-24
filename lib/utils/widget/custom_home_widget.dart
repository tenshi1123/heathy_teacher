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
              color: Colors.black.withValues(alpha: 0.15),
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
          _buildStars(color: emptyColor.withValues(alpha: 0.5)),
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

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPagination(),
    );
  }

  List<Widget> _buildPagination() {
    List<Widget> items = [];
    items.add(_navButton("«", currentPage > 1 ? 1 : null));
    items.add(_navButton("‹", currentPage > 1 ? currentPage - 1 : null));
    items.addAll(_buildPageNumbers());
    items.add(
      _navButton("›", currentPage < totalPages ? currentPage + 1 : null),
    );
    items.add(_navButton("»", currentPage < totalPages ? totalPages : null));
    return items;
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> widgets = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        widgets.add(_pageButton(i));
      }
      return widgets;
    }
    widgets.add(_pageButton(1));
    if (currentPage > 3) {
      widgets.add(_dots());
    } else {
      widgets.add(_pageButton(2));
    }
    if (currentPage > 2 && currentPage < totalPages - 1) {
      widgets.add(_pageButton(currentPage));
    }
    if (currentPage < totalPages - 2) {
      widgets.add(_dots());
    } else {
      widgets.add(_pageButton(totalPages - 1));
    }
    widgets.add(_pageButton(totalPages));
    return widgets;
  }

  Widget _dots() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text("...", style: TextStyle(fontSize: 16)),
    );
  }

  Widget _pageButton(int page) {
    final isActive = page == currentPage;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPageChanged(page),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _navButton(String label, int? goPage) {
    final isEnabled = goPage != null;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isEnabled ? () => onPageChanged(goPage) : null,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
    );
  }
}
