import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/domain/entities/order.dart';
import 'package:sw/domain/usecases/get_orders.dart';
import 'package:sw/domain/usecases/add_order.dart';
import 'package:sw/domain/usecases/complete_order.dart';

class OrderViewModel extends ChangeNotifier {
  final GetOrders getOrders;
  final AddOrder addOrder;
  final CompleteOrder completeOrder;
  final TokenStorage tokenStorage;

  OrderViewModel({
    required this.getOrders,
    required this.addOrder,
    required this.completeOrder,
    required this.tokenStorage,
  }) {
    loadOrders(includeFinished: true);
  }

  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _loading;

  Future<void> loadOrders({bool includeFinished = true}) async {
    _loading = true;
    notifyListeners();

    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('Token inválido ou não encontrado.');
      }

      if (token.isValid()) {
        _orders = await getOrders(
            includeFinished: includeFinished, token: token.accessToken);
        log('Pedidos carregados: ${_orders.length}');
      } else {
        await tokenStorage.refreshAccessToken().then((newToken) async {
          _orders = await getOrders(
              includeFinished: includeFinished, token: newToken.accessToken);
          log('Pedidos carregados com novo token: ${_orders.length}');
        });
      }
    } catch (e) {
      log('Erro ao carregar pedidos: ${e.toString()}');
      _orders = [];
      log('Erro ao carregar pedidos: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> createOrder(String description) async {
    _loading = true;
    notifyListeners();

    final token = await tokenStorage.getToken();
    if (token == null || !token.isValid()) {
      throw Exception('Token inválido ou não encontrado.');
    }

    try {
      await addOrder(description, token.accessToken);
      await loadOrders();
    } catch (e) {
      debugPrint('Erro ao criar pedido: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> finishOrder(String id) async {
    _loading = true;
    notifyListeners();

    final token = await tokenStorage.getToken();
    if (token == null || !token.isValid()) {
      throw Exception('Token inválido ou não encontrado.');
    }

    try {
      await completeOrder(id, token.accessToken);
      await loadOrders();
    } catch (e) {
      debugPrint('Erro ao finalizar pedido: $e');
    }

    _loading = false;
    notifyListeners();
  }
}
