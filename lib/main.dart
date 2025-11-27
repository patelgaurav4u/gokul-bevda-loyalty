// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/theme.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() {
  // Initialize ApiService + AuthService here.
  // Replace the baseUrl with your real backend URL.
  final apiService = ApiService.create(baseUrl: 'https://api.yourdomain.com');
  final authService = AuthService(apiService);

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(authService),
      child: MaterialApp(
        title: 'Auth App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        // Start with a small Splash that decides where to navigate
        home: const RootSplash(),
        routes: {
          '/auth': (_) => const AuthScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}

/// Simple splash widget that checks saved token and routes accordingly.
///
/// It uses AuthProvider.loadToken() and then navigates to /home or /auth.
class RootSplash extends StatefulWidget {
  const RootSplash({Key? key}) : super(key: key);

  @override
  State<RootSplash> createState() => _RootSplashState();
}

class _RootSplashState extends State<RootSplash> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait a short moment so splash feels smooth on fast devices
    await Future.delayed(const Duration(milliseconds: 500));

    // AuthProvider is available because MyApp wrapped the tree with it
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = await auth.loadToken();

    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      // token exists -> go to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // no token -> auth screen
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple splash UI
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FlutterLogo(size: 84),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto Flex',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
