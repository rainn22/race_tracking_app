import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/screens/menu_screen.dart';
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

// void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuScreen(),
      title: 'Triathlon Tracker',
      theme: appTheme,
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => const MenuScreen(),
      },
    );
  }
}
