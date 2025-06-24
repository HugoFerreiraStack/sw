import 'package:dio/dio.dart';
import 'package:sw/core/constants/app_constants.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Dio _dio;

  OrderRepositoryImpl(this._dio);

  @override
  Future<List<Order>> getOrders({bool includeFinished = false}) async {
    final response = await _dio.get(
      AppConstants.ordersEndpoint,
      queryParameters: {
        'includeFinished': includeFinished.toString(),
      },
    );
    return (response.data as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addOrder(String description) async {
    await _dio.post(AppConstants.ordersEndpoint, data: {
      'description': description,
    });
  }

  @override
  Future<void> completeOrder(int id) async {
    await _dio.put('${AppConstants.ordersEndpoint}/$id/finish');
  }
}
