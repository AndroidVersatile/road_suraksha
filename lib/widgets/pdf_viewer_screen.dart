import 'package:flutter/material.dart';
import 'package:gauvigyaan/Screens/Home/noData_screen.dart';
import 'package:gauvigyaan/constants/api_urls.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants/assets.dart';
import '../providers/home_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);

    if (provider.currentBookPdf?.url == null &&
        provider.currentBookPdf!.fileURl!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${provider.currentBookPdf?.name}'),
          // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
        ),
        body: Center(
          child: NoDataScreen(
              subtitle: '',
              buttonText: 'Ok',
              image: Assets.appLogo,
              onPressed: () {
                context.pop();
              },
              title: 'No Data Available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.currentBookPdf?.name}'),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
      ),
      body: SfPdfViewer.network(
          provider.currentBookPdf?.url==null?'${ApiUrls.sliderImageUrl + provider.currentBookPdf!.fileURl!}': '${ApiUrls.sliderImageUrl + provider.currentBookPdf!.url!}'),
    );
  }
}
