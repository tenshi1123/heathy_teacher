class ApiPathTeacher {
  static const String baseUrl = 'https://lms.kiddo.hvg.edu.vn/';
  static const String teachersUrl = '${baseUrl}api/teachers';
  //api về đăng nhập, các thông tin của học sinh
  static const String refreshToken = '$teachersUrl/refresh-token';
  static const String login = '${baseUrl}api/login/teacher';
  //api diem danh
  static const String listStudent = '';
  //api về đăng nhập, các thông tin của học sinh

  static const String getClass = '$teachersUrl/lop-hoc';
  static const String detailsClass = '$teachersUrl/lop-hoc/detail';
  static const String detailBuoihoc = '$teachersUrl/lop-hoc/detail/buoi_hoc';
  //api chi tiet bai tap, de thi
  static const String detailsExam =
      '$teachersUrl/lop-hoc/detail/buoi_hoc/detail_bai_tap_de_thi';
  //chi tiet bai tap tu luan hoc vien lam
  static const String examStudent =
      '$teachersUrl/lop-hoc/detail/buoi_hoc/view_bai_hoc_vien_lam';
  //cham bai
  static const String chamBai =
      '$teachersUrl/lop-hoc/detail/buoi_hoc/cham_bai_hoc_vien_lam';
  //Thông tin và đổi thông tin học viên
  static const String profile = '$teachersUrl/profile';
  //api thông báo
  static const String notification = '$teachersUrl/notification';
  //lich-day
  static const String lichDay = '$teachersUrl/lich-day';
}
