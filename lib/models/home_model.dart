class CustomerModel {
  final int course;
  final int paymentHistory;
  final int pendingPayment;
  final int product;
  final int accumulatedPoint;

  CustomerModel(
    this.course,
    this.paymentHistory,
    this.pendingPayment,
    this.product,
    this.accumulatedPoint,
  );
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      json["course"] ?? 0,
      json["paymentHistory"] ?? 0,
      json["pendingPayment"] ?? 0,
      json["product"] ?? 0,
      json["accumulatedPoint"] ?? 0,
    );
  }
}

class UserModel {
  final String? id;
  final String? memberRanking;
  final String? customerCode;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? img;
  final String? accumulatedPoint;

  UserModel({
    this.id,
    this.memberRanking,
    this.customerCode,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.img,
    this.accumulatedPoint,
  });

  // Chuyển từ JSON sang Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      memberRanking: json['member_ranking']?.toString(),
      customerCode: json['customer_code']?.toString(),
      fullName: json['full_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      img: json['img']?.toString(),
      accumulatedPoint: json['accumulated_point']?.toString(),
    );
  }
}
