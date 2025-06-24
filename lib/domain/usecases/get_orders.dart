import 'package:sw/domain/entities/order.dart';
import 'package:sw/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<List<Order>> call({bool includeFinished = false}) {
    return repository.getOrders(includeFinished: includeFinished);
  }
}
