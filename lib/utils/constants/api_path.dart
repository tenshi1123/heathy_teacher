class ApiPath {
  //baseurl
  static String baseUrl = '';
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

  //web ngoai
  static String listCourse = '$baseUrl/danh-sach-khoa-hoc';
  static String courseCatalog = '$baseUrl/danh-muc-khoa-hoc';
  static String detailCourse = '$baseUrl/chi-tiet-khoa-hoc';
  static String listProduct = '$baseUrl/danh-sach-san-pham';
  static String productCatalog = '$baseUrl/danh-muc-san-pham';
  static String detailProduct = '$baseUrl/chi-tiet-san-pham';
}
