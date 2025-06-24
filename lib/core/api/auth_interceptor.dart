import 'dart:async';
import 'package:dio/dio.dart';
import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;

  AuthInterceptor({required this.tokenStorage, required this.dio});

  bool _isRefreshing = false;
  final List<Function(Response)> _retryQueue = [];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final newToken = await tokenStorage.refreshAccessToken();

        // Atualiza o header do request original com novo token
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // Refaz a requisição original com novo token
        final response = await dio.fetch(requestOptions);

        // Processa fila de requisições pendentes
        for (var callback in _retryQueue) {
          callback(response);
        }
        _retryQueue.clear();

        handler.resolve(response);
      } catch (e) {
        // Falha no refresh token - propaga erro para o app
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else if (err.response?.statusCode == 401 && _isRefreshing) {
      final completer = Completer<Response>();
      _retryQueue.add((response) => completer.complete(response));
      final response = await completer.future;
      handler.resolve(response);
    } else {
      handler.next(err);
    }
  }
}
