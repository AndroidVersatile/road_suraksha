import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_provider.dart';
import 'loginProvider.dart';

class MultiProviderInitialise extends StatelessWidget {
  const MultiProviderInitialise({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(
          create: (context) => LoginProvider(),
        ),
        ListenableProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: child,
    );
  }
}
