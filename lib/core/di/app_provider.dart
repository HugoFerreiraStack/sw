import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sw/core/api/dio_client.dart';
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/data/repositories/order_repository_impl.dart';
import 'package:sw/domain/usecases/get_orders.dart';
import 'package:sw/domain/usecases/add_order.dart';
import 'package:sw/domain/usecases/complete_order.dart';
import 'package:sw/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sw/presentation/viewmodels/order_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> build() {
    final dioClient = DioClient.create();

    final dio = dioClient.dio;
    final tokenStorage = dioClient.tokenStorage;

    final orderRepository = OrderRepositoryImpl(dio);

    return [
      ChangeNotifierProvider<AuthViewModel>(
        create: (_) => AuthViewModel(tokenStorage: tokenStorage),
      ),
      ChangeNotifierProvider<OrderViewModel>(
        create: (_) => OrderViewModel(
          getOrders: GetOrders(orderRepository),
          addOrder: AddOrder(orderRepository),
          completeOrder: CompleteOrder(orderRepository),
        ),
      ),
      Provider<TokenStorage>.value(value: tokenStorage),
    ];
  }
}
