import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw/presentation/viewmodels/order_viewmodel.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({super.key});

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição do pedido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite uma descrição válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.save),
                label: vm.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Criar pedido'),
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          await vm.createOrder(_descriptionController.text);
                          if (mounted) Navigator.of(context).pop();
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
