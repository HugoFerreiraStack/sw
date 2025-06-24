import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw/presentation/viewmodels/order_viewmodel.dart';
import 'package:sw/presentation/views/create_order_view.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.loadOrders(),
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => vm.loadOrders(),
              child: vm.orders.isEmpty
                  ? const Center(child: Text('Nenhum pedido encontrado'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.orders.length,
                      itemBuilder: (context, index) {
                        final order = vm.orders[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(order.description),
                            subtitle: Text(
                              'Criado em: ${order.createdAt.toLocal().toString().substring(0, 16)}',
                            ),
                            trailing: order.completed
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : IconButton(
                                    icon: const Icon(Icons.check),
                                    tooltip: 'Finalizar',
                                    onPressed: () => vm.finishOrder(order.id),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateOrderView()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Pedido'),
      ),
    );
  }
}
