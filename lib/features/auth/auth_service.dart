import 'dart:async';

import 'package:all_in_order/db/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../supabase.dart';

class AuthService extends ChangeNotifier {
  Profile? _profile;
  Session? _session;
  Object? _error;
  StreamSubscription<AuthState>? _authStateChangeSubscription;

  Profile? get profile => _profile;

  Session? get session => _session;

  Object? get error => _error;

  StreamSubscription<AuthState>? get authStateChangeSubscription =>
      _authStateChangeSubscription;

  AuthService() {
    _authStateChangeSubscription = supabase.auth.onAuthStateChange.listen(
      (event) {
        _session = event.session;
        notifyListeners();
      },
      onError: (Object error) {
        print('Error: $error');
        _error = error;
        notifyListeners();
      },
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.session != null) {
      _session = response.session;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _session = null;
    notifyListeners();
  }

  Future fetchProfile() async {
    if (session != null) {
      final Profile? fetchedProfile = await Profile.fetchByUserId(session!.user.id);
      _profile = fetchedProfile;
      notifyListeners();
    }
  }
}
