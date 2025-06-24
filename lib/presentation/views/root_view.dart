import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw/domain/entities/auth_status_enum.dart';
import 'package:sw/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sw/presentation/views/order_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, _) {
        switch (auth.status) {
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return const OrderView();
          case AuthStatus.error:
            return const Scaffold(
              body: Center(child: Text('Erro na autenticação')),
            );
        }
      },
    );
  }
}
