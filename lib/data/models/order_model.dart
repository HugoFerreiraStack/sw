import 'package:sw/domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.description,
    required super.completed,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      description: json['description'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
