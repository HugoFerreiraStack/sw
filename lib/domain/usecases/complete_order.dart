import 'package:sw/domain/repositories/order_repository.dart';

class CompleteOrder {
  final OrderRepository repository;

  CompleteOrder(this.repository);

  Future<void> call(String id, String token) => repository.completeOrder(id, token);
}