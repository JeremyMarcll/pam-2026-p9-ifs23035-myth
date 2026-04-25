import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// THEME
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';

// PROVIDERS
import 'providers/motivation_provider.dart';
import 'providers/myth_provider.dart';
import 'providers/auth_provider.dart';

// SCREENS
import 'features/auth/login_screen.dart';
import 'features/myth/myth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MotivationProvider()),
        ChangeNotifierProvider(create: (_) => MythProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],

      child: Consumer2<ThemeNotifier, AuthProvider>(
        builder: (context, theme, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // THEME
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme.themeMode,

            // 🔥 SMART ROUTING
            home: auth.isLoggedIn
                ? MythScreen()   // ✅ kalau sudah login
                : LoginScreen(), // 🔐 kalau belum
          );
        },
      ),
    );
  }
}