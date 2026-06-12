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
