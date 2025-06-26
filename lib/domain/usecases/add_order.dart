import 'package:sw/domain/repositories/order_repository.dart';

class AddOrder {
  final OrderRepository repository;

  AddOrder(this.repository);

  Future<void> call(String description, String token) =>
      repository.addOrder(description, token);
}
