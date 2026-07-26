import 'dart:io';

import 'package:dio/dio.dart';
import 'package:heathy_teacher/models/chat_models.dart';
import 'package:heathy_teacher/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {
  Dio dio = Dio();
  Future<List<LecturerModel>> getListLecture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.infoChatLecturers);
    UserResponse responseData = UserResponse.fromJson(response.data);
    List<LecturerModel> users = responseData.data;
    return users;
  }

  Future<bool> sendMessage(String chatId, String message, {File? photo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Map<String, dynamic> requestData = {
        'lecturers_id': int.parse(chatId),
        'content': message,
      };
      if (photo != null) {
        requestData['files[0]'] = await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        );
      }
      FormData formData = FormData.fromMap(requestData);
      Response response = await dio.post(
        ApiPath.sendChatLecturers,
        data: formData,
      );
      return response.data['status'] == 200;
    } on DioException {
      return false;
    }
  }

  Future<bool> sendChatLecturers(
    String chatId,
    String message,
    String courseTypeId, {
    File? photo,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Map<String, dynamic> requestData = {
        'content': message,
        'course_schedule_id': chatId,
        'course_type_id': courseTypeId,
      };
      if (photo != null) {
        requestData['files[0]'] = await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        );
      }
      FormData formData = FormData.fromMap(requestData);
      Response response = await dio.post(
        ApiPath.sendChatCourse,
        data: formData,
      );
      return response.data['status'] == 200;
    } on DioException {
      return false;
    }
  }

  Future<List<MessageModel>> getListMessage({required String lectureId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post('${ApiPath.detailChatLecturer}/$lectureId');

    List<MessageModel> listMessages = response.data['data']['messages']
        .map<MessageModel>((json) => MessageModel.fromJson(json))
        .toList();
    return listMessages;
  }

  Future<ChatCourseModel> getChatCourse({
    required String courseId,
    required String courseType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post('${ApiPath.chatCourse}/$courseId/$courseType');

    ChatCourseModel chatCourse = ChatCourseModel.fromJson(
      response.data['data'],
    );
    return chatCourse;
  }

  Future<List<LecturerModel>> loadChatCourse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.loadChatCourse);
    var users = (response.data['data'] as List)
        .map((i) => LecturerModel.fromJson(i))
        .toList();
    return users;
  }
}
