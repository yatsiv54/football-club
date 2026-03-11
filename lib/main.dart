import 'package:flutter/material.dart';
import 'package:fortuna/core/DI/DI.dart';
import 'package:fortuna/core/router/router.dart';
import 'package:fortuna/core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: darkTheme,
      ),
    );
  }
}
