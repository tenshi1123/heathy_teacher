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

  //web ngoai
  static String listCourse = '$baseUrl/danh-sach-khoa-hoc';
  static String courseCatalog = '$baseUrl/danh-muc-khoa-hoc';
  static String detailCourse = '$baseUrl/chi-tiet-khoa-hoc';
  static String listProduct = '$baseUrl/danh-sach-san-pham';
  static String productCatalog = '$baseUrl/danh-muc-san-pham';
  static String detailProduct = '$baseUrl/chi-tiet-san-pham';
  static String playVideo = '$baseUrl/play-video';
}

//api thanh toán khóa học đâu?
//api danh sách khóa học chọn setting_course_type là on hay off đều ra cùng 1 danh sách
//api thanh toán sản phẩm lỗi -"Decryption failed or invalid data format."
