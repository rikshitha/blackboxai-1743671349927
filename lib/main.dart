import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_monitor/screens/auth/login_screen.dart';
import 'package:health_monitor/services/auth_service.dart';
import 'package:health_monitor/utils/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HealthMonitorApp());
}

class HealthMonitorApp extends StatelessWidget {
  const HealthMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Health Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.getRoutes(),
        home: const LoginScreen(),
      ),
    );
  }
}
