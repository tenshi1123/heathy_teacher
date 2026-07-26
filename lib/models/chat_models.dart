class ChatModel {
  final String chatName;
  final String chatType;
  final String teacherName;
  final String teacherAvatar;
  final String createdAt;
  final String content;
  final String chatId;
  final String messageType;
  final String senderId;

  ChatModel({
    required this.chatName,
    required this.chatType,
    required this.teacherName,
    required this.teacherAvatar,
    required this.createdAt,
    required this.content,
    required this.chatId,
    required this.messageType,
    required this.senderId,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatName: json['chat_name'] ?? '',
      chatType: json['chat_type'] ?? '',
      teacherName:
          json['teachers_chat_full_name'] ??
          json['customer_chat_full_name'] ??
          '',
      teacherAvatar:
          json['teachers_chat_avatar'] ?? json['customer_chat_avatar'] ?? '',
      createdAt: json['created_at'] ?? '',
      content: json['content'] ?? '',
      chatId: json['chat_id'] ?? '',
      messageType: json['message_type'] ?? '',
      senderId: json['sender_id'] ?? '',
    );
  }
}

class ChatMessageModel {
  final String content;
  final String senderId;
  final String messageType;
  final String senderType;
  final DateTime createdAt;
  final String customerName;
  final String userName;
  final String teacherName;
  ChatMessageModel({
    required this.content,
    required this.senderId,
    required this.messageType,
    required this.senderType,
    required this.createdAt,
    required this.customerName,
    required this.userName,
    required this.teacherName,
  });
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: json['content'] ?? '',
      senderId: json['sender_id'] ?? '',
      messageType: json['message_type'] ?? '',
      senderType: json['sender_type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      customerName: json['customer_full_name'] ?? '',
      userName: json['user_name'] ?? '',
      teacherName: json['teachers_full_name'] ?? '',
    );
  }
}

class MessageModel {
  final String content;
  final List<String> image;
  final DateTime createdAt;
  final String id;
  final String chatMessageId;
  final String customerId;
  final String lectureId;
  final String type;

  MessageModel({
    required this.content,
    required this.image,
    required this.createdAt,
    required this.id,
    required this.chatMessageId,
    required this.customerId,
    required this.lectureId,
    required this.type,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'] ?? '',
      image: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      id: json['id'] ?? '',
      chatMessageId: json['chat_message_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      lectureId: json['user_id'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class ConverastionModel {
  final String id;
  final String fullName;
  final String email;
  final String message;

  ConverastionModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.message,
  });
  factory ConverastionModel.fromJson(Map<String, dynamic> json) {
    return ConverastionModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class UserResponse {
  final List<LecturerModel> data;

  UserResponse({required this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      data: (json['data']['lecturers'] as List)
          .map((i) => LecturerModel.fromJson(i))
          .toList(),
    );
  }
}

class LecturerModel {
  final String? avatar;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? courseTypeId;
  final String? courseScheduleId;

  LecturerModel({
    this.avatar,
    this.userId,
    this.fullName,
    this.email,
    this.courseTypeId,
    this.courseScheduleId,
  });

  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      avatar: json['avatar'] ?? json['img'],
      userId: json['id'] ?? json['course_schedule_id'],
      fullName: json['full_name'] ?? json['course_type_name'] ?? json['name'],
      email: json['email'] as String?,
      courseTypeId: json['course_type_id'] as String?,
      courseScheduleId: json['course_schedule_id'] as String?,
    );
  }
}

class ChatCourseModel {
  final LecturerModel? courseSchedule;
  final List<MessageModel>? listMessage;
  ChatCourseModel({this.courseSchedule, this.listMessage});

  factory ChatCourseModel.fromJson(Map<String, dynamic> json) {
    return ChatCourseModel(
      courseSchedule: json['course_schedule'] != null
          ? LecturerModel.fromJson(json['course_schedule'])
          : null,
      listMessage: json['value'] != null
          ? (json['value'] as List)
                .map((i) => MessageModel.fromJson(i))
                .toList()
          : null,
    );
  }
}
