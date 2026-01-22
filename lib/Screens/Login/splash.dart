// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:gauvigyaan/constants/assets.dart';
// import 'package:gauvigyaan/constants/common_text.dart';
// import 'package:gauvigyaan/theme/app_theme.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../constants/app_cache.dart';
// import '../../../../routing/app_pages.dart';
// import '../../../../widgets/video_player.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   AppCache cache = AppCache();
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), () async {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//           overlays: SystemUiOverlay.values);
//
//       if (mounted) {
//         await cache.isUserLoggedIn()
//             ? context.go(
//                 AppPages.home,
//                 // pathParameters: {"index": '0'},
//               )
//             : context.go(AppPages.login);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     return Scaffold(
//         // backgroundColor: Colors.blueGrey,
//         body: Container(
//       height: context.screenHeight,
//       width: context.screenWidth,
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//         image: AssetImage(
//           Assets.homeBG,
//         ),
//         fit: BoxFit.fill,
//       )),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(Assets.appLogo).animate().scale(
//                 duration: const Duration(
//                   milliseconds: 1500,
//                 ),
//               ),
//           AppTheme.verticalSpacing(mul: 5),
//           // AnimatedTextKit(
//           //   animatedTexts: [
//           //     TypewriterAnimatedText(CommonText.appName,
//           //         cursor: '',
//           //         speed: Duration(
//           //           milliseconds: 400,
//           //         )),
//           //   ],
//           // ),
//           Text(
//             CommonText.appName,
//             style: context.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ).animate().scale(duration: const Duration(milliseconds: 1500))
//         ],
//       ),
//     ));
//   }
// }
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_cache.dart';
import '../../../../routing/app_pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppCache cache = AppCache();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      if (mounted) {
        bool loggedIn = await cache.isUserLoggedIn();
        if (loggedIn) {
          context.go(AppPages.home);
        } else {
          context.go(AppPages.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.splash),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
