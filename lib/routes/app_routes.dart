import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/mood_journal_screen/mood_journal_screen.dart';

class AppRoutes {
  static const String initial = '/home-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String homeScreen = '/home-screen';
  static const String moodJournalScreen = '/mood-journal-screen';
  static const String authenticationScreen = '/authentication-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    homeScreen: (context) => const HomeScreen(),
    moodJournalScreen: (context) => const MoodJournalScreen(),
    authenticationScreen: (context) => const AuthenticationScreen(),
  };
}