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
