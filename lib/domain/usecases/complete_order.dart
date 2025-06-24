import 'package:sw/domain/repositories/order_repository.dart';

class CompleteOrder {
  final OrderRepository repository;

  CompleteOrder(this.repository);

  Future<void> call(int id) => repository.completeOrder(id);
}