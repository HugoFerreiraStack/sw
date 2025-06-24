import 'package:flutter/material.dart';
import 'package:sw/domain/entities/order.dart';
import 'package:sw/domain/usecases/get_orders.dart';
import 'package:sw/domain/usecases/add_order.dart';
import 'package:sw/domain/usecases/complete_order.dart';

class OrderViewModel extends ChangeNotifier {
  final GetOrders getOrders;
  final AddOrder addOrder;
  final CompleteOrder completeOrder;

  OrderViewModel({
    required this.getOrders,
    required this.addOrder,
    required this.completeOrder,
  });

  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _loading;

  Future<void> loadOrders({bool includeFinished = false}) async {
    _loading = true;
    notifyListeners();

    try {
      _orders = await getOrders(includeFinished: includeFinished);
    } catch (e) {
      _orders = [];
      debugPrint('Erro ao carregar pedidos: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> createOrder(String description) async {
    _loading = true;
    notifyListeners();

    try {
      await addOrder(description);
      await loadOrders();
    } catch (e) {
      debugPrint('Erro ao criar pedido: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> finishOrder(int id) async {
    _loading = true;
    notifyListeners();

    try {
      await completeOrder(id);
      await loadOrders();
    } catch (e) {
      debugPrint('Erro ao finalizar pedido: $e');
    }

    _loading = false;
    notifyListeners();
  }
}
