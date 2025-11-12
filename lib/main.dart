import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

import 'theme/app_theme.dart';

// Páginas existentes
import 'pages/splash/splash_page.dart';
import 'pages/home_page.dart' as home;
import 'pages/chatbot/chatbot_final_page.dart' as chat;
import 'pages/forums/forums_page.dart' as forums;
import 'pages/events/events_page.dart' as events;
import 'pages/lessons/lessons_page_v2.dart' as lessons;
import 'pages/profile/profile_page.dart' as profile;

// Nuevo: compuerta de autenticación
import 'pages/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Animate.restartOnHotReload = true;
  runApp(const ArgumentaApp());
}

class ArgumentaApp extends StatelessWidget {
  const ArgumentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ArgumentIA',
          debugShowCheckedModeBanner: false,
          theme: AppThemeM3.lightTheme,
          // Muestra login/registro si no hay sesión; si hay sesión, muestra tu shell.
                 home: const SplashPage(),
        );
      },
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

          late final List<Widget> _tabs = const <Widget>[
            home.HomePage(),
            chat.ChatbotFinalPage(),
            forums.ForumsPage(),
            events.EventsPage(),
            lessons.LessonsPageV2(),
            profile.ProfilePage(),
          ];

  @override
  Widget build(BuildContext context) {
    // Solo cargar la página actual para mejor rendimiento
    final content = _tabs[_index];

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
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home), 
            label: 'Inicio'
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline), 
            selectedIcon: Icon(Icons.chat_bubble), 
            label: 'Debate'
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined), 
            selectedIcon: Icon(Icons.forum), 
            label: 'Foros'
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined), 
            selectedIcon: Icon(Icons.event), 
            label: 'Eventos'
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined), 
            selectedIcon: Icon(Icons.school), 
            label: 'Lecciones'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined), 
            selectedIcon: Icon(Icons.person), 
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}
