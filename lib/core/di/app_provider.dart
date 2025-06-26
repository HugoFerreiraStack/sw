import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sw/core/auth/token_storage.dart';
import 'package:sw/data/repositories/order_repository_impl.dart';
import 'package:sw/domain/usecases/get_orders.dart';
import 'package:sw/domain/usecases/add_order.dart';
import 'package:sw/domain/usecases/complete_order.dart';
import 'package:sw/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sw/presentation/viewmodels/order_viewmodel.dart';
import 'package:http/http.dart' as http;

class AppProviders {
  static List<SingleChildWidget> build() {
    final http.Client baseClient = http.Client();
    final tokenStorage = TokenStorage(baseClient);



    // Repositório de pedidos
    final orderRepository =
        OrderRepositoryImpl( tokenStorage);

    return [
      // ViewModel de autenticação
      ChangeNotifierProvider<AuthViewModel>(
        create: (_) => AuthViewModel(tokenStorage: tokenStorage),
      ),
      // ViewModel de pedidos
      ChangeNotifierProvider<OrderViewModel>(
        create: (_) => OrderViewModel(
          getOrders: GetOrders(orderRepository),
          addOrder: AddOrder(orderRepository),
          completeOrder: CompleteOrder(orderRepository),
          tokenStorage: tokenStorage,
        ),
      ),

      Provider<TokenStorage>.value(value: tokenStorage),
    ];
  }
}
