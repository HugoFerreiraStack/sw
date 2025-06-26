import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sw/core/constants/app_constants.dart';
import 'package:sw/domain/entities/app_token.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client client;
  TokenStorage(this.client);

  static const _tokenKey = 'token';

  /// Salva o token no armazenamento seguro
  Future<void> saveToken(Token token) async {
    await _storage.write(key: _tokenKey, value: jsonEncode(token.toJson()));
  }

  /// Recupera o token do armazenamento seguro
  Future<Token?> getToken() async {
    final tokenJson = await _storage.read(key: _tokenKey);
    if (tokenJson == null) return null;
    return Token.fromJson(jsonDecode(tokenJson));
  }

  /// Remove o token do armazenamento seguro
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Verifica se o token é válido e renova se necessário
  Future<Token> ensureValidToken() async {
    final token = await getToken();
    if (token == null || !token.isValid()) {
      return await refreshAccessToken();
    }
    return token;
  }

  /// Realiza o login com nome de usuário e senha
  Future<Token> loginWithPassword({
    required String username,
    required String password,
    String clientId = 'user',
    String scope = 'user offline_access',
  }) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/connect/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': clientId,
        'scope': scope,
      },
    );

    final token = Token.fromJson(jsonDecode(response.body));
    await saveToken(token);
    return token;
  }

  /// Renova o token usando o refresh token
  Future<Token> refreshAccessToken({String clientId = 'user'}) async {
    final token = await getToken();
    if (token?.refreshToken == null) {
      throw Exception('Refresh token não encontrado.');
    }

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/connect/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': token!.refreshToken,
        'client_id': 'user',
        
      },
    );

    final newToken = Token.fromJson(jsonDecode(response.body));
    await saveToken(newToken);
    return newToken;
  }
}
