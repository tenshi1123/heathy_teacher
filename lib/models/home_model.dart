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
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0; // Các trường hợp kiểu dữ liệu lạ khác
    }

    return CustomerModel(
      parseInt(json["course"]),
      parseInt(json["payment_history"]),
      parseInt(json["pending_payment"]),
      parseInt(json["product"]),
      parseInt(json["accumulated_point"]),
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
