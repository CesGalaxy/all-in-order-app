import 'package:all_in_order/const.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseProjectURL,
    anonKey: supabaseAnonKey,
  );

  runApp(const AllInOrderApp());
}