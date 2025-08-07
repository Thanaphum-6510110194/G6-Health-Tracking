import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_tracking/screens/meal_logging.dart';
import 'package:provider/provider.dart'; // เพิ่ม import provider
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_notifier.dart'; // เพิ่ม import AuthNotifier
import 'screens/dashboard.dart';
import 'screens/daily_habits.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // ห่อ MyApp ด้วย ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => AuthNotifier(), // สร้าง instance ของ AuthNotifier
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/daily_habits': (context) => const HomeScreen(),
        '/meal_logging': (context) => const MealLoggingScreen(),
        
      },

    );
  }
}
