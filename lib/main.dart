import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/screens/home_screen.dart';
import 'package:race_tracking_app/utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      title: 'Triathlon Tracker',
      theme: appTheme,
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
