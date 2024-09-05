import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:all_in_order/modules/auth/widgets/middleware.dart';
import 'package:all_in_order/modules/home/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class AllInOrderApp extends StatelessWidget {
  const AllInOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AuthService(),
      child: MaterialApp(
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
          Locale('ca'), // Valencian
        ],
        home: const AuthMiddleware(child: HomeNavigation()),
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
