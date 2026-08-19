import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/configurator_screen.dart';

void main() {
  runApp(const ProviderScope(child: SportsCarConfiguratorApp()));
}

class SportsCarConfiguratorApp extends StatelessWidget {
  const SportsCarConfiguratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apex GT | 2026 Configurator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0C10),
        primaryColor: const Color(0xFF0070F3),
      ),
      home: const ConfiguratorScreen(),
    );
  }
}
