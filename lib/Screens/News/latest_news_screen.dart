import 'package:flutter/material.dart';
import 'package:gauvigyaan/constants/common_text.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';

class LatestNewsScreen extends StatefulWidget {
  const LatestNewsScreen({super.key});

  @override
  State<LatestNewsScreen> createState() => _LatestNewsScreenState();
}

class _LatestNewsScreenState extends State<LatestNewsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    context.read<HomeProvider>().getLatestNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ताज़ा जानकारी'),
      ),
      body: Container(
        height: context.screenHeight,
        margin: AppTheme.boxPadding,
        child: ListView.builder(
          itemCount: provider.latestNews.length,
          itemBuilder: (context, index) {
            var news = provider.latestNews[index];
            return Container(
              padding: AppTheme.boxPadding,
              margin: AppTheme.boxPadding,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  spreadRadius: 0.2,
                  blurRadius: 2,
                  color: context.colorScheme.shadow.withOpacity(0.6),
                ),
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(child: Text('${index + 1}')),
                  AppTheme.horizontalSpacing(),
                  Flexible(child: Text(news.ruleText)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
