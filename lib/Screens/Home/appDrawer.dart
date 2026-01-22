import 'package:flutter/material.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/assets.dart';
import '../../constants/api_urls.dart';
import '../../routing/app_pages.dart';
import 'package:in_app_review/in_app_review.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final InAppReview _inAppReview = InAppReview.instance;

  void rateApp() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      _inAppReview.openStoreListing(
        appStoreId:
            'com.exam.roadsafetyquizapp', // Replace with your app's Play Store ID
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Drawer(
      backgroundColor: context.colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      Assets.quiz,
                    )),
                gradient: LinearGradient(colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primary.withOpacity(0.9),
                ])),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${provider.userModel?.studentName}',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  '${provider.userModel?.mobile}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                      fontWeight: FontWeight.bold

                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("होम"),
            onTap: () {
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("अपना पंजीकरण सुधारे"),
            onTap: () {
              context.pushNamed(AppPages.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text("प्रमाण पत्र देखे"),
            onTap: () {
              context.push(AppPages.certificateList);
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.rate_review),
          //   title: const Text("ऐप रेटिंग"),
          //   onTap: () async {
          //     await launchUrl(Uri.parse(ApiUrls.ApplicationLink));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.adaptive.share_outlined),
          //   title: Text('ऐप शेयर करें'),
          //   onTap: () async {
          //     await provider.getShareAppMessage();
          //     Share.share(
          //       '${provider.shareAppMessage}\n\n ${ApiUrls.ApplicationLink}',
          //       // subject: 'Check out our application',
          //       // subject: lang.shareAppMessage,
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text("लॉग आउट"),
          //   onTap: () {
          //     context.pop();
          //   },
          // ),
          AppTheme.verticalSpacing(mul: 3),
          GestureDetector(
            onTap: () {
              provider.cache.logout();
              context.go(AppPages.login);
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  color: context.colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    AppTheme.horizontalSpacing(),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
