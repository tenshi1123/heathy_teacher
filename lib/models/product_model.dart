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

  CourseModel({required this.id, required this.name, required this.image});
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
