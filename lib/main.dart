import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/periodic_table_screen.dart';
import 'theme/app_theme.dart';

import 'data/element_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ElementaApp());
}

class ElementaApp extends StatelessWidget {
  final ElementRepository? repository;

  const ElementaApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elementa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: PeriodicTableScreen(repository: repository),
    );
  }
}
