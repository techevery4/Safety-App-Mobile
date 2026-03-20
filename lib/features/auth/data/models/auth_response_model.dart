class AuthResponseModel {
  final String token;
  final String refreshToken;
  final String userId;

  const AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.userId,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
