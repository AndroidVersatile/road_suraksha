import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gauvigyaan/routing/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../Screens/Login/splash.dart';
import '../providers/provider_init.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import 'app_pages.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppRouting extends StatefulWidget {
  const AppRouting({Key? key}) : super(key: key);

  @override
  State<AppRouting> createState() => _AppRoutingState();
}

class _AppRoutingState extends State<AppRouting> {
  GoRouter? router;
  String initialRoute = AppPages.splashPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialiseRouting();
    });
  }

  initialiseRouting() async {
    initialRoute = AppPages.splashPath;
    if (mounted) router = buildRouter(context, initialRoute);
    setState(() {});
  }

  final NotificationService notificationService = NotificationService();
  final notificationManager = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    var loading = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          child: SplashScreen(),
        ),
      ),
    );
    if (initialRoute.isEmpty && router == null) {
      return loading;
    }
    if (router?.routerDelegate == null) {
      return loading;
    }
    return Provider(
      create: (context) => Theme.of(context),
      builder: (context, child) {
        return MultiProviderInitialise(
          child: MaterialApp.router(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            title: 'Gauvigyaan',
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routeInformationProvider: router?.routeInformationProvider,
            routeInformationParser: router?.routeInformationParser,
            routerDelegate: router?.routerDelegate,
            theme: AppTheme.lightThemeData,
            darkTheme: AppTheme.darkThemeData,
            backButtonDispatcher: router?.backButtonDispatcher,
          ),
        );
      },
    );
  }
}
