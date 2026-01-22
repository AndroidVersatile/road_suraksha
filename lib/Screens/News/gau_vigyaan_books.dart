import 'package:flutter/material.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GauVigyaanBooks extends StatefulWidget {
  const GauVigyaanBooks({super.key});

  @override
  State<GauVigyaanBooks> createState() => _GauVigyaanBooksState();
}

class _GauVigyaanBooksState extends State<GauVigyaanBooks> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<HomeProvider>().getGauVigyaanBooks();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('गौ माता के बारे में'),
      ),
      body: Container(
        height: context.screenHeight,
        margin: AppTheme.boxPadding,
        child: ListView.builder(
          itemCount: provider.gauMataBooks.length,
          itemBuilder: (context, index) {
            var book = provider.gauMataBooks[index];
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
