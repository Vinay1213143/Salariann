import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/api_config.dart';
import 'config/router.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/jobs_provider.dart';
import 'providers/companies_provider.dart';
import 'providers/user_provider.dart';
import 'providers/live_jobs_provider.dart';
import 'providers/indian_jobs_provider.dart';
import 'providers/indian_companies_provider.dart';

class SalariannApp extends StatelessWidget {
  final SupabaseClient supabaseClient;

  const SalariannApp({
    Key? key,
    required this.supabaseClient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(supabaseClient),
        ),
        ChangeNotifierProvider(
          create: (_) => JobsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompaniesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(supabaseClient),
        ),
        ChangeNotifierProvider(
          create: (_) => LiveJobsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IndianJobsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IndianCompaniesProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Salariann',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
