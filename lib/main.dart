import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/user_provider.dart';
import 'package:race_tracking_app/ui/menu_screen.dart';
import 'package:race_tracking_app/ui/participant_screen.dart';
import 'package:race_tracking_app/ui/tracking_screen.dart';
import 'package:race_tracking_app/ui/tracking_test.dart';
import 'package:race_tracking_app/utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      title: 'Triathlon Tracker',
      theme: appTheme,
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/participant': (context) => const ParticipantScreen(),
        '/tracker': (context) => const TrackingPage(),
      },
    );
  }
}
