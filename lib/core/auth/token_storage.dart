// lib/core/auth/token_storage.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio dio;

  TokenStorage(this.dio);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  Future<void> saveAccessToken(String token) async =>
      await _storage.write(key: _accessTokenKey, value: token);
  Future<void> saveRefreshToken(String token) async =>
      await _storage.write(key: _refreshTokenKey, value: token);

  Future<bool> loginWithPassword({
    required String username,
    required String password,
    String clientId = 'user',
    String scope = 'user offline_access',
  }) async {
    try {
      final response = await dio.post(
        '/connect/token',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
          'scope': scope,
        },
      );

      final data = response.data;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String?;

      await saveAccessToken(accessToken);
      if (refreshToken != null) {
        await saveRefreshToken(refreshToken);
      }
      return true;
    } catch (e) {
      print('Erro loginWithPassword: $e');
      return false;
    }
  }

  Future<String> refreshAccessToken({
    String clientId = 'user',
  }) async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) throw Exception('Refresh token not found');

    final response = await dio.post(
      '/connect/token',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
      },
    );

    final data = response.data;
    final accessToken = data['access_token'] as String;
    final newRefreshToken = data['refresh_token'] as String?;

    await saveAccessToken(accessToken);
    if (newRefreshToken != null) {
      await saveRefreshToken(newRefreshToken);
    }

    return accessToken;
  }

  Future<void> revokeToken({
    required String token,
    required String tokenTypeHint,
    String clientId = 'user',
  }) async {
    await dio.post(
      '/connect/revocation',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: {
        'client_id': clientId,
        'token': token,
        'token_type_hint': tokenTypeHint,
      },
    );
  }

  Future<void> logout() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    if (accessToken != null) {
      await revokeToken(token: accessToken, tokenTypeHint: 'access_token');
    }
    if (refreshToken != null) {
      await revokeToken(token: refreshToken, tokenTypeHint: 'refresh_token');
    }

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
