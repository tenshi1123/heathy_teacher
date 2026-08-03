import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:heathy_teacher/models/course_model.dart';
import 'package:heathy_teacher/models/product_model.dart';

// Biến toàn cục lưu danh sách khoá học
List<CourseModel> globalListCourse = [];
List<CourseModel> globalListFreeCourse = [];
List<CourseOffModel> globalListCourseOff = [];

class CartList extends ListBase<CartItem> {
  final List<CartItem> _inner = [];
  final ValueNotifier<int> lengthNotifier = ValueNotifier<int>(0);

  @override
  int get length => _inner.length;

  @override
  set length(int newLength) {
    _inner.length = newLength;
    lengthNotifier.value = _inner.length;
  }

  @override
  CartItem operator [](int index) => _inner[index];

  @override
  void operator []=(int index, CartItem value) {
    _inner[index] = value;
  }

  @override
  void add(CartItem element) {
    _inner.add(element);
    lengthNotifier.value = _inner.length;
  }

  @override
  bool remove(Object? element) {
    bool result = _inner.remove(element);
    if (result) lengthNotifier.value = _inner.length;
    return result;
  }

  @override
  void clear() {
    _inner.clear();
    lengthNotifier.value = 0;
  }
}

// Biến toàn cục lưu giỏ hàng
final CartList globalListCart = CartList();
