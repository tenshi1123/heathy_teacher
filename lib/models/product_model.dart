import 'dart:convert';
import 'dart:ui';

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

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.isCourse = false,
  });
}

class CourseModel {
  final String id;
  final String name;
  final String image;
  String? price;
  CourseModel({
    required this.id,
    required this.name,
    required this.image,
    this.price,
  });
}

final List<CourseModel> courses = [
  CourseModel(
    id: "1",
    name: "Nguyên liệu - máy lớp nấu ăn Eatclean",
    image: "assets/images/sp1.jpg",
  ),
  CourseModel(
    id: "2",
    name: "Nguyên liệu - máy lớp chuyển giao mô hình kinh doanh chay ",
    image: "assets/images/sp2.jpg",
  ),
  CourseModel(
    id: "3",
    name: "Nguyên liệu - máy lớp bánh lạnh nguyên cám chuyên sâu",
    image: "assets/images/sp3.jpg",
  ),
  CourseModel(
    id: "4",
    name: "Nguyên liệu - máy lớp trà sữa hạt và trà trái cây healthy",
    image: "assets/images/sp4.jpg",
  ),
  CourseModel(
    id: "5",
    name: "Nguyên liệu - máy lớp bánh pizza men tươi healthy",
    image: "assets/images/sp5.png",
  ),
  CourseModel(id: "6", name: "", image: "assets/images/sp6.png"),
  CourseModel(
    id: "7",
    name: "Nguyên liệu - máy lớp bánh yến mạch sữa chua healthy",
    image: "assets/images/sp7.png",
  ),
  CourseModel(
    id: "8",
    name: "Nguyên liệu - máy lớp bánh mì vòng nguyên cám healthy",
    image: "assets/images/sp8.jpg",
  ),
  CourseModel(
    id: "9",
    name: "Nguyên liệu - máy lớp bánh bao nguyên cám healthy",
    image: "assets/images/sp9.png",
  ),
  CourseModel(
    id: "10",
    name: "Nguyên liệu - máy lớp kẹo dẻo trái cây và thảo mộc Đài Loan",
    image: "assets/images/sp10.jpg",
  ),
  CourseModel(
    id: "11",
    name: "Nguyên liệu - máy lớp sữa chua ",
    image: "assets/images/sp11.jpg",
  ),
  CourseModel(
    id: "12",
    name: "Nguyên liệu - máy lớp sữa hạt",
    image: "assets/images/sp12.jpg",
  ),
  CourseModel(
    id: "13",
    name: "Nguyên liệu - máy lớp thạch trái cây kem sữa hạt healthy",
    image: "assets/images/sp13.jpg",
  ),
];
final List<CourseModel> coursesDetail = [
  CourseModel(
    id: "1",
    name: "Đường hoa dừa ăn kiêng hữu cơ Sokafarm 300G",
    image: "assets/images/detail1.png",
    price: "150.000đ",
  ),
  CourseModel(
    id: "2",
    name: "Bột ớt paprika Mccomick 40g",
    image: "assets/images/detail2.png",
    price: "81.000đ",
  ),
  CourseModel(
    id: "3",
    name: "Dấm trắng Heinz 473ml",
    image: "assets/images/detail3.png",
    price: "71.280đ",
  ),
  CourseModel(
    id: "4",
    name: "Bột tỏi hữu cơ Vinasamex 50g",
    image: "assets/images/detail4.png",
    price: "83.280đ",
  ),
  CourseModel(
    id: "5",
    name: "Bột tỏi sả hữu cơ Vinasamex 50g",
    image: "assets/images/detail5.png",
    price: "75.600đ",
  ),
  CourseModel(
    id: "6",
    name: "Bột hành hữu cơ Vinasamex 50g",
    image: "assets/images/detail6.png",
    price: "75.600đ",
  ),
];

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

String courseSectionToJson(List<CourseSection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseSection {
  final String? id;
  final String? name;
  final List<Lesson> lesson;

  CourseSection({this.id, this.name, required this.lesson});

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: json['id'],
      name: json['name'],
      // Kiểm tra nếu mảng lesson null thì trả về mảng rỗng
      lesson: json['lesson'] != null
          ? List<Lesson>.from(json['lesson'].map((x) => Lesson.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lesson': List<dynamic>.from(lesson.map((x) => x.toJson())),
    };
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
      name: json['name'],
      slug: json['slug'],
      time: json['time'],
      isTrial: json['is_trial'],
      documentFilesActive: json['document_files_active'],
      examActive: json['exam_active'],
      locked: json['locked'],
      lessonContent: json['lesson_content'],
      lessonType: json['lesson_type'],
      streamingUrl: json['streaming_url'],
      muxAssetId: json['mux_asset_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessons_id': lessonsId,
      'name': name,
      'slug': slug,
      'time': time,
      'is_trial': isTrial,
      'document_files_active': documentFilesActive,
      'exam_active': examActive,
      'locked': locked,
      'lesson_content': lessonContent,
      'lesson_type': lessonType,
      'streaming_url': streamingUrl,
      'mux_asset_id': muxAssetId,
    };
  }
}
