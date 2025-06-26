import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw/presentation/viewmodels/order_viewmodel.dart';

class CreateOrderView extends StatelessWidget {
  const CreateOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OrderViewModel>();
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descrição do Pedido',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite a descrição do pedido',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await vm.createOrder(descriptionController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Criar Pedido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
