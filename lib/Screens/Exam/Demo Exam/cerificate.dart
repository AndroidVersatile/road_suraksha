import 'dart:io';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../../widgets/button.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({
    required this.score,
    super.key,
  });

  final String score;

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  GlobalKey<State<StatefulWidget>> widget1RenderKey =
      GlobalKey<State<StatefulWidget>>();

  void downloadTransactionReceipt() async {
    final boundary = widget1RenderKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();
    if (imageBytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          await File('${directory.path}/container_image.jpg').create();
      await imagePath.writeAsBytes(imageBytes);
      Share.shareXFiles([XFile(imagePath.path)]);
    }
  }

  bool loading = false;

  pdfDownload({
    required BuildContext contxt,
    required String name,
    required String address,
    required String percentage,
  }) async {
    loading = true;
    setState(() {});
    final pdf = pw.Document();
    var image = await rootBundle.load(Assets.certificate);
    final imageBytes = image.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            alignment: pw.Alignment.center,
            height: contxt.screenHeight,
            // width: 40c0,
            child: pw.Stack(children: [
              image1,
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.56),
                  left: contxt.screenWidth - (contxt.screenWidth*0.74 ),
                  child: pw.Text(
                    name,
                    style: pw.TextStyle(
                      // color: Colors.orange,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.52),
                  left: contxt.screenWidth - (contxt.screenWidth*0.74 ),
                  child: pw.Text(
                    address,
                    style: pw.TextStyle(
                      // color: Colors.orange,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.39),
                  right: contxt.screenWidth - (contxt.screenWidth * 0.58),
                  child: pw.Text(
                    percentage,
                    style: pw.TextStyle(
                      // color: Colors.orange,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/certificate.pdf");

    await file.writeAsBytes(await pdf.save());
    print(file.path);
    loading = false;
    setState(() {});
    Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var percentage = provider.resultExamDetail.first.persantage;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         pdfDownload();
        //         // downloadPDF(
        //         //     val.url.toString(),
        //         //     'certificate.pdf');
        //       },
        //       icon: const Icon(Icons.download))
        // ],
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(border: Border.all(                      color: Color(0xFF850000),
          )),
          height: context.screenHeight,
          width: context.screenWidth,
          padding: AppTheme.screenPadding,
          // alignment: Alignment.center,
          child: Stack(
              // fit: StackFit.expand,
              // alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.certificate,
                  height: 600,
                  width: context.screenWidth,
                  fit: BoxFit.fill,
                  // alignment: Alignment.center,
                ),
                Positioned(
                    top: 300,
                    left: 70,
                    child: Text(
                      '${provider.userModel?.studentName}',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    )),
                Positioned(
                    top: 320,
                    left: 60,
                    child: Text(
                      '${provider.userModel?.address}',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    )),
                Positioned(
                    top: 415,
                    left: context.screenWidth - (context.screenWidth * 0.40),
                    child: Text(
                      percentage.toStringAsFixed(2),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    )),
              ]),
        ),
        if (loading)
          Positioned(
              // top: 0,
              // bottom: 0,
              // left: 0,
              // right: 0,
              child: Container(
                  height: context.screenHeight,
                  width: context.screenWidth,
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.4),
                  child: CircularProgressIndicator())),
      ]),
      // SfPdfViewer.network(
      //   'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      //   key: _pdfViewerKey,
      // ),
      bottomSheet: !loading
          ? Row(
              children: [
                Expanded(
                  child: CustomElevatedIconBtn(
                    icon: Icons.download,
                    color: context.colorScheme.primary,
                    onPressed: () {
                      pdfDownload(
                        contxt: context,
                        name: provider.userModel!.studentName,
                        address: provider.userModel!.address,
                        percentage: percentage.toStringAsFixed(2),
                      );
                    },
                    text: 'Download Certificate',
                    iconColor: Colors.green,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
