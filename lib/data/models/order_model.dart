import 'package:sw/domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.description,
    required super.finished,
    required super.createdAt,
    super.customerName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      description: json['description'],
      finished: json['finished']?? false,
      createdAt: DateTime.parse(json['createdAt']),
      customerName: json['customerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'finished': finished,
      'createdAt': createdAt.toIso8601String(),
      'customerName': customerName
    };
  }
}
