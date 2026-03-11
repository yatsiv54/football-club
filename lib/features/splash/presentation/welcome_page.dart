import 'package:flutter/material.dart';
import 'package:fortuna/core/widgets/custom_save_button.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Transform.translate(
              offset: Offset(0, -40),
              child: Image.asset('assets/images/welcome.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Welcome to Fortuna\n Football Hub'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                Text(
                  'Your all-in-one space to organize matches, trainings, your squad, and personal progress.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(letterSpacing: 0.2),
                ),
                CustomSaveButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  title: 'Get started',
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
