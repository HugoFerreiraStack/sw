
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/core/constants/app_constants.dart';
import 'package:sw/domain/entities/auth_status_enum.dart';

class AuthViewModel extends ChangeNotifier {
  final TokenStorage tokenStorage;

  AuthStatus _status = AuthStatus.loading;
  AuthStatus get status => _status;

  AuthViewModel({required this.tokenStorage}) {
    loginAutomatic();
  }

  Future<void> loginAutomatic() async {
    try {
      final token = await tokenStorage.getToken();

      if (token != null && token.isValid()) {
        _status = AuthStatus.authenticated;
      } else {
        final success = await tokenStorage.loginWithPassword(
          username: AppConstants.userName,
          password: AppConstants.userPassword,
          clientId: 'user',
          scope: 'user offline_access',
        );
        log('Login success: ${success.toJson()}');
        _status =
            success.isValid() ? AuthStatus.authenticated : AuthStatus.error;
      }
    } catch (e) {
      log('Login error: $e');
      _status = AuthStatus.error;
    }

    notifyListeners();
  }
}
