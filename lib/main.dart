import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_constants.dart';
import 'config/app_theme.dart';
import 'config/supabase_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    ChangeNotifierProvider<AppProvider>(
      create: (_) => AppProvider(),
      child: const SprintAiApp(),
    ),
  );
}

class SprintAiApp extends StatefulWidget {
  const SprintAiApp({super.key});

  @override
  State<SprintAiApp> createState() => _SprintAiAppState();
}

class _SprintAiAppState extends State<SprintAiApp> {
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.setUser(Supabase.instance.client.auth.currentUser);
      _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((
        data,
      ) async {
        provider.setUser(data.session?.user);
        if (data.session?.user != null) {
          final dbService = DatabaseService();
          final conversations = await dbService.fetchConversations(
            data.session!.user.id,
          );
          provider.setConversations(conversations);
        } else {
          provider.setConversations([]);
        }
      });
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
