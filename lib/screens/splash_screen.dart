import 'package:flutter/material.dart';
import 'package:steal_this_app/services/auth_service.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  void _checkProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    var currentUser = AuthService.getCurrentUser();

    if (currentUser == null) {
      var result = await AuthService.signInAnonymously();
      if (result == null) {
        // Ошибка входа
        return;
      }
    }

    // Здесь нужно вызвать FirestoreService.getProfile()
    // Если профиль есть - в ленту, нет - на регистрацию
    // Псевдокод:
    // var profile = await FirestoreService.getProfile();
    // if (profile != null) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //   );
    // } else {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const RegisterScreen()),
    //   );
    // }

    // Пока заглушка, просто в ленту
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
