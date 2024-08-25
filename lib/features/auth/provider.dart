import 'package:all_in_order/db/models/profile.dart';
import 'package:all_in_order/features/auth/auth_page.dart';
import 'package:all_in_order/features/auth/create_profile_page.dart';
import 'package:all_in_order/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class AuthProvider extends StatefulWidget {
  const AuthProvider({super.key, required this.child});

  final Widget child;

  @override
  State<AuthProvider> createState() => AuthProviderState();
}

class AuthProviderState extends State<AuthProvider> {
  bool profileFetched = false;
  Profile? profile;

  @override
  Widget build(BuildContext context) {
    Stream<AuthState> userStream = supabase.auth.onAuthStateChange;

    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.hasData) {
          AuthState authState = snapshot.data!;

          if (authState.session == null) {
            return AuthScreen();
          } else {
            Session session = authState.session!;

            if (!profileFetched) {
              _fetchProfile(session.user.id);
              return const Text('Loading...');
            } else if (profile == null) {
              return CreateProfilePage();
            } else {
              return MultiProvider(
                providers: [
                  Provider<Session>.value(value: session),
                  Provider<Profile>.value(value: profile!),
                ],
                child: widget.child,
              );
            }
          }
        }

        return const Text('Loading');
      },
    );
  }

  _fetchProfile(String userId) async {
    Profile? fetchedProfile = await Profile.fetch(userId);

    setState(() {
      profileFetched = true;
      profile = fetchedProfile;
    });
  }
}
