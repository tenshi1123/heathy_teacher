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

class PostModel {
  final String title;
  final String permalink;
  final String date;
  final String thumbnail;
  final String description;
  final String? slug;
  final String? content;

  PostModel({
    required this.title,
    required this.permalink,
    required this.date,
    required this.thumbnail,
    required this.description,
    this.slug,
    this.content,
  });

  // Hàm chuyển đổi từ JSON map sang Model
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'] ?? '',
      permalink: json['permalink'] ?? '',
      date: json['date'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
      slug: json['slug'], // Nếu không có, sẽ tự động nhận giá trị null
      content: json['content'], // Nếu không có, sẽ tự động nhận giá trị null
    );
  }
  // Hàm chuyển đổi ngược từ Model về JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'permalink': permalink,
      'date': date,
      'thumbnail': thumbnail,
      'description': description,
      if (slug != null) 'slug': slug,
      if (content != null) 'content': content,
    };
  }
}

class PolicyModel {
  final PolicyItemModel? policyCustomer;
  final PolicyItemModel? policyPoint;

  PolicyModel({
    this.policyCustomer,
    this.policyPoint,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      policyCustomer: json['policy_customer'] != null
          ? PolicyItemModel.fromJson(json['policy_customer'])
          : null,
      policyPoint: json['policy_point'] != null
          ? PolicyItemModel.fromJson(json['policy_point'])
          : null,
    );
  }
}

class PolicyItemModel {
  final String? id;
  final String? type;
  final String? content;
  final String? createdAt;

  PolicyItemModel({
    this.id,
    this.type,
    this.content,
    this.createdAt,
  });

  factory PolicyItemModel.fromJson(Map<String, dynamic> json) {
    return PolicyItemModel(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
      content: json['content']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
