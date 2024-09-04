import 'package:all_in_order/modules/auth/widgets/auth_page.dart';
import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:all_in_order/modules/auth/widgets/create_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthMiddleware extends StatefulWidget {
  const AuthMiddleware({super.key, required this.child});

  final Widget child;

  @override
  State<AuthMiddleware> createState() => AuthMiddlewareState();
}

class AuthMiddlewareState extends State<AuthMiddleware> {
  bool profileFetched = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, child) {
        if (auth.error != null) {
          return const Text('Error');
        } else if (auth.session == null) {
          return AuthScreen();
        } else if (!profileFetched && auth.profile == null) {
          auth.fetchProfile().then((_) {
            // TODO: profileFetched = true;
          });
          return const Text('Loading...');
        } else if (auth.profile == null) {
          return CreateProfilePage();
        } else {
          return child!;
        }
      },
      child: widget.child,
    );
  }
}
