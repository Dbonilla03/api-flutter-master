class User {
  final int id;
  final String nickname;
  final String email;
  final String token;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'token': token,
    };
  }
}
