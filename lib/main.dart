import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'theme.dart';

// Usa alias para evitar colisiones de nombres
import 'pages/home_page.dart' as home;
import 'pages/chatbot/chatbot_page.dart' as chat;
import 'pages/forums/forums_page.dart' as forums;
import 'pages/events/events_page.dart' as events;
import 'pages/tokens/tokens_page.dart' as tokens;

void main() {
  Animate.restartOnHotReload = true;
  runApp(const ArgumentaApp());
}

class ArgumentaApp extends StatelessWidget {
  const ArgumentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argumenta',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _Shell(),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell({super.key});
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _index = 0;

  // 👇 NO uses `const [...]` en la lista; pon `const` en cada widget que lo soporte.
  late final List<Widget> _tabs = <Widget>[
    const home.HomePage(),
    const chat.ChatbotPage(),
    const forums.ForumsPage(),
    const events.EventsPage(),
    const tokens.TokensPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final content = IndexedStack(
      key: ValueKey(_index),
      index: _index,
      children: _tabs,
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: 250.ms,
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeInQuad,
        child: content
            .animate()
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.02, end: 0, duration: 220.ms),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chatbot'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Foros'),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Eventos'),
          NavigationDestination(icon: Icon(Icons.token_outlined), selectedIcon: Icon(Icons.token), label: 'Tokens'),
        ],
      ),
    );
  }
}
