// lib/core/api/dio_client.dart
import 'package:dio/dio.dart';
import 'package:sw/core/constants/app_constants.dart';
import '../auth/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioClient._internal(this.dio, this.tokenStorage);

  factory DioClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.defaultTimeout,
        receiveTimeout: AppConstants.defaultTimeout,
        contentType: 'application/json',
      ),
    );

    final tokenStorage = TokenStorage(dio);

    dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage, dio: dio));

    return DioClient._internal(dio, tokenStorage);
  }
}
