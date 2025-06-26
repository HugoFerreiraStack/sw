import 'package:sw/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({bool includeFinished = false, String? token});
  Future<void> addOrder(String description, String token);
  Future<void> completeOrder(String id, String token);
}
