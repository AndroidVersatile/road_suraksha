import 'package:flutter/material.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../routing/app_pages.dart';

class DifferentNewsScreen extends StatefulWidget {
  const DifferentNewsScreen({super.key});

  @override
  State<DifferentNewsScreen> createState() => _DifferentNewsScreenState();
}

class _DifferentNewsScreenState extends State<DifferentNewsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {

        await context.read<HomeProvider>().getDifferentNews();
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('विविद जानकारी'),
      ),
      body: Container(
        height: context.screenHeight,
        margin: AppTheme.boxPadding,
        child: ListView.builder(
          itemCount: provider.differentNews.length,
          itemBuilder: (context, index) {
            var book = provider.differentNews[index];
            return GestureDetector(
              onTap: () {
                provider.currentBookPdf = book;
                context.pushNamed(AppPages.pdfViewer);
              },
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(child: Text('${index + 1}')),
                    // AppTheme.horizontalSpacing(),
                    Text(book.name),
                    // AppTheme.horizontalSpacing(),
                    Icon(Icons.remove_red_eye_outlined)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
