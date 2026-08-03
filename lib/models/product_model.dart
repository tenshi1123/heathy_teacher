import 'dart:convert';
import 'dart:ui';
import 'package:heathy_teacher/utils/apple_sanitizer.dart';

class Item {
  String headerText;
  List<String> bodyText;
  bool isExpanded;

  Item({
    required this.headerText,
    required this.bodyText,
    this.isExpanded = false,
  });
}

class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  int quantity;
  final bool isCourse;
  final bool isOnlineCourse;
  String? courseTypeId;
  bool? isSelected;
  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.isCourse = false,
    this.isOnlineCourse = false,
    this.courseTypeId,
    this.isSelected = true,
  });
}

class ServiceModel {
  final String title;
  final String icon;
  final VoidCallback onTap;

  ServiceModel({required this.title, required this.icon, required this.onTap});
}

// Hàm helper để parse chuỗi JSON tổng (nếu cần)
List<CourseSection> courseSectionFromJson(String str) =>
    List<CourseSection>.from(
      json.decode(str).map((x) => CourseSection.fromJson(x)),
    );

class CourseSection {
  final String? id;
  final String? name;
  final List<Lesson> lesson;

  CourseSection({this.id, this.name, required this.lesson});

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: json['id'],
      name: (json['name'] as String?).sanitizeForApple,
      // Kiểm tra nếu mảng lesson null thì trả về mảng rỗng
      lesson: json['lesson'] != null
          ? List<Lesson>.from(json['lesson'].map((x) => Lesson.fromJson(x)))
          : [],
    );
  }
}

class Lesson {
  final String? lessonsId;
  final String? name;
  final String? slug;
  final String? time;
  final String? isTrial;
  final String? documentFilesActive;
  final String? examActive;
  final String? locked;
  final String? lessonContent;
  final String? lessonType;
  final String? streamingUrl;
  final String? muxAssetId; // Trường này nhận giá trị null từ API

  Lesson({
    this.lessonsId,
    this.name,
    this.slug,
    this.time,
    this.isTrial,
    this.documentFilesActive,
    this.examActive,
    this.locked,
    this.lessonContent,
    this.lessonType,
    this.streamingUrl,
    this.muxAssetId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonsId: json['lessons_id'],
      name: (json['name'] as String?).sanitizeForApple,
      slug: json['slug'],
      time: json['time'],
      isTrial: json['is_trial'],
      documentFilesActive: json['document_files_active'],
      examActive: json['exam_active'],
      locked: json['locked'],
      lessonContent: (json['lesson_content'] as String?).sanitizeForApple,
      lessonType: json['lesson_type'],
      streamingUrl: json['streaming_url'],
      muxAssetId: json['mux_asset_id'] ?? '',
    );
  }
}

class ProductModel {
  String? wardName;
  String? districtName;
  String? provinceName;
  String? address;
  String? paymentMethodName;
  String? customerFullName;
  String? customerPhone;
  String? customerEmail;
  String? img;
  String? orderStatusName;
  String? promoCodeAmount;
  String? promoCode;
  String? orderId;
  String? cashDeduction;
  String? percent;
  String? valuePercent;
  String? freeShip;
  String? accumulatePoint;
  List<OrderDetail>? detail;

  ProductModel({
    this.wardName,
    this.districtName,
    this.provinceName,
    this.address,
    this.paymentMethodName,
    this.customerFullName,
    this.customerPhone,
    this.customerEmail,
    this.img,
    this.orderStatusName,
    this.promoCodeAmount,
    this.promoCode,
    this.orderId,
    this.cashDeduction,
    this.percent,
    this.valuePercent,
    this.freeShip,
    this.accumulatePoint,
    this.detail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      wardName: json['ward_name'],
      districtName: json['district_name'],
      provinceName: json['province_name'],
      address: json['address'],
      paymentMethodName: json['payment_method_name'],
      customerFullName: json['customer_full_name'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      img: json['img'],
      orderStatusName: json['order_status_name'],
      promoCodeAmount: json['promo_code_amount'],
      promoCode: json['promo_code'],
      orderId: json['order_id'],
      cashDeduction: json['cash_deduction'],
      percent: json['percent'],
      valuePercent: json['value_percent'],
      freeShip: json['free_ship'],
      accumulatePoint: json['accumulate_point'],
      detail: json['detail'] != null
          ? (json['detail'] as List)
                .map((i) => OrderDetail.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ward_name': wardName,
      'district_name': districtName,
      'province_name': provinceName,
      'address': address,
      'payment_method_name': paymentMethodName,
      'customer_full_name': customerFullName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'img': img,
      'order_status_name': orderStatusName,
      'promo_code_amount': promoCodeAmount,
      'promo_code': promoCode,
      'order_id': orderId,
      'cash_deduction': cashDeduction,
      'percent': percent,
      'value_percent': valuePercent,
      'free_ship': freeShip,
      'accumulate_point': accumulatePoint,
      'detail': detail?.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderDetail {
  String? name;
  String? productId;
  String? img;
  String? price;
  String? type;
  String? quantity;

  OrderDetail({
    this.name,
    this.productId,
    this.img,
    this.price,
    this.type,
    this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      name: json['name'] ?? json['course_type_name'],
      productId: json['product_id'] ?? json['course_type_id'],
      img: json['img'],
      price: json['price'],
      type: json['type'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product_id': productId,
      'img': img,
      'price': price,
      'type': type,
      'quantity': quantity,
    };
  }
}

class CategoryModel {
  final String? categoryName;
  final String? categorySlug;
  final String? img;
  final List<Topic>? topics;

  CategoryModel({this.categoryName, this.categorySlug, this.img, this.topics});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['category_name'] as String?,
      categorySlug: json['category_slug'] as String?,
      img: json['img'] as String?,
      topics: json['topics'] != null
          ? (json['topics'] as List).map((i) => Topic.fromJson(i)).toList()
          : [],
    );
  }
}

class Topic {
  final String? topicName;
  final String? topicSlug;

  Topic({this.topicName, this.topicSlug});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicName: json['topic_name'] as String?,
      topicSlug: json['topic_slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'topic_name': topicName, 'topic_slug': topicSlug};
  }
}

class CategoryDetail {
  final String? id;
  final String? productName;
  final String? slug;
  final String? img;
  final String? price;
  final String? priceOld;
  final String? variantName;
  final String? offersMonth;
  final String? inventoryQuantity;
  final String? allowShortSelling;

  CategoryDetail({
    this.id,
    this.productName,
    this.slug,
    this.img,
    this.price,
    this.priceOld,
    this.variantName,
    this.offersMonth,
    this.inventoryQuantity,
    this.allowShortSelling,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id'] as String?,
      productName: (json['product_name'] as String?).sanitizeForApple,
      slug: json['slug'] as String?,
      img: json['img'] as String?,
      price: json['price'] as String?,
      priceOld: json['price_old'] as String?,
      variantName: json['variant_name'] as String?,
      offersMonth: json['offers_month'] as String?,
      inventoryQuantity: json['inventory_quantity'] as String?,
      allowShortSelling: json['allow_short_selling'] as String?,
    );
  }
  int? get idInt => id != null ? int.tryParse(id!) : null;
}

class ProductDetailModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? img;
  final String? price;
  final String? priceOld;
  final String? description;
  final String? content;
  final String? inventoryQuantity;
  final String? allowShortSelling;

  ProductDetailModel({
    this.id,
    this.name,
    this.slug,
    this.img,
    this.price,
    this.priceOld,
    this.description,
    this.content,
    this.inventoryQuantity,
    this.allowShortSelling,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as String?,
      name: (json['name'] as String?).sanitizeForApple,
      slug: json['slug'] as String?,
      img: json['img'] as String?,
      price: json['price'] as String?,
      priceOld: json['price_old'] as String?,
      description: (json['description'] as String?).sanitizeForApple,
      content: (json['content'] as String?).sanitizeForApple,
      inventoryQuantity: json['inventory_quantity'] as String?,
      allowShortSelling: json['allow_short_selling'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'img': img,
      'price': price,
      'price_old': priceOld,
      'description': description,
      'inventory_quantity': inventoryQuantity,
    };
  }

  int get priceInt => int.tryParse(price ?? '0') ?? 0;

  int get priceOldInt => int.tryParse(priceOld ?? '0') ?? 0;

  int get stock => int.tryParse(inventoryQuantity ?? '0') ?? 0;

  bool get isDiscounted => priceOldInt > priceInt && priceOldInt > 0;

  bool get inStock => stock > 0;
}
