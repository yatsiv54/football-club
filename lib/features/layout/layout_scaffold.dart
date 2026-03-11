import 'package:flutter/material.dart';

import 'package:fortuna/features/layout/widgets/layout_navbar.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatefulWidget {
  final StatefulNavigationShell shell;
  final bool showBackButton;
  final bool showNavBar;
  final bool showStatButton;
  const LayoutScaffold({
    super.key,
    required this.shell,
    this.showBackButton = false,
    this.showNavBar = false,
    this.showStatButton = false,
  });

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: widget.showNavBar
          ? LayoutNavbar(
              currentIndex: widget.shell.currentIndex,
              onTap: (int value) => widget.shell.goBranch(
                value,
                initialLocation: value == widget.shell.currentIndex,
              ),
            )
          : null,
    );
  }
}
