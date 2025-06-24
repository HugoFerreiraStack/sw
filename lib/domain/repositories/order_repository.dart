import 'package:sw/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({bool includeFinished = false});
  Future<void> addOrder(String description);
  Future<void> completeOrder(int id);
}
