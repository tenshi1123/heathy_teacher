class PaymentModel {
  final String orderId;
  final String amount;
  final String note;
  final DateTime paymentDate;
  final String title;
  final String paymentMethod;
  final String userName;

  PaymentModel({
    required this.orderId,
    required this.amount,
    required this.note,
    required this.paymentDate,
    required this.title,
    required this.paymentMethod,
    required this.userName,
  });
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json["order_id"] ?? "",
      amount: json["amount"] ?? "",
      note: json["note"] ?? "",
      paymentDate: DateTime.parse(json["payment_date"]),
      // paymentDate: json["payment_date"] ?? "",
      title: json["title"] ?? "",
      paymentMethod: json["payment_method_name"] ?? "",
      userName: json["user_name"] ?? "",
    );
  }
}

class PayCodeModel {
  final String message;
  final int orderId;
  final int price;
  final String customerCode;
  final String payCode;
  final String bankAccount;
  final String bankCode;
  final String bankName;
  final String bankOwner;
  final bool hasFreeGift;
  final dynamic isLogin;
  final dynamic courseScheduleId;

  PayCodeModel({
    required this.message,
    required this.orderId,
    required this.price,
    required this.customerCode,
    required this.payCode,
    required this.bankAccount,
    required this.bankCode,
    required this.bankName,
    required this.bankOwner,
    required this.hasFreeGift,
    this.isLogin,
    this.courseScheduleId,
  });
  factory PayCodeModel.fromJson(Map<String, dynamic> json) {
    return PayCodeModel(
      message: json["message"] ?? "",
      orderId: json["order_id"] ?? 0,
      price: json["price"] ?? 0,
      customerCode: json["customer_code"] ?? "",
      payCode: json["pay_code"] ?? "",
      bankAccount: json["bank_account"] ?? "",
      bankCode: json["bank_code"] ?? "",
      bankName: json["bank_name"] ?? "",
      bankOwner: json["bank_owner"] ?? "",
      hasFreeGift: json["has_free_gift"] ?? false,
      isLogin: json["is_login"],
      courseScheduleId: json["course_schedule_id"],
    );
  }
}

class OrderResponse {
  String? type;
  OrderData? data;

  OrderResponse({this.type, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      type: json['type'] as String?,
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data?.toJson(),
    };
  }
}

class OrderData {
  int? orderId;
  int? orderType;
  String? orderTypeLabel;
  String? customerCode;
  String? userName;
  Customer? customer;
  List<OrderItem>? items;
  List<dynamic>? paymentHistory;
  PaymentInfo? paymentInfo;
  String? payCode;
  BankInfo? bankInfo;

  OrderData({
    this.orderId,
    this.orderType,
    this.orderTypeLabel,
    this.customerCode,
    this.userName,
    this.customer,
    this.items,
    this.paymentHistory,
    this.paymentInfo,
    this.payCode,
    this.bankInfo,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['order_id'] as int?,
      orderType: json['order_type'] as int?,
      orderTypeLabel: json['order_type_label'] as String?,
      customerCode: json['customer_code'] as String?,
      userName: json['user_name'] as String?,
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : null,
      paymentHistory: json['payment_history'] as List<dynamic>?,
      paymentInfo: json['payment_info'] != null
          ? PaymentInfo.fromJson(json['payment_info'])
          : null,
      payCode: json['pay_code'] as String?,
      bankInfo: json['bank_info'] != null ? BankInfo.fromJson(json['bank_info']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_type': orderType,
      'order_type_label': orderTypeLabel,
      'customer_code': customerCode,
      'user_name': userName,
      'customer': customer?.toJson(),
      'items': items?.map((i) => i.toJson()).toList(),
      'payment_history': paymentHistory,
      'payment_info': paymentInfo?.toJson(),
      'pay_code': payCode,
      'bank_info': bankInfo?.toJson(),
    };
  }
}

class Customer {
  String? fullName;
  String? phone;
  String? email;

  Customer({this.fullName, this.phone, this.email});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
    };
  }
}

class OrderItem {
  int? stt;
  String? type;
  String? name;
  num? price;
  int? quantity;
  num? lineTotal;

  OrderItem({
    this.stt,
    this.type,
    this.name,
    this.price,
    this.quantity,
    this.lineTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      stt: json['stt'] as int?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      quantity: json['quantity'] as int?,
      lineTotal: json['line_total'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stt': stt,
      'type': type,
      'name': name,
      'price': price,
      'quantity': quantity,
      'line_total': lineTotal,
    };
  }
}

class PaymentInfo {
  num? totalAmount;
  num? discountAmount;
  num? priceGiaoTrinh;
  num? priceDongPhuc;
  num? cashDeduction;
  num? valuePercent;
  num? accumulatePoint;
  num? freeShip;
  num? daThanhToan;
  num? finalTotalAmount;
  String? paymentMethodName;

  PaymentInfo({
    this.totalAmount,
    this.discountAmount,
    this.priceGiaoTrinh,
    this.priceDongPhuc,
    this.cashDeduction,
    this.valuePercent,
    this.accumulatePoint,
    this.freeShip,
    this.daThanhToan,
    this.finalTotalAmount,
    this.paymentMethodName,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      totalAmount: json['total_amount'] as num?,
      discountAmount: json['discount_amount'] as num?,
      priceGiaoTrinh: json['price_giao_trinh'] as num?,
      priceDongPhuc: json['price_dong_phuc'] as num?,
      cashDeduction: json['cash_deduction'] as num?,
      valuePercent: json['value_percent'] as num?,
      accumulatePoint: json['accumulate_point'] as num?,
      freeShip: json['free_ship'] as num?,
      daThanhToan: json['da_thanh_toan'] as num?,
      finalTotalAmount: json['final_total_amount'] as num?,
      paymentMethodName: json['payment_method_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'price_giao_trinh': priceGiaoTrinh,
      'price_dong_phuc': priceDongPhuc,
      'cash_deduction': cashDeduction,
      'value_percent': valuePercent,
      'accumulate_point': accumulatePoint,
      'free_ship': freeShip,
      'da_thanh_toan': daThanhToan,
      'final_total_amount': finalTotalAmount,
      'payment_method_name': paymentMethodName,
    };
  }
}

class BankInfo {
  String? accountNumber;
  String? bankName;
  String? owner;
  String? bankCode;
  String? qrUrl;

  BankInfo({
    this.accountNumber,
    this.bankName,
    this.owner,
    this.bankCode,
    this.qrUrl,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      accountNumber: json['account_number'] as String?,
      bankName: json['bank_name'] as String?,
      owner: json['owner'] as String?,
      bankCode: json['bank_code'] as String?,
      qrUrl: json['qr_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_name': bankName,
      'owner': owner,
      'bank_code': bankCode,
      'qr_url': qrUrl,
    };
  }
}

class PromoCodeModel {
  final String? id;
  final String? agencyId;
  final String? code;
  final String? value;
  final String? valueType;
  final String? type;
  final String? valuePercent;
  final String? totalPriceMin;
  final String? courseProductId;
  final String? quantity;
  final String? quantityUsed;
  final String? expiryDate;
  final String? isActive;
  final String? memberRanking;
  final String? useAll;
  final String? createdBy;
  final String? createdAt;
  final String? updateAt;
  final String? modifiedBy;
  final String? useOrderFirst;
  final String? productType;
  final String? courseType;
  final String? priceMaxUse;

  PromoCodeModel({
    this.id,
    this.agencyId,
    this.code,
    this.value,
    this.valueType,
    this.type,
    this.valuePercent,
    this.totalPriceMin,
    this.courseProductId,
    this.quantity,
    this.quantityUsed,
    this.expiryDate,
    this.isActive,
    this.memberRanking,
    this.useAll,
    this.createdBy,
    this.createdAt,
    this.updateAt,
    this.modifiedBy,
    this.useOrderFirst,
    this.productType,
    this.courseType,
    this.priceMaxUse,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id']?.toString(),
      agencyId: json['agency_id']?.toString(),
      code: json['code']?.toString(),
      value: json['value']?.toString(),
      valueType: json['value_type']?.toString(),
      type: json['type']?.toString(),
      valuePercent: json['value_percent']?.toString(),
      totalPriceMin: json['total_price_min']?.toString(),
      courseProductId: json['course_product_id']?.toString(),
      quantity: json['quantity']?.toString(),
      quantityUsed: json['quantity_used']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      isActive: json['is_active']?.toString(),
      memberRanking: json['member_ranking']?.toString(),
      useAll: json['use_all']?.toString(),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at']?.toString(),
      updateAt: json['update_at']?.toString(),
      modifiedBy: json['modified_by']?.toString(),
      useOrderFirst: json['use_order_first']?.toString(),
      productType: json['product_type']?.toString(),
      courseType: json['course_type']?.toString(),
      priceMaxUse: json['price_max_use']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_id': agencyId,
      'code': code,
      'value': value,
      'value_type': valueType,
      'type': type,
      'value_percent': valuePercent,
      'total_price_min': totalPriceMin,
      'course_product_id': courseProductId,
      'quantity': quantity,
      'quantity_used': quantityUsed,
      'expiry_date': expiryDate,
      'is_active': isActive,
      'member_ranking': memberRanking,
      'use_all': useAll,
      'created_by': createdBy,
      'created_at': createdAt,
      'update_at': updateAt,
      'modified_by': modifiedBy,
      'use_order_first': useOrderFirst,
      'product_type': productType,
      'course_type': courseType,
      'price_max_use': priceMaxUse,
    };
  }
}
