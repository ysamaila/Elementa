import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/periodic_table_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F172A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ElementaApp());
}

class ElementaApp extends StatelessWidget {
  const ElementaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elementa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3B82F6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF1E293B),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const PeriodicTableScreen(),
    );
  }
}
