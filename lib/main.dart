import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/providers/user_provider.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';

import 'package:race_tracking_app/repositories/participant_repository.dart';
import 'package:race_tracking_app/repositories/race_stage_repository.dart';
import 'package:race_tracking_app/repositories/segment_time_repository.dart';

import 'package:race_tracking_app/ui/add_particpant_screen.dart';
import 'package:race_tracking_app/ui/menu_screen.dart';
import 'package:race_tracking_app/ui/race_manager_screen.dart';
import 'package:race_tracking_app/ui/splash_screen.dart';
import 'package:race_tracking_app/ui/tracking_screen.dart';
import 'package:race_tracking_app/utils/theme.dart';
import 'package:race_tracking_app/ui/participant_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const baseUrl = 'https://race-tracking-app-c58e7-default-rtdb.asia-southeast1.firebasedatabase.app/';

  const segmentCollection = 'segment_times';

  final participantRepository = FirebaseParticipantRepository();
  final raceStageRepository = FirebaseRaceStageRepository();
  final segmentTimeRepository = FirebaseSegmentTimeRepository(
    baseUrl: baseUrl,
    collection: segmentCollection,
  );

  final raceStageProvider = RaceStageProvider(raceStageRepository);
  await raceStageProvider.loadRaceStage();

  final segmentTimeProvider = SegmentTimeProvider(segmentTimeRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider(participantRepository)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider.value(value: raceStageProvider),
        ChangeNotifierProvider.value(value: segmentTimeProvider),
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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/menu': (context) => const MenuScreen(),
        '/manager': (context) => const ManagerScreen(),
        '/participant': (context) => const ParticipantListScreen(),
        '/addParticipant': (context) => const BulkAddParticipantsScreen(),
        '/tracker': (context) => const TrackingScreen(),
      },
    );
  }
}
