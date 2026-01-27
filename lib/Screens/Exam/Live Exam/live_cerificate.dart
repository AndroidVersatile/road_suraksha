import 'dart:io';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:intl/intl.dart';

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

class LiveCertificateScreen extends StatefulWidget {
  const LiveCertificateScreen({
    required this.score,
    super.key,
  });

  final String score;

  @override
  State<LiveCertificateScreen> createState() => _LiveCertificateScreenState();
}

// class _LiveCertificateScreenState extends State<LiveCertificateScreen> {
//   GlobalKey<State<StatefulWidget>> widget1RenderKey =
//       GlobalKey<State<StatefulWidget>>();
//
//   void downloadTransactionReceipt() async {
//     final boundary = widget1RenderKey.currentContext?.findRenderObject()
//         as RenderRepaintBoundary?;
//     final image = await boundary?.toImage();
//     final byteData = await image?.toByteData(format: ImageByteFormat.png);
//     final imageBytes = byteData?.buffer.asUint8List();
//     if (imageBytes != null) {
//       final directory = await getApplicationDocumentsDirectory();
//       final imagePath =
//           await File('${directory.path}/container_image.jpg').create();
//       await imagePath.writeAsBytes(imageBytes);
//       Share.shareXFiles([XFile(imagePath.path)]);
//     }
//   }
//
//   bool loading = false;
//
//   pdfDownload({
//     required BuildContext contxt,
//     required String name,
//     required String address,
//     required String percentage,
//   }) async {
//     loading = true;
//     setState(() {});
//     final pdf = pw.Document();
//     var image = await rootBundle.load(Assets.certificate);
//     final imageBytes = image.buffer.asUint8List();
//     pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
//     pdf.addPage(
//       pw.Page(
//         margin: pw.EdgeInsets.zero,
//         pageFormat: PdfPageFormat.a4,
//         orientation: pw.PageOrientation.portrait,
//         build: (pw.Context context) => pw.Center(
//           child: pw.Container(
//             alignment: pw.Alignment.center,
//             height: contxt.screenHeight,
//             // width: 40c0,
//             child: pw.Stack(children: [
//               image1,
//               pw.Positioned(
//                   top: contxt.screenHeight - (contxt.screenHeight * 0.56),
//                   left: contxt.screenWidth - (contxt.screenWidth*0.74 ),
//                   child: pw.Text(
//                     name,
//                     style: pw.TextStyle(
//                       // color: Colors.orange,
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   )),
//               pw.Positioned(
//                   top: contxt.screenHeight - (contxt.screenHeight * 0.52),
//                   left: contxt.screenWidth - (contxt.screenWidth*0.74 ),
//                   child: pw.Text(
//                     address,
//                     style: pw.TextStyle(
//                       // color: Colors.orange,
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   )),
//               pw.Positioned(
//                   top: contxt.screenHeight - (contxt.screenHeight * 0.39),
//                   right: contxt.screenWidth - (contxt.screenWidth * 0.58),
//                   child: pw.Text(
//                     percentage,
//                     style: pw.TextStyle(
//                       // color: Colors.orange,
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   )),
//             ]),
//           ),
//         ),
//       ),
//     );
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/certificate.pdf");
//
//     await file.writeAsBytes(await pdf.save());
//     print(file.path);
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
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Certificate'),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Color(0xFF850000),
//               ),
//             ),
//             height: context.screenHeight,
//             width: context.screenWidth,
//             padding: AppTheme.screenPadding,
//             child: Stack(
//               children: [
//                 Image.asset(
//                   Assets.certificate,
//                   height: 600,
//                   width: context.screenWidth,
//                   fit: BoxFit.contain, // Change this line
//                 ),
//                 Positioned(
//                   top: 282,
//                   left: 80,
//                   child: Text(
//                     '${provider.userModel?.studentName}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 295,
//                   left: 40,
//                   child: Text(
//                     '${provider.userModel?.address}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 330,
//                   right: 250,
//                   child: Text(
//                     percentage.toStringAsFixed(2),
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 397,
//                   left: 50,
//                   child: Text(
//                     '${provider.userModel?.rts}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 408,
//                   left: 50,
//                   child: Text(
//                     '${provider.userModel?.address}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (loading)
//             Positioned(
//               child: Container(
//                 height: context.screenHeight,
//                 width: context.screenWidth,
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
//                   percentage: percentage.toStringAsFixed(2),
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
///
// class _LiveCertificateScreenState extends State<LiveCertificateScreen> {
//   GlobalKey<State<StatefulWidget>> widget1RenderKey =
//   GlobalKey<State<StatefulWidget>>();
//
//   void downloadTransactionReceipt() async {
//     final boundary = widget1RenderKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//     final image = await boundary?.toImage();
//     final byteData = await image?.toByteData(format: ImageByteFormat.png);
//     final imageBytes = byteData?.buffer.asUint8List();
//     if (imageBytes != null) {
//       final directory = await getApplicationDocumentsDirectory();
//       final imagePath = await File('${directory.path}/container_image.jpg').create();
//       await imagePath.writeAsBytes(imageBytes);
//       Share.shareXFiles([XFile(imagePath.path)]);
//     }
//   }
//
//   bool loading = false;
//
//   pdfDownload({
//     required BuildContext contxt,
//     required String name,
//     required String address,
//     required String percentage,
//     required String rtsDate, // New parameter for formatted date
//   }) async {
//     loading = true;
//     setState(() {});
//     final pdf = pw.Document();
//     var image = await rootBundle.load(Assets.certificate);
//     final imageBytes = image.buffer.asUint8List();
//     pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
//
//     pdf.addPage(
//       pw.Page(
//         margin: pw.EdgeInsets.zero,
//         pageFormat: PdfPageFormat.a4,
//         orientation: pw.PageOrientation.portrait,
//         build: (pw.Context context) => pw.Stack(
//           children: [
//             image1,
//             // Name
//             pw.Positioned(
//               top: 183,
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
//               top: 198,
//               left: 120,
//               child: pw.Text(
//                 address,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             // Percentage
//             pw.Positioned(
//               top: 253,
//               left: 200,
//               child: pw.Text(
//                 percentage,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             // Date (Formatted from rts)
//             pw.Positioned(
//               top: 377,
//               left: 100,
//               child: pw.Text(
//                 rtsDate,
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             // Location
//             pw.Positioned(
//               top: 358,
//               left: 100,
//               child: pw.Text(
//                 address, // Assuming address is the city/location
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/certificate.pdf");
//     await file.writeAsBytes(await pdf.save());
//     print(file.path);
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
//     // Format the date to show only the date part
//     String formattedDate = '';
//     try {
//       if (provider.userModel?.rts != null && provider.userModel!.rts.isNotEmpty) {
//         // Attempt to parse the date and format it.
//         // Assuming the format is 'dd-MM-yyyy HH:mm:ss'
//         DateTime rtsDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(provider.userModel!.rts);
//         formattedDate = DateFormat('dd-MM-yyyy').format(rtsDateTime);
//       }
//     } catch (e) {
//       print('Error parsing date: $e');
//       formattedDate = provider.userModel?.rts ?? ''; // Fallback to original string if parsing fails
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Certificate'),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Color(0xFF850000),
//               ),
//             ),
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
//                 // Displayed on the screen for preview
//                 Positioned(
//                   top: 282,
//                   left: 80,
//                   child: Text(
//                     '${provider.userModel?.studentName}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 295,
//                   left: 40,
//                   child: Text(
//                     '${provider.userModel?.address}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 330,
//                   right: 250,
//                   child: Text(
//                     percentage.toStringAsFixed(2),
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 // Displaying formatted date (without time)
//                 Positioned(
//                   top: 397,
//
//                   left: 50,
//                   child: Text(
//                     formattedDate,
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//                 // Displaying address for location
//                 Positioned(
//                   top: 408,
//                   left: 50,
//                   child: Text(
//                     '${provider.userModel?.address}',
//                     style: context.textTheme.labelLarge?.copyWith(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 9,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (loading)
//             Positioned(
//               child: Container(
//                 height: context.screenHeight,
//                 width: context.screenWidth,
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
//                   percentage: percentage.toStringAsFixed(2),
//                   rtsDate: formattedDate, // Pass the formatted date
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

///
class _LiveCertificateScreenState extends State<LiveCertificateScreen> {
  GlobalKey<State<StatefulWidget>> widget1RenderKey =
      GlobalKey<State<StatefulWidget>>();

  bool loading = false;
Future<void> pdfDownload({
  required String name,
  required String rank,
  required String rtsDate,
  required String districtName,
  required String blockName,
}) async {
  if (!mounted) return;

  setState(() => loading = true);

  // 🟢 UI ko ek frame dena (IMPORTANT – lag fix)
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    final pdf = pw.Document();

    final imageData = await rootBundle.load(Assets.certificate);
    final bgImage = pw.MemoryImage(imageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Stack(
          children: [
            pw.Image(bgImage),

            pw.Positioned(
              top: 190,
              left: 155,
              child: pw.Text(name,
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
            ),

            pw.Positioned(
              top: 210,
              left: 186,
              child: pw.Text(districtName,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ),

            pw.Positioned(
              top: 210,
              left: 65,
              child: pw.Text(blockName,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ),

            pw.Positioned(
              top: 258,
              left: 165,
              child: pw.Text(rank,
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
            ),

            pw.Positioned(
              top: 372,
              left: 76,
              child: pw.Text(rtsDate,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/certificate.pdf');
    await file.writeAsBytes(await pdf.save());

    if (!mounted) return;

    await Share.shareXFiles([XFile(file.path)],
        text: 'Certificate');

  } catch (e) {
    debugPrint('PDF ERROR: $e');
  } finally {
    if (mounted) {
      setState(() => loading = false);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var percentage = provider.resultExamDetail.first.persantage;
    String districtName = provider.userModel?.districtName ?? 'N/A';
    String blockName = provider.userModel?.blockName ?? 'N/A';
    // Calculate rank and certificate message
    String certificateMsg = '';
    String rank = '';
    double a = percentage;

    if (a < 60) {
      certificateMsg = "";
      rank = "D";
    } else if (a >= 60 && a <= 75) {
      certificateMsg = "";
      rank = "C";
    } else if (a >= 76 && a <= 90) {
      certificateMsg = "";
      rank = "B";
    } else if (a > 90) {
      certificateMsg = "";
      rank = "A";
    } else {
      certificateMsg = "Pay attention to road safety rules";
      rank = "";
    }

    // Format date
    String formattedDate = '';
    try {
      if (provider.userModel?.rts != null &&
          provider.userModel!.rts.isNotEmpty) {
        DateTime rtsDateTime =
            DateFormat('dd-MM-yyyy HH:mm:ss').parse(provider.userModel!.rts);
        formattedDate = DateFormat('dd-MM-yyyy').format(rtsDateTime);
      }
    } catch (e) {
      formattedDate = provider.userModel?.rts ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xFF850000))),
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
                  top: 285,
                  left: 100,
                  child: Text(
                    '${provider.userModel?.studentName}',
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9),
                  ),
                ),
                // Positioned(
                //   top: 295,
                //   left: 40,
                //   child: Text(
                //     '${provider.userModel?.address}',
                //     style: context.textTheme.labelLarge?.copyWith(
                //         color: Colors.orange,
                //         fontWeight: FontWeight.w700,
                //         fontSize: 9),
                //   ),
                // ),

                Positioned(
                  top: 300,
                  left: 132,
                  child: Text(
                    ' $districtName',
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 8),
                  ),
                ),
                // ✅ Block (Preview)
                Positioned(
                  top: 300,
                  left: 38,
                  child: Text(
                    ' $blockName',
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 8),
                  ),
                ),
                Positioned(
                  top: 333,
                  left: 110,
                  child: Text(
                    rank, // Show rank instead of percentage
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 7),
                  ),
                ),
                Positioned(
                  top: 330,
                  left: 64,
                  // right: 40,
                  child: Text(
                    certificateMsg, // Show message under rank
                    style: context.textTheme.labelSmall
                        ?.copyWith(color: Colors.orange, fontSize: 8),
                  ),
                ),
                Positioned(
                  top: 402,
                  left: 50,
                  child: Text(
                    formattedDate,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9),
                  ),
                ),
                // Positioned(
                //   top: 408,
                //   left: 50,
                //   child: Text(
                //     '${provider.userModel?.address}',
                //     style: context.textTheme.labelLarge?.copyWith(
                //         color: Colors.orange,
                //         fontWeight: FontWeight.w700,
                //         fontSize: 9),
                //   ),
                // ),
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
                      // pdfDownload(
                      //   contxt: context,
                      //   name: provider.userModel!.studentName,
                      //   // address: provider.userModel!.address,
                      //   rank: rank,
                      //   certificateMsg: certificateMsg,
                      //   rtsDate: formattedDate,
                      //   districtName: districtName, // ✅ ADD
                      //   blockName: blockName, // ✅ ADD
                      // );
                      pdfDownload(
                        name: provider.userModel!.studentName.toString(),
                        rank: rank.toString(),
                        rtsDate: formattedDate.toString(),
                        districtName: districtName.toString(),
                        blockName: blockName.toString(),
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
