import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _turns = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRotation();
    _navigateNext();
  }

  void _startRotation() {
    _timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() {
        _turns += 0.1;
      });
    });
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool('hasLaunched') ?? false;
    final nextRoute = hasLaunched ? '/home' : '/welcome';

    await prefs.setBool('hasLaunched', true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(nextRoute);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedRotation(
              turns: _turns,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: 48,
                child: Image.asset('assets/images/loader.png'),
              ),
            ),
            const SizedBox(height: 30),
            Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
