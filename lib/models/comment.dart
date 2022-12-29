class Comment {
  String nickname;
  String avatar;
  String date;
  String message;

  Comment({
    required this.nickname,
    required this.avatar,
    required this.date,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'avatar': avatar,
      'date': date,
      'message': message,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      nickname: map['nickname'] as String,
      avatar: map['avatar'] as String,
      date: map['date'] as String,
      message: map['message'] as String,
    );
  }
}