import 'package:flutter/material.dart';

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tokens')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.token, size: 72),
          const SizedBox(height: 12),
          const Text('Tu saldo: 120', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              onPressed: () {},
              child: const Text('Canjear (placeholder)'),
            ),
          ),
        ],
      ),
    );
  }
}
