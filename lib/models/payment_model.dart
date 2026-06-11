class PaymentModel {
  final String orderId;
  final String amount;
  final String note;
  final String paymentDate;
  final String title;
  final String paymentMethod;
  final String userName;

  PaymentModel(
    this.orderId,
    this.amount,
    this.note,
    this.paymentDate,
    this.title,
    this.paymentMethod,
    this.userName,
  );
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      json["order_id"] ?? "",
      json["amount"] ?? "",
      json["note"] ?? "",
      json["payment_date"] ?? "",
      json["title"] ?? "",
      json["payment_method_name"] ?? "",
      json["user_name"] ?? "",
    );
  }
}
