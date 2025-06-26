import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  ? const Center(
                      child: Text(
                        'Nenhum pedido encontrado',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.orders.length,
                      itemBuilder: (context, index) {
                        final order = vm.orders[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: order.finished ?? false
                                  ? Colors.green
                                  : Colors.orange,
                              child: Icon(
                                order.finished ?? false
                                    ? Icons.check
                                    : Icons.pending,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              order.description,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Criado em: ${DateFormat('dd/MM/yyyy - HH:mm').format(order.createdAt)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (order.finished ?? false)
                                  const Text(
                                    'Status: Concluído',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  )
                                else
                                  const Text(
                                    'Status: Pendente',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: order.finished ?? false
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : ElevatedButton(
                                    onPressed: () => vm.finishOrder(order.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Concluir',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
