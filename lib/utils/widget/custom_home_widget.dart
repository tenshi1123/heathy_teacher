import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/screens/homePage/list_class_off.dart';
import 'package:heathy_teacher/screens/splash/list_class_off_external.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:heathy_teacher/screens/listSanPham/list_sp.dart';
import 'package:heathy_teacher/screens/introduce_screen.dart';
import 'package:heathy_teacher/screens/listCourse/list_free_course.dart';

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
  final int? totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    this.totalPages,
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

    bool hasNext = totalPages == null ? true : currentPage < totalPages!;
    items.add(_navButton("›", hasNext ? currentPage + 1 : null));
    if (totalPages != null) {
      items.add(_navButton("»", hasNext ? totalPages : null));
    }
    return items;
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> widgets = [];
    if (totalPages == null) {
      if (currentPage == 1) {
        widgets.add(_pageButton(1));
        widgets.add(_pageButton(2));
        widgets.add(_dots());
      } else {
        widgets.add(_dots());
        widgets.add(_pageButton(currentPage));
        widgets.add(_pageButton(currentPage + 1));
        widgets.add(_dots());
      }
      return widgets;
    }

    if (totalPages! <= 5) {
      for (int i = 1; i <= totalPages!; i++) {
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
    if (currentPage > 2 && currentPage < totalPages! - 1) {
      widgets.add(_pageButton(currentPage));
    }
    if (currentPage < totalPages! - 2) {
      widgets.add(_dots());
    } else {
      widgets.add(_pageButton(totalPages! - 1));
    }
    widgets.add(_pageButton(totalPages!));
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

class CustomImageCarousel extends StatefulWidget {
  final double? height;
  const CustomImageCarousel({super.key, this.height});

  @override
  State<CustomImageCarousel> createState() => _CustomImageCarouselState();
}

class _CustomImageCarouselState extends State<CustomImageCarousel> {
  final List<Map<String, dynamic>> _productImages = [
    {
      'image': 'assets/images/home1.jpg',
      'screen': const ListClassOffExternal(),
    },
    {'image': 'assets/images/home2.jpg', 'screen': const IntroduceScreen()},
    {'image': 'assets/images/home3.jpg', 'screen': const ListFreeCourse()},
    {'image': 'assets/images/home4.jpg', 'screen': const ListSpScreen()},
  ];

  int _currentSlide = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentSlide < _productImages.length - 1) {
          _currentSlide++;
          _pageController.animateToPage(
            _currentSlide,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _currentSlide = 0;
          _pageController.animateToPage(
            _currentSlide,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: widget.height ?? 470.w,
          margin: EdgeInsets.symmetric(vertical: 16.h),
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _productImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: InkWell(
                      onTap: () {
                        final screen = _productImages[index]['screen'];
                        if (screen != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => screen as Widget),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          _productImages[index]['image'] as String,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _productImages.length,
            (index) => Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentSlide == index
                    ? mainDarkGreen
                    : Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
