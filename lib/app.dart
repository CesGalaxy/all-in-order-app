import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:all_in_order/modules/auth/widgets/controllers/middleware.dart';
import 'package:all_in_order/modules/home/widgets/providers.dart';
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
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: AuthMiddleware(child: HomeProviders()),
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
