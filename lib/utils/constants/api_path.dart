class ApiPath {
  //baseurl

  static const String hocvienUrl = 'https://lms.kiddo.hvg.edu.vn/api';

  //api về đăng nhập, các thông tin của học sinh
  static const String refreshToken = '$hocvienUrl/refresh_token/';
  static const String login = '$hocvienUrl/login';

  //Thông tin và đổi thông tin học viên
  static const String profile = '$hocvienUrl/user/info';
  static const String changePassword = '$hocvienUrl/profile/change_password';
  static const String changeAvatar = '$hocvienUrl/change_avatar';
  static const String userInfo = '$hocvienUrl/user/info';
  static const String changeInfo = '$hocvienUrl/user/info/update';
  static const String updateAvatar = '$hocvienUrl/user/update/avatar';

  //đăng nhập nhiều tài khoản
  static const String multiCustomer = '$hocvienUrl/parents/children';

  //danh sách giáo viên
  static const String lecture = '$hocvienUrl/chat/lecture';
  static const String listMessage = '$hocvienUrl/chat/lecture/message';
  static const String sendMessage = '$hocvienUrl/chat/lecture/message/send';
  //Ưu đãi
  static const String discount = '$hocvienUrl/discount';
  static const String detailDiscount = '$hocvienUrl/discount/detail';
  //Lấy danh sách danh mục
  static const String category = '$hocvienUrl/category';
  static const String library = '$hocvienUrl/category/detail';
  // lịch học
  static const String listSchedule = '$hocvienUrl/schedule';
  //class
  static const String apiClass = '$hocvienUrl/class';
  static const String detailClass = '$hocvienUrl/class/detail';
  //Danh sách tin tức
  static const String post = '$hocvienUrl/post';
  static const String postDetail = '$hocvienUrl/post/detail';

  //Danh sách khóa học video
  static const String listLessonVideo = '$hocvienUrl/lesson';
  //Danh sách Topical
  static const String listTopical = '$hocvienUrl/lesson/topical';
  //Danh sách bài giảng
  static const String listLecture = '$hocvienUrl/lesson/topical/video';
  //Chi tiết 1 video
  static const String detailLesson = '$hocvienUrl/lesson/topical/video/detail';
  //Diem danh
  static const String diemDanh = '$hocvienUrl/checkin';
  static const String detailDiemdanh = '$hocvienUrl/detail_diem_danh';
  static const String notification = '$hocvienUrl/notification';
  static const String chat = '$hocvienUrl/chat';
  static const String teacherChat = 'api/teachers/chat';
  static const String chatTeacherCustomer =
      '$hocvienUrl/chat_teachers_customer';
  static const String chatTeacher = '$hocvienUrl/chat_messages';
  static const String sendImageMessage = '$hocvienUrl/send_chat_img';
  static const String listTeachers = '$hocvienUrl/list_teachers';
  //Lịch thi
  static const String offlineExamSchedule = '$hocvienUrl/offline_exam_schedule';
  static const String changeCoso = '$offlineExamSchedule/change_coso';
  static const String changeDay = '$offlineExamSchedule/change_day';
  static const String dangKyThi = '$offlineExamSchedule/dang_ky';

  //Bài tập + báo báo cáo học tập + feedback
  static const String baiTap = '$hocvienUrl/homework';
  static const String detailBaiTap = '$hocvienUrl/mycourse/detail_exercise';
  static const String reportExercise = '$hocvienUrl/bao_cao_hoc_tap';
  static const String listFeedback = '$hocvienUrl/feedback';
  static const String detailsFeedback = '$hocvienUrl/detail_danh_gia';
  static const String policy = '$hocvienUrl/policy';
  //Khóa học của tôi khoa hoc
  static const String myCourse = '$hocvienUrl/mycourse';
  static const String detailMyCourse = '$myCourse/detail';
  static const String detailBaoCao = '$myCourse/detail/bao_cao';
  static const String myCoursedetailBaiTap = '$myCourse/detail/bai_tap';
  //Chi tiet khoa hoc
  static const String coureDetail = '$hocvienUrl/course/detail';
  //Xin nghi
  static const String xinNghi = '$hocvienUrl/student/leave';
  //Buổi học
  static const String detailBuoihoc = '$apiClass/detail/buoi_hoc';
  static const String uploadBtvn = '$apiClass/detail/buoi_hoc/upload';
  static const String submitExeTL = '$myCourse/submit_exercise_tu_luan';
  static const String submitTracNghiem = '$myCourse/nop_bai_trac_nghiem';
  static const String viewTracNghiem = '$myCourse/view_trac_nghiem';
  static const String viewTestDone = '$myCourse/xem_lai_bai_trac_nghiem';
  //quà tặng
  static const String gift = '$hocvienUrl/gift';
  static const String giftChange = '$hocvienUrl/gift/change';
  //payment
  static const String payment = '$hocvienUrl/paymented';
  static const String payment2 = '$hocvienUrl/payment';
  static const String detailPayment = '$hocvienUrl/payment/detail';
  static const String uploadTransaction =
      '$hocvienUrl/payment/upload_transaction_transfer';
  //mời bạn
  static const String inviteFriend = '$hocvienUrl/invite-friend';
  //push onesignal
  static const String pushOnesignal = '$hocvienUrl/onesignal';
  //api do oneSignal cung cấp
  // static const String oneSignal =
  //     'https://api.onesignal.com/notifications?app_id=1f643336-9d73-4c65-ac00-38d499b8c462';
}
