import 'package:flutter/material.dart';
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/core/constants/app_constants.dart';
import 'package:sw/domain/entities/auth_status_enum.dart';

class AuthViewModel extends ChangeNotifier {
  final TokenStorage tokenStorage;

  AuthStatus _status = AuthStatus.loading;
  AuthStatus get status => _status;

  AuthViewModel({required this.tokenStorage});

  Future<void> loginAutomatic() async {
    try {
      final token = await tokenStorage.getAccessToken();
      if (token != null) {
        _status = AuthStatus.authenticated;
      } else {
        final success = await tokenStorage.loginWithPassword(
          username: AppConstants.userName,
          password: AppConstants.userPassword,
          clientId: 'user',
          scope: 'offline_access',
        );
        _status = success ? AuthStatus.authenticated : AuthStatus.error;
      }
    } catch (_) {
      _status = AuthStatus.error;
    }

    notifyListeners();
  }
}
