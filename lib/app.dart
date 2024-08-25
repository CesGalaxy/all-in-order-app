import 'package:all_in_order/features/auth/provider.dart';
import 'package:all_in_order/features/home/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AllInOrderApp extends StatelessWidget {
  const AllInOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All In Order',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      home: const AuthProvider(
        child: HomeNavigation()
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(primary: Colors.red),
    useMaterial3: true,
  );
}