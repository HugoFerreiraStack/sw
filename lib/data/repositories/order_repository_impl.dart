import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/core/constants/app_constants.dart';
import 'package:sw/data/models/order_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final TokenStorage tokenStorage;
  OrderRepositoryImpl(this.tokenStorage);

  @override
  Future<List<Order>> getOrders(
      {bool includeFinished = false, String? token}) async {
    final url =
        Uri.parse('${AppConstants.baseUrl}${AppConstants.ordersEndpoint}?includeFinished=$includeFinished');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      switch (response.statusCode) {
        case 200:
          log('Pedidos obtidos com sucesso: ${response.body}');
          final list = jsonDecode(response.body) as List;
          return list.map((json) => OrderModel.fromJson(json)).toList();
        case 204:
          log('Nenhum pedido encontrado.');
          return [];

        case 400:
          log('Erro 400: Requisição inválida - ${response.body}');
          throw Exception('Requisição inválida: ${response.body}');

        case 401:
          log('Erro 401: Token expirado. - ${response.body}');
          final newToken = await tokenStorage.refreshAccessToken();
          log('Token renovado com sucesso: ${newToken.accessToken}');
          return handle401AndRetry(() => getOrders(
              includeFinished: includeFinished, token: newToken.accessToken));

        case 403:
          log('Erro 403: Proibido - ${response.body}');
          throw Exception('Proibido: ${response.body}');
        default:
          throw Exception(
              'Erro desconhecido: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar pedidos');
    }
  }

  @override
  Future<void> addOrder(String description, String token) async {
    final url =
        Uri.parse('${AppConstants.baseUrl}${AppConstants.ordersEndpoint}');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'description': description, 'customerName': 'Cliente Padrão'}),
      );

      log('Status Code: ${response.statusCode}');

      switch (response.statusCode) {
        case 400:
          log('Erro 400: Requisição inválida - ${response.body}');
          throw Exception('Requisição inválida: ${response.body}');
        case 401:
          log('Erro 401: Token expirado. Tentando renovar o token...');
          throw Exception('Token expirado: ${response.body}');
        case 403:
          log('Erro 403: Proibido - ${response.body}');
          throw Exception('Proibido: ${response.body}');
        case 200:
          log('Pedido adicionado com sucesso: ${response.body}');
          break;
        default:
      }
    } catch (e) {
      log('Erro ao adicionar pedido: $e');
      rethrow;
    }
  }

  @override
  Future<void> completeOrder(String id, String token) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.ordersEndpoint}/$id/finish');
    log('URL: $url');
    log('Token: $token');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('Status Code: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception(
            'Erro ao completar pedido: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Erro ao completar pedido: $e');
      rethrow;
    }
  }

  Future<T> handle401AndRetry<T>(Future<T> Function() retryFunction) async {
    try {
      return await retryFunction();
    } catch (e) {
      log('Erro ao renovar o token: $e');
      throw Exception('Erro ao renovar o token');
    }
  }
}
