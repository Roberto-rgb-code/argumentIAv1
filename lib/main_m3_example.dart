import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'pages/chatbot/chatbot_final_page.dart';
import 'pages/lessons/lessons_page_v2.dart';
import 'pages/forums/forums_m3_page.dart';
import 'pages/events/events_m3_page.dart';
import 'pages/profile/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const DialectaAppM3());
}

class DialectaAppM3 extends StatelessWidget {
  const DialectaAppM3({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Dialecta - Material Design 3',
          debugShowCheckedModeBanner: false,
          
          // Usar el tema M3 personalizado
          theme: AppThemeM3.lightTheme,
          darkTheme: AppThemeM3.darkTheme,
          themeMode: ThemeMode.light,
          
          home: const DialectaHomeM3(),
          
          // Rutas nombradas
          routes: {
            '/chatbot': (context) => const ChatbotFinalPage(),
            '/lessons': (context) => const LessonsPageV2(),
            '/forums': (context) => const ForumsM3Page(),
            '/events': (context) => const EventsM3Page(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}

class DialectaHomeM3 extends StatefulWidget {
  const DialectaHomeM3({super.key});

  @override
  State<DialectaHomeM3> createState() => _DialectaHomeM3State();
}

class _DialectaHomeM3State extends State<DialectaHomeM3> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ChatbotFinalPage(),
    const LessonsPageV2(),
    const ForumsM3Page(),
    const EventsM3Page(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
      // Navigation Bar M3
      bottomNavigationBar: DialectaM3Components.navigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Debate',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_rounded),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Lecciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_rounded),
            selectedIcon: Icon(Icons.forum_rounded),
            label: 'Foros',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_rounded),
            selectedIcon: Icon(Icons.event_rounded),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
