import 'dart:io';
import 'dart:ui';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/routing/app_routing.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/assets.dart';
import '../../providers/home_provider.dart';
import '../../widgets/button.dart';

class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
      ),
      body: Container(
        padding: AppTheme.boxPadding,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.grey.shade200,
              title: const Text('Live Paper Certificate'),
              trailing: const Icon(Icons.remove_red_eye_rounded),
              onTap: () {
                context.push(AppPages.liveCertificateList);
              },
            ),
            AppTheme.verticalSpacing(),
            // ListTile(
            //   tileColor: Colors.grey.shade200,
            //   title: const Text('Demo Paper Certificate'),
            //   trailing: const Icon(Icons.remove_red_eye_rounded),
            //   onTap: () {
            //     context.push(AppPages.demoCertificateList);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class ViewLiveCertificateScreen extends StatefulWidget {
  const ViewLiveCertificateScreen({super.key});

  @override
  State<ViewLiveCertificateScreen> createState() =>
      _ViewLiveCertificateScreenState();
}

class _ViewLiveCertificateScreenState extends State<ViewLiveCertificateScreen> {
  GlobalKey<State<StatefulWidget>> widget1RenderKey = GlobalKey<State<StatefulWidget>>();

  bool loading = false;

  // ------------------ PDF Download Logic ------------------
  pdfDownload({
    required BuildContext contxt,
    required String name,
    required String address,
    required String rank,
    required String certificateMsg,
    required String rtsDate,
  }) async {
    loading = true;
    setState(() {});

    final pdf = pw.Document();
    final image = await rootBundle.load(Assets.certificate);
    final imageBytes = image.buffer.asUint8List();
    pw.Image bgImage = pw.Image(pw.MemoryImage(imageBytes));

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) => pw.Stack(
          children: [
            bgImage,
            // Name
            pw.Positioned(
              top: 204,
              left: 155,
              child: pw.Text(
                name,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
              ),
            ),
            // Date
            pw.Positioned(
              top: 360,
              left: 80,
              child: pw.Text(
                rtsDate,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
            ),
            // Rank
            pw.Positioned(
              top: 256,
              left: 450,
              child: pw.Text(
                rank,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
              ),
            ),
            // Certificate Message
            pw.Positioned(
              top: 330,
              left: 80,
              right: 40,
              child: pw.Text(
                certificateMsg,
                style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12),
              ),
            ),
            // Address
            pw.Positioned(
              top: 377,
              left: 80,
              child: pw.Text(
                address,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/certificate.pdf");
    await file.writeAsBytes(await pdf.save());

    loading = false;
    setState(() {});
    Share.shareXFiles([XFile(file.path)]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getCertificateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var certificate = provider.certificateModel;

    // If no data, show no-data screen
    if (certificate.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Certificate')),
        body: Center(child: Image.asset(Assets.noData)),
      );
    }

    // ---------- Calculate Rank & Certificate Message ----------
    String certificateMsg = '';
    String rank = '';
    double a = double.tryParse(certificate.first.persantage) ?? 0;

    if (a < 60) {
      rank = "D";
    } else if (a >= 60 && a <= 75) {
      rank = "C";
    } else if (a >= 76 && a <= 90) {
      rank = "B";
    } else if (a > 90) {
      rank = "A";
    } else {
      certificateMsg = "सड़क सुरक्षा नियमो पर ध्यान दें |";
      rank = "";
    }

    // ---------- Format Date ----------
    String formattedDate = '';
    try {
      if (provider.userModel?.rts != null && provider.userModel!.rts.isNotEmpty) {
        DateTime rtsDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(provider.userModel!.rts);
        formattedDate = DateFormat('dd-MM-yyyy').format(rtsDateTime);
      }
    } catch (e) {
      formattedDate = provider.userModel?.rts ?? '';
    }

    // ------------------ UI ------------------
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFF850000))),
            height: context.screenHeight,
            width: context.screenWidth,
            padding: AppTheme.screenPadding,
            child: Stack(
              children: [
                Image.asset(
                  Assets.certificate,
                  height: 600,
                  width: context.screenWidth,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  top: 295,
                  left: 100,
                  child: Text(
                    '${provider.userModel?.studentName}',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
                Positioned(
                  top: 333,
                  right: 95,
                  child: Text(
                    rank,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 7,
                    ),
                  ),
                ),
                Positioned(
                  top: 330,
                  left: 64,
                  right: 40,
                  child: Text(
                    certificateMsg,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.orange,
                      fontSize: 8,
                    ),
                  ),
                ),
                Positioned(
                  top: 397,
                  left: 50,
                  child: Text(
                    formattedDate,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
                Positioned(
                  top: 408,
                  left: 50,
                  child: Text(
                    '${provider.userModel?.address}',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.4),
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
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
                  rank: rank,
                  certificateMsg: certificateMsg,
                  rtsDate: formattedDate,
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

// class _ViewLiveCertificateScreenState extends State<ViewLiveCertificateScreen> {
//   GlobalKey<State<StatefulWidget>> widget1RenderKey =
//   GlobalKey<State<StatefulWidget>>();
//
//   bool loading = false;
//
//   pdfDownload({
//     required BuildContext contxt,
//     required String name,
//     required String address,
//     required String rank,
//     required String certificateMsg,
//     required String rtsDate, // formatted date
//   }) async {
//     loading = true;
//     setState(() {});
//
//     final pdf = pw.Document();
//     final image = await rootBundle.load(Assets.certificate);
//     final imageBytes = image.buffer.asUint8List();
//     pw.Image bgImage = pw.Image(pw.MemoryImage(imageBytes));
//
//     pdf.addPage(
//       pw.Page(
//         margin: pw.EdgeInsets.zero,
//         pageFormat: PdfPageFormat.a4,
//         orientation: pw.PageOrientation.portrait,
//         build: (pw.Context context) => pw.Stack(
//           children: [
//             bgImage,
//             // Name
//             pw.Positioned(
//               top: 204,
//               left: 155,
//               child: pw.Text(
//                 name,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             // Address
//             pw.Positioned(
//               top: 360,
//               left: 80,
//               child: pw.Text(
//                 rtsDate,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             // Rank
//             pw.Positioned(
//               top: 256,
//               left: 450,
//               child: pw.Text(
//                 rank,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             // Certificate Message
//             // pw.Positioned(
//             //   top: 270,
//             //   left: 80,
//             //   right: 40,
//             //   child: pw.Text(
//             //     certificateMsg,
//             //     style: pw.TextStyle(
//             //       fontWeight: pw.FontWeight.normal,
//             //       fontSize: 12,
//             //     ),
//             //   ),
//             // ),
//             // Date
//             pw.Positioned(
//               top: 377,
//               left: 80,
//               child: pw.Text(
//                 address,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             // // Location (address/city)
//             // pw.Positioned(
//             //   top: 408,
//             //   left: 100,
//             //   child: pw.Text(
//             //     address,
//             //     style: pw.TextStyle(
//             //       fontWeight: pw.FontWeight.bold,
//             //       fontSize: 12,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/certificate.pdf");
//     await file.writeAsBytes(await pdf.save());
//
//     loading = false;
//     setState(() {});
//     Share.shareXFiles([XFile(file.path)]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<HomeProvider>(context);
//     var percentage = provider.resultExamDetail.first.persantage;
//
//     // Calculate rank and certificate message
//     String certificateMsg = '';
//     String rank = '';
//     double a = percentage;
//
//     if (a < 60) {
//       certificateMsg =
//       "";
//       rank = "D";
//     } else if (a >= 60 && a <= 75) {
//       certificateMsg =
//       "";
//       rank = "C";
//     } else if (a >= 76 && a <= 90) {
//       certificateMsg =
//       "";
//       rank = "B";
//     } else if (a > 90) {
//       certificateMsg =
//       "";
//       rank = "A";
//     } else {
//       certificateMsg = "सड़क सुरक्षा नियमो पर ध्यान दें |";
//       rank = "";
//     }
//
//     // Format date
//     String formattedDate = '';
//     try {
//       if (provider.userModel?.rts != null &&
//           provider.userModel!.rts.isNotEmpty) {
//         DateTime rtsDateTime =
//         DateFormat('dd-MM-yyyy HH:mm:ss').parse(provider.userModel!.rts);
//         formattedDate = DateFormat('dd-MM-yyyy').format(rtsDateTime);
//       }
//     } catch (e) {
//       formattedDate = provider.userModel?.rts ?? '';
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Certificate')),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(border: Border.all(color: Color(0xFF850000))),
//             height: context.screenHeight,
//             width: context.screenWidth,
//             padding: AppTheme.screenPadding,
//             child: Stack(
//               children: [
//                 Image.asset(
//                   Assets.certificate,
//                   height: 600,
//                   width: context.screenWidth,
//                   fit: BoxFit.contain,
//                 ),
//                 Positioned(
//                   top: 295,
//                   left: 100,
//                   child: Text(
//                     '${provider.userModel?.studentName}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 9),
//                   ),
//                 ),
//                 // Positioned(
//                 //   top: 295,
//                 //   left: 40,
//                 //   child: Text(
//                 //     '${provider.userModel?.address}',
//                 //     style: context.textTheme.labelLarge?.copyWith(
//                 //         color: Colors.orange,
//                 //         fontWeight: FontWeight.w700,
//                 //         fontSize: 9),
//                 //   ),
//                 // ),
//                 Positioned(
//                   top: 333,
//                   right: 95,
//                   child: Text(
//                     rank, // Show rank instead of percentage
//                     style: context.textTheme.labelLarge?.copyWith(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 7),
//                   ),
//                 ),
//                 Positioned(
//                   top: 330,
//                   left: 64,
//                   right: 40,
//                   child: Text(
//                     certificateMsg, // Show message under rank
//                     style: context.textTheme.labelSmall?.copyWith(
//                         color: Colors.orange, fontSize: 8),
//                   ),
//                 ),
//                 Positioned(
//                   top: 397,
//                   left: 50,
//                   child: Text(
//                     formattedDate,
//                     style: context.textTheme.labelLarge?.copyWith(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 9),
//                   ),
//                 ),
//                 Positioned(
//                   top: 408,
//                   left: 50,
//                   child: Text(
//                     '${provider.userModel?.address}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (loading)
//             Positioned.fill(
//               child: Container(
//                 alignment: Alignment.center,
//                 color: Colors.grey.withOpacity(0.4),
//                 child: const CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//       bottomSheet: !loading
//           ? Row(
//         children: [
//           Expanded(
//             child: CustomElevatedIconBtn(
//               icon: Icons.download,
//               color: context.colorScheme.primary,
//               onPressed: () {
//                 pdfDownload(
//                   contxt: context,
//                   name: provider.userModel!.studentName,
//                   address: provider.userModel!.address,
//                   rank: rank,
//                   certificateMsg: certificateMsg,
//                   rtsDate: formattedDate,
//                 );
//               },
//               text: 'Download Certificate',
//               iconColor: Colors.green,
//             ),
//           ),
//         ],
//       )
//           : null,
//     );
//   }
// }

class ViewDemoCertificateList extends StatefulWidget {
  const ViewDemoCertificateList({super.key});

  @override
  State<ViewDemoCertificateList> createState() =>
      _ViewDemoCertificateListState();
}

class _ViewDemoCertificateListState extends State<ViewDemoCertificateList> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<HomeProvider>().getDemoCertificateList();
      },
    );

    super.initState();
  }

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
                  left: contxt.screenWidth - (contxt.screenWidth * 0.74),
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
                  left: contxt.screenWidth - (contxt.screenWidth * 0.74),
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
    var certificate = provider.demoCertificateModel;
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
      body:  certificate.isEmpty
          ?  Center(
        child: Image.asset(Assets.noData),
      )
          : Stack(children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.green)),
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
                    right: 110,
                    child: Text(
                      certificate.first.persantage,
                      style: context.textTheme.labelLarge?.copyWith(
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
                  child: const CircularProgressIndicator())),
      ]),
      // SfPdfViewer.network(
      //   'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      //   key: _pdfViewerKey,
      // ),
      bottomSheet: !loading
          ?certificate.isEmpty?null: Row(
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
                        percentage: certificate.first.persantage,
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
