import 'dart:developer';

class Token {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final String scope;
  final DateTime expiration;

  Token({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
    required this.expiration,
    this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int;
    return Token(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
      expiration: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }

  bool isValid() {
    log('Checking token validity: ${DateTime.now()} < $expiration');
    return DateTime.now().isBefore(expiration);
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'scope': scope,
      'expires_in': expiration.difference(DateTime.now()).inSeconds,
    };
  }
}
