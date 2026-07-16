class ApiPath {
  //baseurl
  static String baseUrl = 'https://lms.cogiaohealthy.vn/api';
  static String login = '$baseUrl/customer/login';
  static String signup = '$baseUrl/customer/signup';
  static String home = '$baseUrl/customer';
  static String info = '$baseUrl/customer/info';
  static String notification = '$baseUrl/customer/notification';
  static String course = '$baseUrl/customer/course';
  static String courseDetail = '$baseUrl/customer/course/detail';
  static String products = '$baseUrl/customer/products';
  static String calendarOff = "$baseUrl/customer/calendar/off";
  static String pendingPayment = "$baseUrl/customer/pending_payment";
  static String paymentHistory = "$baseUrl/customer/payment_history";
  static String feedBack = '$baseUrl/customer/feedback';
  static String editProfile = '$baseUrl/customer/profile/edit';
  static String changeAvatar = '$baseUrl/customer/profile/change_avatar';
  static String chatCourse = '$baseUrl/customer/chat_course';
  static String sendChatCourse = '$baseUrl/customer/send_chat_course';
  static String infoChatLecturers = '$baseUrl/customer/info_chat_lecturers';
  static String detailChatLecturer = '$baseUrl/customer/detail_chat_lecturers';
  static String sendChatLecturers = '$baseUrl/customer/send_chat_lecturers';
  static String loadChatCourse = '$baseUrl/customer/load_chat_course';
  //web ngoài

  //khóa học
  static String listCourse = '$baseUrl/danh-sach-khoa-hoc';
  static String listCourseOff = '$baseUrl/danh-sach-khoa-hoc-truc-tiep';
  static String courseCatalog = '$baseUrl/danh-muc-khoa-hoc';
  static String detailCourse = '$baseUrl/chi-tiet-khoa-hoc';
  static String coursePayment = '$baseUrl/thanh-toan-khoa-hoc';
  static String playVideo = '$baseUrl/play-video';

  //sản phẩm
  static String listProduct = '$baseUrl/danh-sach-san-pham';
  static String productCatalog = '$baseUrl/danh-muc-san-pham';
  static String detailProduct = '$baseUrl/chi-tiet-san-pham';
  static String productPayment = '$baseUrl/thanh-toan-san-pham';

  //feedback và bài viết
  static String listFeedback = '$baseUrl/danh-sach-feedback';
  static String listBaiviet = '$baseUrl/danh-sach-bai-viet-wp';
  static String detailBaiviet = '$baseUrl/chi-tiet-bai-viet-wp';
}

//api danh sách khóa học chọn setting_course_type là on hay off đều ra cùng 1 danh sách
//api thanh toán sản phẩm lỗi -"Decryption failed or invalid data format."
