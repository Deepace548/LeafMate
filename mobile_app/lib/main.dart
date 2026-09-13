import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/plant_storage_service.dart';
import 'screens/auth/registration_screen.dart';   // ← change this import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantStorageService(),
      child: MaterialApp(
        title: 'LeafMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RegistrationScreen(),     // ← set this as home
      ),
    );
  }
}