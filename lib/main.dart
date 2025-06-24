import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw/core/di/app_provider.dart';
import 'package:sw/presentation/views/root_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppProviders.build(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const RootView(),
    );
  }
}
